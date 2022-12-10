
#
# Create "configure.gpr" GNATMAKE project file.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# arguments specified in .bat script
#
# Environment variables:
# SWEETADA_PATH
# TOOLCHAIN_PREFIX
# TOOLCHAIN_NAME
# OBJECT_DIRECTORY
# TOOLCHAIN_NAME
# RTS_PATH
# PLATFORM
# CPU
# ADAC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
# INCLUDE_DIRECTORIES
# IMPLICIT_ALI_UNITS
# OBJECT_DIRECTORY
# OPTIMIZATION_LEVEL
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
# print_V()                                                                    #
#                                                                              #
################################################################################
function print_V
{
  param([string]$f)
  Add-Content -Path $f -Value ""
}

################################################################################
# print_I()                                                                    #
#                                                                              #
################################################################################
function print_I
{
  param([string]$f, [string]$t)
  $is = ""
  for ($i=0 ; $i -lt $indentation_level ; $i++)
  {
    $is += "   "
  }
  Add-Content -Path $f -Value "$is$t"
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name

$configure_project = $args[0]
$configure_filename = $args[1]

Remove-Item -Path $configure_filename -Force -ErrorAction Ignore
New-Item -Name $configure_filename -ItemType File | Out-Null

$indentation_level = 0

#
# Initial empty line.
#
print_V $configure_filename

#
# Declare project.
#
print_I $configure_filename "project $configure_project is"
$indentation_level++
print_V $configure_filename

#
# Configuration declarations.
#
print_I $configure_filename "for Source_Files use ();"
print_V $configure_filename
print_I $configure_filename "SweetAda_Path         := `"$env:SWEETADA_PATH`";"
print_I $configure_filename "Toolchain_Prefix      := `"$env:TOOLCHAIN_PREFIX`";"
print_I $configure_filename "Toolchain_Name        := `"$env:TOOLCHAIN_NAME`";"
print_I $configure_filename "RTS_Path              := `"$env:RTS_PATH`";"
print_I $configure_filename "Ada_Mode              := `"$env:ADA_MODE`";"
print_I $configure_filename "Platform              := `"$env:PLATFORM`";"
print_I $configure_filename "Cpu                   := `"$env:CPU`";"
print_I $configure_filename "ADAC_Switches_RTS     := ("
$adac_switches_rts = $env:ADAC_SWITCHES_RTS
if ($adac_switches_rts.Length -gt 0)
{
  $adac_switches_rts_array = $adac_switches_rts.Trim(" ") -split "\s+"
  $count = 0
  foreach ($s in $adac_switches_rts_array)
  {
    $count = $count + 1
    $s = "`"$s`""
    if ($count -ne $adac_switches_rts_array.Length)
    {
      $s += ","
    }
    print_I $configure_filename "                          $s"
  }
}
print_I $configure_filename "                         );"
print_I $configure_filename "GCC_Platform_Switches := ("
$gcc_platform_switches = $env:GCC_SWITCHES_PLATFORM.Trim(" ")
if ($gcc_platform_switches.Length -gt 0)
{
  $gcc_platform_switches_array = $gcc_platform_switches -split "\s+"
  $count = 0
  foreach ($s in $gcc_platform_switches_array)
  {
    $count = $count + 1
    $s = "`"$s`""
    if ($count -ne $gcc_platform_switches_array.Length)
    {
      $s += ","
    }
    print_I $configure_filename "                          $s"
  }
}
print_I $configure_filename "                         );"
print_I $configure_filename "Include_Directories   := ("
$include_directories = $env:INCLUDE_DIRECTORIES.Trim(" ")
if ($include_directories.Length -gt 0)
{
  $include_directories_array = $include_directories -split "\s+"
  $count = 0
  foreach ($s in $include_directories_array)
  {
    $count = $count + 1
    $s = "`"$s`""
    if ($count -ne $include_directories_array.Length)
    {
      $s += ","
    }
    print_I $configure_filename "                          $s"
  }
}
print_I $configure_filename "                         );"
print_I $configure_filename "Implicit_ALI_Units    := ("
$implicit_ali_units = $env:IMPLICIT_ALI_UNITS.Trim(" ")
if ($implicit_ali_units.Length -gt 0)
{
  $implicit_ali_units_array = $implicit_ali_units -split "\s+"
  $count = 0
  foreach ($s in $implicit_ali_units_array)
  {
    $count = $count + 1
    $s = "`"$s`""
    if ($count -ne $implicit_ali_units_array.Length)
    {
      $s += ","
    }
    print_I $configure_filename "                          $s"
  }
}
print_I $configure_filename "                         );"
print_I $configure_filename "Object_Directory      := `"$env:OBJECT_DIRECTORY`";"
print_I $configure_filename "Optimization_Level    := `"$env:OPTIMIZATION_LEVEL`";"
print_V $configure_filename

#
# Close the project.
#
$indentation_level--
print_I $configure_filename "end $configure_project;"

Write-Host "${scriptname}: ${configure_filename}: done."

ExitWithCode 0

