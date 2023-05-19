
#
# Pad a file.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# arguments specified in .bat script
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
$filename = $args[0]
if ([string]::IsNullOrEmpty($filename))
{
  Write-Host "${scriptname}: *** Error: no input file specified."
  ExitWithCode 1
}
$padstring = [string]$args[1]
if ([string]::IsNullOrEmpty($padstring))
{
  Write-Host "${scriptname}: *** Error: no padding specified."
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

$filebytes = [System.IO.File]::ReadAllBytes($filename)
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

Write-Host "${scriptname}: padding file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."

[System.IO.File]::WriteAllBytes($filename, $filebytes)

ExitWithCode 0

