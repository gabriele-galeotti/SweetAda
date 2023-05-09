
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

$filename = $args[0]
$offset = [Convert]::ToInt32($args[1], 16)
$patchstring = $args[2]

$filebytes = [System.IO.File]::ReadAllBytes($filename)

$patchstring.Split(" ") | foreach {
  $filebytes[$offset] = [Convert]::ToInt32($_, 16)
  $offset++
}

Write-Host "${scriptname}: patching file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."

[System.IO.File]::WriteAllBytes($filename, $filebytes)

ExitWithCode 0

