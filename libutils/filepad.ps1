
#
# Pad a file.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = final length or size modulo (allowed specification like "512k")
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

#
# Basic input parameters check.
#
$filename = $args[0]
if ([string]::IsNullOrEmpty($filename))
{
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}
$padstring = [string]$args[1]
if ([string]::IsNullOrEmpty($padstring))
{
  Write-Stderr "$($scriptname): *** Error: no file length specified."
  ExitWithCode 1
}

$last_character = $padstring.Substring($padstring.Length - 1, 1)
if ($last_character -eq "K" -or $last_character -eq "k")
{
  $padlength = [Convert]::ToInt32($padstring.Substring(0, $padstring.Length - 1)) * 1024
}
else
{
  $padlength = [Convert]::ToInt32($padstring)
}

try
{
  $filebytes = [System.IO.File]::ReadAllBytes($filename)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: reading $($filename)."
  ExitWithCode 1
}

$filelength = $filebytes.Length

if ($padlength -lt $filelength)
{
  $modulo = $filelength % $padlength
  if ($modulo -eq 0)
  {
    $padbytes = $null
  }
  else
  {
    $padbytes = ,[byte]0 * ($padlength - $modulo)
  }
}
else
{
  $padbytes = ,[byte]0 * ($padlength - $filelength)
}

$filebytes += $padbytes

if ($verbose -eq "Y")
{
  Write-Host "$($scriptname): padding file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."
}
else
{
  $briefcommand = "[FILEPAD]".PadRight($(GetEnvVar "BRIEFTEXT_WIDTH"), " ")
  Write-Host "$($briefcommand) $(Split-Path -Path $filename -Leaf -Resolve)"
}

try
{
  [System.IO.File]::WriteAllBytes($filename, $filebytes)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($filename)."
  ExitWithCode 1
}

ExitWithCode 0

