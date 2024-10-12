
#
# Pad a file.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
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
# none
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name

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
    [void]$outf.Invoke($lines -join "`r`n")
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

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
  Write-Stderr "$($scriptname): *** Error: no padding specified."
  ExitWithCode 1
}

$last_character = $padstring.Substring($padstring.length - 1, 1)
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

Write-Host "$($scriptname): padding file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."

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

