
#
# Create a filesystem symbolic/soft link.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# arguments specified in .bat script
#
# Environment variables:
# VERBOSE
#

#
# If $1 is a directory, all files contained in the directory are made targets
# of the correspondent symlinks (with the same filename), regardless of $2.
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

$verbose = $env:VERBOSE
$args_idx = 0

if ($args[$args_idx] -eq "-v")
{
  $verbose = "Y"
  $args_idx++
}

$target = $args[$args_idx]
$args_idx++
$isfolder = (Test-Path -Path $target -PathType Container)
if ($isfolder)
{
  $filelist_filename = $args[$args_idx]
}
else
{
  $link_name = $args[$args_idx]
}

if ($isfolder)
{
  if (![string]::IsNullOrEmpty($filelist_filename))
  {
    "INSTALLED_FILENAMES :=" | Set-Content $filelist_filename
  }
  $files = Get-ChildItem $target
  foreach ($f in $files)
  {
    Remove-Item -Path $f -Force -ErrorAction Ignore
    New-Item -ItemType SymbolicLink -Path $f -Target $target\$f | Out-Null
    if ($verbose -eq "Y")
    {
      Write-Host "${f} -> ${target}\${f}"
    }
    if (![string]::IsNullOrEmpty($filelist_filename))
    {
      "INSTALLED_FILENAMES += ${f}" | Add-Content $filelist_filename
    }
  }
}
else
{
  Remove-Item -Path $link_name -Force -ErrorAction Ignore
  New-Item -ItemType SymbolicLink -Path $link_name -Target $target | Out-Null
  if ($verbose -eq "Y")
  {
    Write-Host "${link_name} -> ${target}"
  }
}

ExitWithCode 0

