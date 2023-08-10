
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
# optional initial -m <filelist> to record symlinks
# optional initial -v for verbosity
# $1 = target filename or directory
# $2 = link name filename or directory
# every following pair is another symlink
#
# Environment variables:
# VERBOSE
#
# If the target is a directory, then link name should be a directory, and
# every file contained in the directory is made target of the correspondent
# symlink (with the same filename).
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

# check environment variable for verbosity
$verbose = $env:VERBOSE

# parse command line arguments
$fileindex = 0
while ($fileindex -lt $args.length)
{
  if ($args[$fileindex][0] -eq "-")
  {
    if ($args[$fileindex].Substring(1) -eq "v")
    {
      $verbose = "Y"
    }
    elseif ($args[$fileindex].Substring(1) -eq "m")
    {
      $fileindex++
      $filelist_filename = $args[$fileindex]
    }
    else
    {
      Write-Host "${scriptname}: *** Error: unknown option $($args[$fileindex])."
      ExitWithCode 1
    }
  }
  else
  {
    break
  }
  $fileindex++
}

# create filelist if specified
if (![string]::IsNullOrEmpty($filelist_filename))
{
  "INSTALLED_FILENAMES :=" | Set-Content $filelist_filename
}

# check for at least one symlink target
if ($fileindex -ge $args.length)
{
  Write-Host "${scriptname}: *** Error: no symlink target specified."
  ExitWithCode 1
}

# loop as long as an argument exists
# when arguments are exhausted, exit
while ($fileindex -lt $args.length)
{
  $target = $args[$fileindex]
  # then, the 2nd argument of the pair should exist
  if (($fileindex + 1) -ge $args.length)
  {
    Write-Host "${scriptname}: *** Error: no symlink link name specified."
    ExitWithCode 1
  }
  $isfolder = (Test-Path -Path $target -PathType Container)
  if (-not($isfolder))
  {
    $link_name = $args[$fileindex + 1]
    Remove-Item -Path $link_name -Force -ErrorAction Ignore
    New-Item -ItemType SymbolicLink -Path $link_name -Target $target | Out-Null
    if ($verbose -eq "Y")
    {
      Write-Host "${link_name} -> ${target}"
    }
    if (![string]::IsNullOrEmpty($filelist_filename))
    {
      "INSTALLED_FILENAMES += ${link_name}" | Add-Content $filelist_filename
    }
  }
  else
  {
    $link_directory = $args[$fileindex + 1]
    $files = Get-ChildItem $target
    foreach ($f in $files)
    {
      Remove-Item -Path $link_directory\$f -Force -ErrorAction Ignore
      New-Item -ItemType SymbolicLink -Path $link_directory\$f -Target $target\$f | Out-Null
      if ($verbose -eq "Y")
      {
        Write-Host "${link_directory}\${f} -> ${target}\${f}"
      }
      if (![string]::IsNullOrEmpty($filelist_filename))
      {
        "INSTALLED_FILENAMES += ${link_directory}\${f}" | Add-Content $filelist_filename
      }
    }
  }
  # shift to the next argument pair
  $fileindex += 2
}

ExitWithCode 0

