
#
# dos2unix utility.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = output filename
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
  Write-Host "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}
$output_filename = $args[1]
if ([string]::IsNullOrEmpty($output_filename))
{
  Write-Host "$($scriptname): *** Error: no output file specified."
  ExitWithCode 1
}

try
{
  $textlines = [System.IO.File]::ReadAllText($input_filename) -Replace "`r",""
}
catch
{
  Write-Host "$($scriptname): *** Error: processing $($input_filename)."
  ExitWithCode 1
}
try
{
  [System.IO.File]::WriteAllText($output_filename, $textlines)
}
catch
{
  Write-Host "$($scriptname): *** Error: processing $($output_filename)."
  ExitWithCode 1
}

ExitWithCode 0

