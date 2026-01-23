
#
# Update timestamp of a file.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional starting "-c" to not create the file
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

[bool]$createfile = $true
[bool]$reffile = $false

# parse command line arguments
$argsindex = 0
while ($argsindex -lt $args.length)
{
  if ($args[$argsindex][0] -eq "-")
  {
    $optionchar = $args[$argsindex].Substring(1)
    if ($optionchar -eq "c")
    {
      $createfile = $false
    }
    elseif ($optionchar -eq "r")
    {
      $reffile = $true
      $argsindex++
      $reffile_filename = $args[$argsindex]
      if ([string]::IsNullOrEmpty($reffile_filename))
      {
        Write-Stderr "$($scriptname): *** Error: no reference file specified."
        ExitWithCode 1
      }
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($optionchar)`"."
      ExitWithCode 1
    }
  }
  else
  {
    break
  }
  $argsindex++
}
$input_filename = $args[$argsindex]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Stderr "$($scriptname): *** Error: no input file specified."
  ExitWithCode 1
}

if (-not (Test-Path -Path $input_filename) -and $createfile)
{
  New-Item $input_filename
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

