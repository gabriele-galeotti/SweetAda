
#
# Create a GNATPREP definitions file.
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

$definitions_filename = $args[0]

Remove-Item -Path $definitions_filename -Force -ErrorAction Ignore
New-Item -Name $definitions_filename -ItemType File | Out-Null

Add-Content -Path $definitions_filename -Value "-- ${scriptname}"

Add-Content -Path $definitions_filename -Value "PLATFORM := `"$env:PLATFORM`""
if ("$env:SUBPLATFORM" -ne "")
{
  Add-Content -Path $definitions_filename -Value "SUBPLATFORM := `"$env:SUBPLATFORM`""
}
Add-Content -Path $definitions_filename -Value "CPU := `"$env:CPU`""
Add-Content -Path $definitions_filename -Value "CPU_MODEL := `"$env:CPU_MODEL`""

Write-Host "${definitions_filename}: done."

ExitWithCode 0

