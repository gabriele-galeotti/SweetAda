
#
# dos2unix utility.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = optional output filename
#
# Environment variables:
# none
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name
$nl = [Environment]::NewLine

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
    [void]$outf.Invoke($lines -Join $nl)
  }
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
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}
$output_filename = $args[1]
if ([string]::IsNullOrEmpty($output_filename))
{
  $output_filename = $input_filename
}

try
{
  $textlines = [System.IO.File]::ReadAllText($input_filename) -Replace "`r",""
}
catch
{
  Write-Stderr "$($scriptname): *** Error: processing $($input_filename)."
  ExitWithCode 1
}
try
{
  [System.IO.File]::WriteAllText($output_filename, $textlines)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: processing $($output_filename)."
  ExitWithCode 1
}

ExitWithCode 0

