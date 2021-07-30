
#
# Pad a file.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
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

$scriptname = $MyInvocation.MyCommand.Name

$filename = $args[0]
$padstring = [string]$args[1]

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
  $padbytes = ,[byte]0 * ($padlength - $filelength % $padlength)
}
else
{
  $padbytes = ,[byte]0 * ($padlength - $filelength)
}

$filebytes += $padbytes

[System.IO.File]::WriteAllBytes($filename, $filebytes)

ExitWithCode 0

