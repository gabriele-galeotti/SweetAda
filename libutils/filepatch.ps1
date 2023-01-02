
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
$offset = [Convert]::ToInt32($args[1], 16)
$patchstring = $args[2]

$filebytes = [System.IO.File]::ReadAllBytes($filename)

$patchstring.Split(" ") | foreach {
  $filebytes[$offset] = [Convert]::ToInt32($_, 16)
  $offset++
}

[System.IO.File]::WriteAllBytes($filename, $filebytes)

ExitWithCode 0

