
#
# Create "gnat.adc" file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = PROFILE
# $2 = GNATADC_FILENAME
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
if ($args[0] -eq $null)
{
  Write-Stderr "$($scriptname): *** Error: no PROFILE specified."
  ExitWithCode 1
}
$profile = $args[0]
$gnatadc_filename = $args[1]
if ([string]::IsNullOrEmpty($gnatadc_filename))
{
  Write-Stderr "$($scriptname): *** Error: no GNATADC_FILENAME specified."
  ExitWithCode 1
}

if (-not (Test-Path -Path "$($gnatadc_filename).in"))
{
  Write-Stderr "$($scriptname): *** Error: $($gnatadc_filename).in not found."
  ExitWithCode 1
}

$gnatadc = ""

foreach ($textline in Get-Content "$($gnatadc_filename).in")
{
  $textlinearray = $textline -Split "--"
  $pragma = $textlinearray[0].Trim(" ")
  $profiles = $textlinearray[1]
  if (($pragma -eq "") -or ($profiles -eq ""))
  {
    continue
  }
  $profilesarray = ($profiles.Trim(" ") -Replace "\s+"," ").Split(" ")
  foreach ($p in $profilesarray)
  {
    if ($p -eq $profile)
    {
      $gnatadc += "$($pragma)" + $nl
      break
    }
  }
}

try
{
  Remove-Item -Path $gnatadc_filename -Force -ErrorAction Ignore
  New-Item -Name $gnatadc_filename -ItemType File | Out-Null
  Add-Content -Path $gnatadc_filename -Value $gnatadc -NoNewLine
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($gnatadc_filename)."
  ExitWithCode 1
}

Write-Host "$($scriptname): $($gnatadc_filename): done."

ExitWithCode 0

