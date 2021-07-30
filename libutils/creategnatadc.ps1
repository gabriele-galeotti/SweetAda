
#
# Create "gnat.adc" file.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# arguments specified in .bat script
#
# Environment variables:
# none
#

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

$scriptname = $MyInvocation.MyCommand.Name

$profile = $args[0]
$gnatadc_filename = $args[1]

Remove-Item -Path $gnatadc_filename -Force -ErrorAction Ignore
New-Item -Name $gnatadc_filename -ItemType File | Out-Null

foreach ($textline in Get-Content "${gnatadc_filename}.in")
{
  $textlinearray = $textline -Split "--"
  $pragma = $textlinearray[0].Trim(" ")
  $profiles = $textlinearray[1]
  if ("$pragma" -eq "")
  {
    continue
  }
  if ("$profiles" -eq "")
  {
    continue
  }
  $profilesarray = $profiles.Split(" ").Trim(" ")
  foreach ($p in $profilesarray)
  {
    if ("$p" -eq "$profile")
    {
      Add-Content -Path $gnatadc_filename -Value "$pragma"
      break
    }
  }
}

Write-Host "${gnatadc_filename}: done."

ExitWithCode 0

