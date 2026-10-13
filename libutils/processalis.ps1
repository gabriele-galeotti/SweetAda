
#
# Process an ALI list file to remove the a prefixed path.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = <filename>  ALI list filename
# -p <path_prefix> path prefix to be removed
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

$alis_filename = ""
$path_prefix = ""

# parse command line arguments
$argsindex = 0
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex][0] -eq "-")
  {
    $optionchar = $args[$argsindex].Substring(1)
    if ($optionchar -eq "p")
    {
      # path prefix
      $argsindex++
      $path_prefix = "$($args[$argsindex])"
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($optionchar)`"."
      ExitWithCode 1
    }
  }
  else
  {
    if ($alis_filename -eq "")
    {
      $alis_filename = $args[$argsindex]
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: too many input files."
      ExitWithCode 1
    }
  }
  $argsindex++
}

if (-not (Test-Path -Path "$($alis_filename)"))
{
  Write-Stderr "$($scriptname): *** Error: $($alis_filename) not found."
  ExitWithCode 1
}

try
{
  $textlines = Get-Content -Path $alis_filename
}
catch
{
  Write-Stderr "$($scriptname): *** Error: processing $($alis_filename)."
  ExitWithCode 1
}

[string]$stdout = ""

$textlines | ForEach-Object `
{
  $textline = $_
  if ($path_prefix -ne "")
  {
    $textline = $textline.Replace("\", "/").Replace("$($path_prefix)/", "")
  }
  $stdout = "$($stdout)$($textline)$($nl)"
}

try
{
  Set-Content -Path $alis_filename -Value $stdout -NoNewLine -Force
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($alis_filename)."
  ExitWithCode 1
}

ExitWithCode 0

