
#
# Create a filesystem symbolic/soft link.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional initial -s symlink_mode HARD/COPY
# optional initial -m <filelist> to record symlinks
# $1 = target filename or directory
# $2 = link name filename or directory
# every following pair is another symlink
#
# Environment variables:
# VERBOSE
# BRIEFTEXT_WIDTH
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

# check environment variable for verbosity
$verbose = $(GetEnvVar VERBOSE)

# check if we can use $IsWindows
if ($PSVersionTable.PSVersion.Major -eq "5")
{
  if ([System.Environment]::OSVersion.Platform -eq "Win32NT")
  {
    $IsWindows = $true
  }
  else
  {
    $IsWindows = $false
  }
}

#
# Parse command line arguments.
#
$argsindex = 0
$symlink_mode = "HARD"
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex][0] -eq "-")
  {
    $optionchar = $args[$argsindex].Substring(1)
    if ($optionchar -eq "m")
    {
      $argsindex++
      $filelist_filename = $args[$argsindex]
    }
    elseif ($optionchar -eq "s")
    {
      $argsindex++
      $symlink_mode = $args[$argsindex]
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($optionchar)`"."
      ExitWithCode 1
    }
  }
  else
  {
    break
  }
  $argsindex++
}

if (-not $IsWindows)
{
  $symlink_mode = "COPY"
}

# check for at least one symlink target
if ($argsindex -ge $args.Length)
{
  Write-Stderr "$($scriptname): *** Error: no symlink target specified."
  ExitWithCode 1
}

# create filelist if specified
if (![string]::IsNullOrEmpty($filelist_filename))
{
  if (-not (Test-Path $filelist_filename))
  {
    "MAKEFILE_IF_IN_INCLUDED := Y" | Set-Content $filelist_filename
    "SYMLINK_MODE := $($symlink_mode)" | Add-Content $filelist_filename
    "INSTALLED_FILENAMES :=" | Add-Content $filelist_filename
    "ORIGIN_FILENAMES :=" | Add-Content $filelist_filename
  }
}

# loop as long as an argument exists
# when arguments are exhausted, exit
while ($argsindex -lt $args.Length)
{
  $target = $args[$argsindex]
  # then, the 2nd argument of the pair should exist
  if (($argsindex + 1) -ge $args.Length)
  {
    Write-Stderr "$($scriptname): *** Error: no symlink link name specified."
    ExitWithCode 1
  }
  if (Test-Path -Path $target -PathType Leaf)
  {
    $link_name = $args[$argsindex + 1]
    Remove-Item -Path $link_name -Force -ErrorAction Ignore
    if ($symlink_mode -eq "HARD")
    {
      try
      {
        New-Item                       `
          -ItemType HardLink           `
          -Name $link_name             `
          -Value $target               `
          -ErrorAction Stop | Out-Null
      }
      catch
      {
        Write-Stderr "$($scriptname): *** Error: New-Item (HardLink)."
        ExitWithCode 1
      }
    }
    elseif ($symlink_mode -eq "COPY")
    {
      Copy-Item $target -Destination $link_name | Out-Null
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: wrong mode."
      ExitWithCode 1
    }
    if ($verbose -eq "Y")
    {
      Write-Host "$($scriptname): '$($link_name)' -> '$($target)'"
    }
    else
    {
      $briefcommand = "[SYMLINK]".PadRight($(GetEnvVar "BRIEFTEXT_WIDTH"), " ")
      Write-Host "$($briefcommand) '$($link_name)' -> '$($target)'"
    }
    if (![string]::IsNullOrEmpty($filelist_filename))
    {
      "INSTALLED_FILENAMES += $($link_name)" | Add-Content $filelist_filename
      "ORIGIN_FILENAMES += $($target)" | Add-Content $filelist_filename
    }
  }
  elseif (Test-Path -Path $target -PathType Container)
  {
    $link_directory = $args[$argsindex + 1]
    $files = (Get-ChildItem -Force -File $target).Name
    foreach ($f in $files)
    {
      Remove-Item                                             `
        -Path (Join-Path -Path $link_directory -ChildPath $f) `
        -Force -ErrorAction Ignore
      if ($symlink_mode -eq "HARD")
      {
        try
        {
          New-Item                                                `
            -ItemType HardLink                                    `
            -Name (Join-Path -Path $link_directory -ChildPath $f) `
            -Value (Join-Path -Path $target -ChildPath $f)        `
            -ErrorAction Stop | Out-Null
        }
        catch
        {
          Write-Stderr "$($scriptname): *** Error: New-Item (HardLink)."
          ExitWithCode 1
        }
      }
      elseif ($symlink_mode -eq "COPY")
      {
        Copy-Item                                                      `
          (Join-Path -Path $target -ChildPath $f)                      `
          -Destination (Join-Path -Path $link_directory -ChildPath $f) `
          | Out-Null
      }
      else
      {
        Write-Stderr "$($scriptname): *** Error: wrong mode."
        ExitWithCode 1
      }
      if ($verbose -eq "Y")
      {
        Write-Host "$($scriptname): '$($f)' -> '$($target)/$($f)'"
      }
      else
      {
        $briefcommand = "[SYMLINK]".PadRight($(GetEnvVar "BRIEFTEXT_WIDTH"), " ")
        Write-Host "$($briefcommand) '$($f)' -> '$($target)/$($f)'"
      }
      if (![string]::IsNullOrEmpty($filelist_filename))
      {
        "INSTALLED_FILENAMES += $(Join-Path -Path $link_directory -ChildPath $f)" `
        | Add-Content $filelist_filename
        "ORIGIN_FILENAMES += $(Join-Path -Path $target -ChildPath $f)" `
        | Add-Content $filelist_filename
      }
    }
  }
  else
  {
    Write-Stderr "$($scriptname): *** Error: no file or directory `"$($target)`"."
    ExitWithCode 1
  }
  # shift to the next argument pair
  $argsindex += 2
}

ExitWithCode 0

