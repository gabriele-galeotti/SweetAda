
#
# Update timestamp of a file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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

[int]$argc = 0
[bool]$reffile = $false

#
# Basic input parameters check.
#
if ([string]$args[$argc] -eq "-r")
{
  $reffile = $true
  $argc++
  $reffile_filename = $args[$argc]
  if ([string]::IsNullOrEmpty($reffile_filename))
  {
    Write-Stderr "$($scriptname): *** Error: no reference file specified."
    ExitWithCode 1
  }
  $argc++
}
$input_filename = $args[$argc]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Stderr "$($scriptname): *** Error: no input file specified."
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

