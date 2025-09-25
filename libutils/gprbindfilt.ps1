
#
# SweetAda GPRbuild bind-phase output filter.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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
foreach ($textline in $input)
{
  $elaboration = $false
  $elaboration_order_deps = $false
  $elaboration_order = $false
  $empty_textline = $false
  if ($textline.StartsWith("__exitstatus__="))
  {
    $textlinearray = $textline.Trim(" ") -Split "="
    $exit_status = [int]$textlinearray[1]
    break
  }
  if ($textline.StartsWith("ELABORATION ORDER DEPENDENCIES"))
  {
    $elaboration = $true
    $elaboration_order_deps = $true
  }
  elseif ($textline.StartsWith("ELABORATION ORDER"))
  {
    $elaboration = $true
    $elaboration_order = $true
  }
  elseif ([string]::IsNullOrEmpty($textline))
  {
    $empty_textline = $true
  }
  switch ($state)
  {
    0
    {
      $print = "STDOUT"
      if ($empty_textline)
      {
        $print =
        $state = 1
      }
    }
    1
    {
      $textline = "$($nl)$($textline)"
      if ($elaboration)
      {
        if (-not ($elaboration_createfile))
        {
          $elaboration_createfile = $true
          Remove-Item -Path $elaboration_filename -Force -ErrorAction Ignore
          New-Item -Name $elaboration_filename -ItemType File | Out-Null
        }
        $print = "FILE"
        if ($elaboration_order)
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
      if ($empty_textline)
      {
        $state = 0
      }
    }
    # ELABORATION ORDER DEPENDENCIES
    3
    {
      # empty line after "ELABORATION ORDER DEPENDENCIES"
      if ($empty_textline)
      {
        $state = 4
      }
    }
    4
    {
      if ($empty_textline)
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
    "STDOUT" { Write-Host "$($textline)" }
    "FILE"   { Add-Content -Path $elaboration_filename -Value "$($textline)" }
    default  { }
  }
}

ExitWithCode $exit_status

