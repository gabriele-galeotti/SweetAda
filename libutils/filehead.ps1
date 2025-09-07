
#
# "head" mini-replacement for toolchain version information.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional "-n" (ignored)
# $1 = number of lines to print (1 .. 9, default = 10)
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
    [String[]]$lines = @()
    $input | % { $lines += $_.ToString() }
    [void]$outf.Invoke($lines -Join $nl)
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

$textlinestoprint = 10

$argsindex = 0
while ($argsindex -lt $args.length)
{
  if ($args[$argsindex] -eq "-n")
  {
    # ignore
  }
  else
  {
    if ([Int]$args[$argsindex] -ge 1 -and [Int]$args[$argsindex] -le 9)
    {
      $textlinestoprint = [Int]$args[$argsindex]
      break
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($args[$argsindex])`"."
      ExitWithCode 1
    }
  }
  $argsindex++
}

$Input | Select-Object -First $textlinestoprint

ExitWithCode 0

