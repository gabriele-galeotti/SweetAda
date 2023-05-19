
#
# Update timestamp of a file.
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
$input_filename = $args[0]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Host "${scriptname}: *** Error: no input file specified."
  ExitWithCode 1
}

$file = Get-Item -Path $input_filename
$file.LastWriteTime = (Get-Date)

ExitWithCode 0

