
#
# Create "configure.gpr" GNATMAKE project file.
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
# TOOLCHAIN_NAME
# RTS_PATH
# GNATADC_FILENAME
# GCC_WRAPPER
# ADA_MODE
# USE_LIBGCC
# USE_LIBADA
# USE_CLIBRARY
# PLATFORM
# CPU
# ADAC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
# GCC_SWITCHES_STARTUP
# INCLUDE_DIRECTORIES
# IMPLICIT_ALI_UNITS
# ADAC_SWITCHES_WARNING
# ADAC_SWITCHES_STYLE
# OPTIMIZATION_LEVEL
# LIBRARY_DIRECTORY
# OBJECT_DIRECTORY
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
  param([string]$f, [string]$list, [int]$il, [string]$ispaces)
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
      print_I $f "$ispaces$s"
    }
  }
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
print_I $configure_filename "SweetAda_Path         := `"$env:SWEETADA_PATH`";"
print_I $configure_filename "Toolchain_Prefix      := `"$env:TOOLCHAIN_PREFIX`";"
print_I $configure_filename "Toolchain_Name        := `"$env:TOOLCHAIN_NAME`";"
print_I $configure_filename "RTS_Path              := `"$env:RTS_PATH`";"
print_I $configure_filename "GnatAdc_Filename      := `"$env:GNATADC_FILENAME`";"
print_I $configure_filename "GCC_Wrapper           := `"$env:GCC_WRAPPER`";"
print_I $configure_filename "Ada_Mode              := `"$env:ADA_MODE`";"
print_I $configure_filename "Use_LibGCC            := `"$env:USE_LIBGCC`";"
print_I $configure_filename "Use_LibAda            := `"$env:USE_LIBADA`";"
print_I $configure_filename "Use_CLibrary          := `"$env:USE_CLIBRARY`";"
print_I $configure_filename "Platform              := `"$env:PLATFORM`";"
print_I $configure_filename "Cpu                   := `"$env:CPU`";"
$indentl =                  "                          "
print_I $configure_filename "ADAC_Switches_RTS     := ("
print_list $configure_filename $env:ADAC_SWITCHES_RTS.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "GCC_Switches_Platform := ("
print_list $configure_filename $env:GCC_SWITCHES_PLATFORM.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "GCC_Switches_Startup  := ("
print_list $configure_filename $env:GCC_SWITCHES_STARTUP.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "Include_Directories   := ("
print_list $configure_filename $env:INCLUDE_DIRECTORIES.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "Implicit_ALI_Units    := ("
print_list $configure_filename $env:IMPLICIT_ALI_UNITS.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "ADAC_Switches_Warning := ("
print_list $configure_filename $env:ADAC_SWITCHES_WARNING.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "ADAC_Switches_Style   := ("
print_list $configure_filename $env:ADAC_SWITCHES_STYLE.Trim(" ") $indentation_level $indentl
print_I $configure_filename "                         );"
print_I $configure_filename "Optimization_Level    := `"$env:OPTIMIZATION_LEVEL`";"
print_I $configure_filename "Library_Directory     := `"$env:LIBRARY_DIRECTORY`";"
print_I $configure_filename "Object_Directory      := `"$env:OBJECT_DIRECTORY`";"
print_V $configure_filename

#
# Close the project.
#
$indentation_level--
print_I $configure_filename "end $configure_project;"

Write-Host "${scriptname}: ${configure_filename}: done."

ExitWithCode 0

