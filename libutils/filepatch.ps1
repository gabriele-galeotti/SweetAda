
#
# Patch a file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = filename
# $2 = offset in hexadecimal format
# $3 = string containing the hexadecimal representation of a byte to patch in
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
$filename = $args[0]
if ([string]::IsNullOrEmpty($filename))
{
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}
$offset = [Convert]::ToInt32($args[1], 16)
if ([string]::IsNullOrEmpty($offset))
{
  Write-Stderr "$($scriptname): *** Error: no offset specified."
  ExitWithCode 1
}
$patchstring = $args[2]
if ([string]::IsNullOrEmpty($patchstring))
{
  Write-Stderr "$($scriptname): *** Error: no patchstring specified."
  ExitWithCode 1
}

try
{
  $filebytes = [System.IO.File]::ReadAllBytes($filename)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: reading $($filename)."
  ExitWithCode 1
}

$patchstring.Split(" ") | foreach {
  $filebytes[$offset] = [Convert]::ToInt32($_, 16)
  $offset++
}

Write-Host "$($scriptname): patching file `"$(Split-Path -Path $filename -Leaf -Resolve)`"."

try
{
  [System.IO.File]::WriteAllBytes($filename, $filebytes)
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($filename)."
  ExitWithCode 1
}

ExitWithCode 0

