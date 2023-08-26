
#
# Create "configure.gpr" GPRbuild project file.
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
# SWEETADA_PATH
# TOOLCHAIN_PREFIX
# GPRBUILD_PREFIX
# TOOLCHAIN_NAME
# GCC_WRAPPER
# GNATADC_FILENAME
# LIBRARY_DIRECTORY
# OBJECT_DIRECTORY
# PLATFORM
# CPU
# RTS_PATH
# RTS
# PROFILE
# ADA_MODE
# OPTIMIZATION_LEVEL
# STACK_LIMIT
# GNATBIND_SECSTACK
# USE_LIBGCC
# USE_LIBADA
# USE_CLIBRARY
# ADAC_SWITCHES_RTS
# CC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
# GCC_SWITCHES_STARTUP
# INCLUDE_DIRECTORIES
# IMPLICIT_ALI_UNITS
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
# GetEnvVar()                                                                  #
#                                                                              #
################################################################################
function GetEnvVar
{
  param([string]$varname)
  if (-not (Test-Path env:$varname))
  {
    return [string]::Empty
  }
  else
  {
    return (Get-Item env:$varname).Value
  }
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
  for ($i = 0 ; $i -lt $indentation_level ; $i++)
  {
    $is += $indentation_Ada
  }
  Add-Content -Path $f -Value "$is$t"
}

################################################################################
# print_list()                                                                 #
#                                                                              #
################################################################################
function print_list
{
  param([string]$f, [string]$list, [int]$il, [string]$is)
  if ($list.Length -gt 0)
  {
    $list_array = $list -split "\s+"
    $count = 0
    foreach ($s in $list_array)
    {
      $count = $count + 1
      $s = "`"$s`""
      if ($count -ne $list_array.Length)
      {
        $s += ","
      }
      print_I $f "$is$s"
    }
  }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
$configure_project = $args[0]
if ([string]::IsNullOrEmpty($configure_project))
{
  Write-Host "${scriptname}: *** Error: no project name specified."
  ExitWithCode 1
}
$configure_filename = $args[1]
if ([string]::IsNullOrEmpty($configure_filename))
{
  Write-Host "${scriptname}: *** Error: no project file specified."
  ExitWithCode 1
}

Remove-Item -Path $configure_filename -Force -ErrorAction Ignore
New-Item -Name $configure_filename -ItemType File | Out-Null

$indentation_Ada = "   " # Ada 3-space indentation style

$indentation_level = 0

#
# Initial empty line.
#
print_V $configure_filename

#
# Declare project.
#
print_I $configure_filename "abstract project $configure_project is"
$indentation_level++
print_V $configure_filename

#
# Configuration declarations.
#
print_I $configure_filename "SweetAda_Path         := `"$(GetEnvVar SWEETADA_PATH)`";"
print_I $configure_filename "Toolchain_Prefix      := `"$(GetEnvVar TOOLCHAIN_PREFIX)`";"
print_I $configure_filename "Gprbuild_Prefix       := `"$(GetEnvVar GPRBUILD_PREFIX)`";"
print_I $configure_filename "Toolchain_Name        := `"$(GetEnvVar TOOLCHAIN_NAME)`";"
print_I $configure_filename "GCC_Wrapper           := `"$(GetEnvVar GCC_WRAPPER)`";"
print_I $configure_filename "GnatAdc_Filename      := `"$(GetEnvVar GNATADC_FILENAME)`";"
print_I $configure_filename "Library_Directory     := `"$(GetEnvVar LIBRARY_DIRECTORY)`";"
print_I $configure_filename "Object_Directory      := `"$(GetEnvVar OBJECT_DIRECTORY)`";"
print_I $configure_filename "Platform              := `"$(GetEnvVar PLATFORM)`";"
print_I $configure_filename "Cpu                   := `"$(GetEnvVar CPU)`";"
print_I $configure_filename "RTS_Path              := `"$(GetEnvVar RTS_PATH)`";"
print_I $configure_filename "RTS                   := `"$(GetEnvVar RTS)`";"
print_I $configure_filename "Profile               := `"$(GetEnvVar PROFILE)`";"
print_I $configure_filename "Ada_Mode              := `"$(GetEnvVar ADA_MODE)`";"
print_I $configure_filename "Optimization_Level    := `"$(GetEnvVar OPTIMIZATION_LEVEL)`";"
print_I $configure_filename "Stack_Limit           := `"$(GetEnvVar STACK_LIMIT)`";"
print_I $configure_filename "Gnatbind_SecStack     := `"$(GetEnvVar GNATBIND_SECSTACK)`";"
print_I $configure_filename "Use_LibGCC            := `"$(GetEnvVar USE_LIBGCC)`";"
print_I $configure_filename "Use_LibAda            := `"$(GetEnvVar USE_LIBADA)`";"
print_I $configure_filename "Use_CLibrary          := `"$(GetEnvVar USE_CLIBRARY)`";"
$indentl =                  "                          "
print_I $configure_filename "ADAC_Switches_RTS     := ("
print_list $configure_filename $(GetEnvVar ADAC_SWITCHES_RTS).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "CC_Switches_RTS       := ("
print_list $configure_filename $(GetEnvVar CC_SWITCHES_RTS).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "GCC_Switches_Platform := ("
print_list $configure_filename $(GetEnvVar GCC_SWITCHES_PLATFORM).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "Startup_Objects       := ("
print_list $configure_filename $(GetEnvVar STARTUP_OBJECTS).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "GCC_Switches_Startup  := ("
print_list $configure_filename $(GetEnvVar GCC_SWITCHES_STARTUP).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "Include_Directories   := ("
print_list $configure_filename $(GetEnvVar INCLUDE_DIRECTORIES).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "Implicit_ALI_Units    := ("
print_list $configure_filename $(GetEnvVar IMPLICIT_ALI_UNITS).Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_V $configure_filename

#
# Close the project.
#
$indentation_level--
print_I $configure_filename "end $configure_project;"

Write-Host "${scriptname}: ${configure_filename}: done."

ExitWithCode 0

