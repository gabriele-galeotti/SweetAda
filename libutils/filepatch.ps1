
#
# Patch a file.
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
$offset = [Convert]::ToInt32($args[1], 16)
if ([string]::IsNullOrEmpty($offset))
{
  Write-Host "${scriptname}: *** Error: no offset specified."
  ExitWithCode 1
}
$patchstring = $args[2]
if ([string]::IsNullOrEmpty($patchstring))
{
  Write-Host "${scriptname}: *** Error: no patchstring specified."
  ExitWithCode 1
}

$filebytes = [System.IO.File]::ReadAllBytes($filename)

$patchstring.Split(" ") | foreach {
  $filebytes[$offset] = [Convert]::ToInt32($_, 16)
  $offset++
}

Write-Host "${scriptname}: patching file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."

[System.IO.File]::WriteAllBytes($filename, $filebytes)

ExitWithCode 0

