
#
# Makefile dependency file adjustment script for reverse variable reference.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -kpp <path> = reverse-substitute a relative path for KERNEL_PARENT_PATH
# -obj <path> = reverse-substitute a target path for OBJ_DIRECTORY
#               ("+" force head-insertion)
# <filename>  = dependency file to adjust
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

# parse command line arguments
$kernel_parent_path = ""
$target_obj_path = ""
$depfile_filename = ""
$argsindex = 0
while ($argsindex -lt $args.Length)
{
  if ($args[$argsindex][0] -eq "-")
  {
    $option = $args[$argsindex].Substring(1)
    if ($option -eq "kpp")
    {
      $argsindex++
      $kernel_parent_path = $args[$argsindex]
    }
    elseif ($option -eq "obj")
    {
      $argsindex++
      $target_obj_path = $args[$argsindex]
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: unknown option `"$($option)`"."
      ExitWithCode 1
    }
  }
  else
  {
    if ($depfile_filename -eq "")
    {
      $depfile_filename = $args[$argsindex]
    }
    else
    {
      Write-Stderr "$($scriptname): *** Error: too many input files."
      ExitWithCode 1
    }
  }
  $argsindex++
}

if ($depfile_filename -eq "")
{
  Write-Stderr "$($scriptname): *** Error: no input filename specified."
  ExitWithCode 1
}

[string[]]$textlines = Get-Content -Path $depfile_filename

for ($idx = 0 ; $idx -lt $textlines.Length ; $idx++)
{
  if ($target_obj_path -ne "")
  {
    if ($textlines[$idx].Contains(":"))
    {
      # Makefile rule
      $t_splitted = $textlines[$idx].Split(":")
      if ($target_obj_path.StartsWith("+"))
      {
        $textlines[$idx] = "`$(OBJ_DIRECTORY)/$($t_splitted[0]):$($t_splitted[1])"
      }
      elseif ($t_splitted[0].Contains($target_obj_path))
      {
        $t_splitted[0] = $t_splitted[0].Replace($target_obj_path,"`$(OBJ_DIRECTORY)")
        $textlines[$idx] = "$($t_splitted[0]):$($t_splitted[1])"
      }
    }
  }
  if ($kernel_parent_path -ne "")
  {
    $textlines[$idx] = $textlines[$idx].Replace($kernel_parent_path,"`$(KERNEL_PARENT_PATH)")
  }
}

try
{
  $textlines | Out-File -Encoding utf8 -FilePath $depfile_filename
}
catch
{
  Write-Stderr "$($scriptname): *** Error: writing $($depfile_filename)."
  ExitWithCode 1
}

ExitWithCode 0

