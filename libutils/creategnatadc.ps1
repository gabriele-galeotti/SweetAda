
#
# Create "gnat.adc" file.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
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
$profile = $args[0]
if ([string]::IsNullOrEmpty($profile))
{
  Write-Host "${scriptname}: *** Error: no PROFILE specified."
  ExitWithCode 1
}
$gnatadc_filename = $args[1]
if ([string]::IsNullOrEmpty($gnatadc_filename))
{
  Write-Host "${scriptname}: *** Error: no GNATADC_FILENAME specified."
  ExitWithCode 1
}

if (-not (Test-Path -Path "${gnatadc_filename}.in"))
{
  Write-Host "${scriptname}: *** Error: ${gnatadc_filename}.in not found."
  ExitWithCode 1
}

Remove-Item -Path $gnatadc_filename -Force -ErrorAction Ignore
New-Item -Name $gnatadc_filename -ItemType File | Out-Null

foreach ($textline in Get-Content "${gnatadc_filename}.in")
{
  $textlinearray = $textline -Split "--"
  $pragma = $textlinearray[0].Trim(" ")
  $profiles = $textlinearray[1]
  if ($pragma -eq "")
  {
    continue
  }
  if ($profiles -eq "")
  {
    continue
  }
  $profilesarray = $profiles.Split(" ").Trim(" ")
  foreach ($p in $profilesarray)
  {
    if ($p -eq $profile)
    {
      Add-Content -Path $gnatadc_filename -Value "${pragma}"
      break
    }
  }
}

Write-Host "${scriptname}: ${gnatadc_filename}: done."

ExitWithCode 0

