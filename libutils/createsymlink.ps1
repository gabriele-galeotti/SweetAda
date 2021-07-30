
#
# Create a symbolic link.
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

$verbose = (Get-Item env:VERBOSE).Value

$filename_target = $args[0]
$filename_linkname = $args[1]

$isfolder = (Test-Path -Path $filename_target -PathType Container)
if ($isfolder)
{
  $files = Get-ChildItem $filename_target
  foreach ($f in $files)
  {
    Remove-Item -Path $f -Force -ErrorAction Ignore
    New-Item -ItemType SymbolicLink -Path $f -Target $filename_target\$f | Out-Null
    if ($verbose -eq "Y")
    {
      Write-Host "${f} -> ${filename_target}\${f}"
    }
  }
}
else
{
  Remove-Item -Path $filename_linkname -Force -ErrorAction Ignore
  New-Item -ItemType SymbolicLink -Path $filename_linkname -Target $filename_target | Out-Null
  if ($verbose -eq "Y")
  {
    Write-Host "${filename_linkname} -> ${filename_target}"
  }
}

ExitWithCode 0

