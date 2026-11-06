
#
# Process object filenames to create a proper list file for the linker.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = <filename>       object list filename
# -a <path_prefix>      prefix to be added to each object file
# -b <BUILD_MODE>       (ignored) "GNATMAKE" or "GPRBUILD"
# -i <ali_unit>         one for every ali instance
# -o <object_directory> (ignored) object directory
# -r <path_prefix>      prefix to be removed from each object file
#
# Environment variables:
# none
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name
$nl = [Environment]::NewLine

################################################################################
# ExitWithCode()                                                               #
#                                                                              #
################################################################################
function ExitWithCode
{
  param($exitcode)
  $host.SetShouldExit($exitcode)
  exit $exitcode
}

################################################################################
# Write-Stderr()                                                               #
#                                                                              #
################################################################################
function Write-Stderr
{
  param([PSObject]$inputobject)
  $outf = if ($host.Name -eq "ConsoleHost")
  {
    [Console]::Error.WriteLine
  }
  else
  {
    $host.UI.WriteErrorLine
  }
  if ($inputobject)
  {
    [void]$outf.Invoke($inputobject.ToString())
  }
  else
  {
    [string[]]$lines = @()
    $input | % { $lines += $_.ToString() }
    [void]$outf.Invoke($lines -Join $nl)
  }
}

################################################################################
# GetEnvVar()                                                                  #
#                                                                              #
################################################################################

$GetEnvironmentVariable_signature = @'
[DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern uint
GetEnvironmentVariable(
  string lpName,
  System.Text.StringBuilder lpBuffer,
  uint nSize
  );
'@
Add-Type                                              `
  -MemberDefinition $GetEnvironmentVariable_signature `
  -Name "Win32GetEnvironmentVariable"                 `
  -Namespace Win32

$gev_buffer_size = 4096
$gev_buffer = [System.Text.StringBuilder]::new($gev_buffer_size)

function GetEnvVar
{
  param([string]$varname)
  if (-not (Test-Path Env:$varname))
  {
    return [string]::Empty
  }
  else
  {
    if ([System.Environment]::OSVersion.Platform -eq "Win32NT")
    {
      $nchars = [Win32.Win32GetEnvironmentVariable]::GetEnvironmentVariable(
                  $varname,
                  $gev_buffer,
                  [uint32]$gev_buffer_size
                  )
      if ($nchars -gt $gev_buffer_size)
      {
        Write-Stderr "$($scriptname): *** Error: GetEnvVar: buffer size < $($nchars)."
        ExitWithCode 1
      }
      return [string]$gev_buffer
    }
    else
    {
      return [string][Environment]::GetEnvironmentVariable($varname)
    }
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

$objs_filename = ""
$path_prefix_add = ""
$build_mode = ""
$implicit_ali_units = New-Object System.Collections.Generic.List[System.Object]
$object_directory = ""
$path_prefix_remove = ""

# parse command line arguments
$argsindex = 0
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex][0] -eq "-")
  {
    $optionchar = $args[$argsindex].Substring(1)
    if ($optionchar -eq "a")
    {
      # path prefix to be added
      $argsindex++
      $path_prefix_add = $($args[$argsindex])
    }
    elseif ($optionchar -eq "b")
    {
      # BUILD_MODE
      $argsindex++
      $build_mode = $args[$argsindex]
    }
    elseif ($optionchar -eq "i")
    {
      # IMPLICIT_ALI_UNITS
      $argsindex++
      $implicit_ali_units.Add($args[$argsindex])
    }
    elseif ($optionchar -eq "o")
    {
      # OBJECT_DIRECTORY
      $argsindex++
      $object_directory = $args[$argsindex]
    }
    elseif ($optionchar -eq "r")
    {
      # path prefix to be removed
      $argsindex++
      $path_prefix_remove = $($args[$argsindex])
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($optionchar)`"."
      ExitWithCode 1
    }
  }
  else
  {
    if ($objs_filename -eq "")
    {
      $objs_filename = $args[$argsindex]
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: too many input files."
      ExitWithCode 1
    }
  }
  $argsindex++
}

if (-not (Test-Path -Path "$($objs_filename)"))
{
  Write-Stderr "$($scriptname): *** Error: $($objs_filename) not found."
  ExitWithCode 1
}

try
{
  $textlines = Get-Content -Path $objs_filename
}
catch
{
  Write-Stderr "$($scriptname): *** Error: processing $($objs_filename)."
  ExitWithCode 1
}

[string]$stdout = ""

$textlines | ForEach-Object `
{
  $textline = $_.Replace("\", "/")
  $found = $false
  foreach ($ali in $implicit_ali_units)
  {
    if ($textline.EndsWith($ali))
    {
      $found = $true
      break
    }
  }
  if (-not $found)
  {
    if (($path_prefix_remove -ne "") -and $textline.StartsWith($path_prefix_remove))
    {
      $textline = $textline.Replace("$($path_prefix_remove)/", "")
    }
    if ($path_prefix_add -ne "")
    {
      $textline = "$($path_prefix_add)/$($textline)"
    }
    $stdout = "$($stdout)$($textline)$($nl)"
  }
}

try
{
  Set-Content -Path $objs_filename -Value $stdout -NoNewLine -Force
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($objs_filename)."
  ExitWithCode 1
}

ExitWithCode 0

