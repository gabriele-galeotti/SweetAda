
#
# SweetAda *.gpr dependencies parser.
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
# ParseGpr()                                                                   #
#                                                                              #
################################################################################
function ParseGpr
{
  param([string]$filename)
  $units = ""
  if (-not(Test-Path -Path "$filename" -PathType Leaf))
  {
    return $units
  }
  foreach ($textline in Get-Content "$filename")
  {
    $textline = $textline.Trim()
    if (($textline.Length -eq 0) -or $textline.StartsWith("--"))
    {
      continue
    }
    elseif ($textline.ToLower().StartsWith("with"))
    {
      $unit = $textline -Replace "`t"," " -Replace "with *`"","" -Replace "`" *;.*",""
      if ($unit.Length -gt 0)
      {
        $units = "$units ${unit}.gpr"
      }
    }
    else
    {
      break
    }
  }
  return $units
}

################################################################################
# ParseRecursive()                                                             #
#                                                                              #
################################################################################
function ParseRecursive
{
  param([string]$gprlist)
  $local:units = ""
  foreach ($local:g in $gprlist.Trim().Split(" "))
  {
    $local:gprs = $(ParseGpr $local:g)
    if ($local:gprs.Length -gt 0)
    {
      $local:units = "$local:units $local:gprs"
      $local:pr = $(ParseRecursive $local:gprs)
      $local:units = "$local:units $local:pr"
    }
  }
  return $local:units
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

[int]$argc = 0
[bool]$uniq = $false

#
# Basic input parameters check.
#
if ([string]$args[$argc] -eq "-u")
{
  $uniq = $true
  $argc = $argc + 1
}
$input_filename = $args[$argc]
if ([string]::IsNullOrEmpty($input_filename))
{
  Write-Host "${scriptname}: *** Error: no input file specified."
  ExitWithCode 1
}

$gprdeps = $(ParseRecursive $input_filename).Split(" ")

if ($uniq)
{
  $gprdeps = $gprdeps | Sort-Object -Unique
}

Write-Host "$gprdeps"

ExitWithCode 0

