
#
# Update timestamp of a file.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional starting "-r <reference_filename>"
# $1 = input filename
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

[int]$argc = 0
[bool]$reffile = $false

#
# Basic input parameters check.
#
if ([string]$args[$argc] -eq "-r")
{
  $reffile = $true
  $argc = $argc + 1
  $reffile_filename = $args[$argc]
  if ([string]::IsNullOrEmpty($reffile_filename))
  {
    Write-Host "${scriptname}: *** Error: no reference file specified."
    ExitWithCode 1
  }
  $argc = $argc + 1
}
$input_filename = $args[$argc]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Host "${scriptname}: *** Error: no input file specified."
  ExitWithCode 1
}

$file = Get-ChildItem -Force -Path $input_filename
if ($reffile)
{
  $file.LastWriteTime = `
    (Get-ChildItem -Force -Path $reffile_filename | Select LastWriteTime | Get-Date)
}
else
{
  $file.LastWriteTime = (Get-Date)
}

ExitWithCode 0

