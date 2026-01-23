
#
# "head" mini-replacement for toolchain version information.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
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

#
# NOTE: this utility works only with data piped into stdin.
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

$textlinestoprint = 10

$argsindex = 0
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex] -eq "-n")
  {
    # ignore
  }
  else
  {
    if ([int]$args[$argsindex] -ge 1 -and [int]$args[$argsindex] -le 9)
    {
      $textlinestoprint = [int]$args[$argsindex]
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

