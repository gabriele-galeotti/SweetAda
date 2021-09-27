
#
# dos2unix utility.
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

$input_filename = $args[0]
$output_filename = $args[1]

$textlines = [System.IO.File]::ReadAllText($input_filename) -Replace "`r",""
[System.IO.File]::WriteAllText($output_filename, $textlines)

ExitWithCode 0

