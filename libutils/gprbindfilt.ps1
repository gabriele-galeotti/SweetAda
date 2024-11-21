
#
# SweetAda GPRbuild bind-phase output filter.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = elaboration dump filename
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
$elaboration_filename = $args[0]
if ([string]::IsNullOrEmpty($elaboration_filename))
{
  Write-Host "$($scriptname): *** Notice: no elaboration dump file specified."
  $elaboration_filename = "gnatbind_elab.lst"
}

$exit_status = 0

$state = 0
$elaboration_createfile = $false
foreach ($line in $input)
{
  $elaboration = $false
  $elaboration_order_deps = $false
  $elaboration_order = $false
  $empty_line = $false
  if ($line.StartsWith("__exitstatus__="))
  {
    $linearray = $line.Trim(" ") -Split "="
    $exit_status = [int]$linearray[1]
    break
  }
  if     ($line.StartsWith("ELABORATION ORDER DEPENDENCIES"))
  {
    $elaboration = $true
    $elaboration_order_deps = $true
  }
  elseif ($line.StartsWith("ELABORATION ORDER"))
  {
    $elaboration = $true
    $elaboration_order = $true
  }
  elseif ([string]::IsNullOrEmpty($line))
  {
    $empty_line = $true
  }
  switch ($state)
  {
    0
    {
      $print = "STDOUT"
      if ($empty_line)
      {
        $print =
        $state = 1
      }
    }
    1
    {
      $line = "$($nl)$($line)"
      if ($elaboration)
      {
        if (-not ($elaboration_createfile))
        {
          $elaboration_createfile = $true
          Remove-Item -Path $elaboration_filename -Force -ErrorAction Ignore
          New-Item -Name $elaboration_filename -ItemType File | Out-Null
        }
        $print = "FILE"
        if     ($elaboration_order)
        {
          $state = 2
        }
        elseif ($elaboration_order_deps)
        {
          $state = 3
        }
      }
      else
      {
        $print = "STDOUT"
        $state = 0
      }
    }
    # ELABORATION ORDER
    2
    {
      if ($empty_line)
      {
        $state = 0
      }
    }
    # ELABORATION ORDER DEPENDENCIES
    3
    {
      # empty line after "ELABORATION ORDER DEPENDENCIES"
      if ($empty_line)
      {
        $state = 4
      }
    }
    4
    {
      if ($empty_line)
      {
        $state = 0
      }
    }
    # default
    default
    {
    }
  }
  switch ($print)
  {
    "STDOUT" { Write-Host "$($line)" }
    "FILE"   { Add-Content -Path $elaboration_filename -Value "$($line)" }
    default  { }
  }
}

ExitWithCode $exit_status

