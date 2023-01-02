#!/bin/sh

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
# $1 = configure project
# $2 = configure filename
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
# ADAC_SWITCHES_WARNING
# ADAC_SWITCHES_STYLE
# OBJECT_DIRECTORY
# OPTIMIZATION_LEVEL
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set -o posix
SCRIPT_FILENAME=$(basename "$0")
LOG_FILENAME=""
if [ "x${LOG_FILENAME}" != "x" ] ; then
  rm -f "${LOG_FILENAME}"
  touch "${LOG_FILENAME}"
fi

################################################################################
# log_print()                                                                  #
#                                                                              #
################################################################################
log_print()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}"
else
  printf "%s\n" "$1"
fi
return 0
}

################################################################################
# log_print_error()                                                            #
#                                                                              #
################################################################################
log_print_error()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}" 1>&2
else
  printf "%s\n" "$1" 1>&2
fi
return 0
}

################################################################################
# print_I()                                                                    #
#                                                                              #
# Print a string with amount of indentation proportional to INDENTATION_LEVEL. #
################################################################################
print_I()
{
local _is
local _il
_is=""
for ((_il=1 ; _il<=${INDENTATION_LEVEL} ; _il++)) ; do
  # Ada 3-space indentation style
  _is+="   "
done
printf "%s\n" "${_is}$1" >> "${CONFIGURE_FILENAME}"
return 0
}

################################################################################
# print_V()                                                                    #
#                                                                              #
# Print an empty line.                                                         #
################################################################################
print_V()
{
printf "%s\n" "" >> "${CONFIGURE_FILENAME}"
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
CONFIGURE_PROJECT="$1"
if [ "x${CONFIGURE_PROJECT}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no project name specified."
  exit 1
fi
CONFIGURE_FILENAME="$2"
if [ "x${CONFIGURE_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no project file specified."
  exit 1
fi

rm -f "${CONFIGURE_FILENAME}"
touch "${CONFIGURE_FILENAME}"

if [ "x${OSTYPE}" = "xmsys" ] ; then
  TOOLCHAIN_PREFIX=$(cygpath -m "${TOOLCHAIN_PREFIX}")
  RTS_PATH=$(cygpath -m "${RTS_PATH}")
fi

INDENTATION_LEVEL=0

#
# Initial empty line.
#
print_V

#
# Declare project.
#
print_I "project ${CONFIGURE_PROJECT} is"
let INDENTATION_LEVEL++
print_V

#
# Configuration declarations.
#
print_I "for Source_Files use ();"
print_V
print_I "SweetAda_Path         := \"${SWEETADA_PATH}\";"
print_I "Toolchain_Prefix      := \"${TOOLCHAIN_PREFIX}\";"
print_I "Toolchain_Name        := \"${TOOLCHAIN_NAME}\";"
print_I "RTS_Path              := \"${RTS_PATH}\";"
print_I "Ada_Mode              := \"${ADA_MODE}\";"
print_I "Platform              := \"${PLATFORM}\";"
print_I "Cpu                   := \"${CPU}\";"
print_I "ADAC_Switches_RTS     := ("
ADAC_SWITCHES_RTS_ARRAY=(${ADAC_SWITCHES_RTS})
imax=$((${#ADAC_SWITCHES_RTS_ARRAY[@]}-1))
if [ "${imax}" -ge "0" ] ; then
  for i in $(seq 0 $((${imax}))) ; do
    s="\"${ADAC_SWITCHES_RTS_ARRAY[$i]}\""
    if [ "${i}" -ne "${imax}" ] ; then
      s+=","
    fi
    print_I "                          ${s}"
  done
fi
print_I "                         );"
print_I "GCC_Platform_Switches := ("
GCC_SWITCHES_PLATFORM_ARRAY=(${GCC_SWITCHES_PLATFORM})
imax=$((${#GCC_SWITCHES_PLATFORM_ARRAY[@]}-1))
if [ "${imax}" -ge "0" ] ; then
  for i in $(seq 0 $((${imax}))) ; do
    s="\"${GCC_SWITCHES_PLATFORM_ARRAY[$i]}\""
    if [ "${i}" -ne "${imax}" ] ; then
      s+=","
    fi
    print_I "                          ${s}"
  done
fi
print_I "                         );"
print_I "Include_Directories   := ("
INCLUDE_DIRECTORIES_ARRAY=(${INCLUDE_DIRECTORIES})
imax=$((${#INCLUDE_DIRECTORIES_ARRAY[@]}-1))
if [ "${imax}" -ge "0" ] ; then
  for i in $(seq 0 $((${imax}))) ; do
    s="\"${INCLUDE_DIRECTORIES_ARRAY[$i]}\""
    if [ "${i}" -ne "${imax}" ] ; then
      s+=","
    fi
    print_I "                          ${s}"
  done
fi
print_I "                         );"
print_I "Implicit_ALI_Units    := ("
IMPLICIT_ALI_UNITS_ARRAY=(${IMPLICIT_ALI_UNITS})
imax=$((${#IMPLICIT_ALI_UNITS_ARRAY[@]}-1))
if [ "${imax}" -ge "0" ] ; then
  for i in $(seq 0 $((${imax}))) ; do
    s="\"${IMPLICIT_ALI_UNITS_ARRAY[$i]}\""
    if [ "${i}" -ne "${imax}" ] ; then
      s+=","
    fi
    print_I "                          ${s}"
  done
fi
print_I "                         );"
print_I "ADAC_Switches_Warning := ("
ADAC_SWITCHES_WARNING_ARRAY=(${ADAC_SWITCHES_WARNING})
imax=$((${#ADAC_SWITCHES_WARNING_ARRAY[@]}-1))
if [ "${imax}" -ge "0" ] ; then
  for i in $(seq 0 $((${imax}))) ; do
    s="\"${ADAC_SWITCHES_WARNING_ARRAY[$i]}\""
    if [ "${i}" -ne "${imax}" ] ; then
      s+=","
    fi
    print_I "                          ${s}"
  done
fi
print_I "                         );"
print_I "ADAC_Switches_Style   := ("
ADAC_SWITCHES_STYLE_ARRAY=(${ADAC_SWITCHES_STYLE})
imax=$((${#ADAC_SWITCHES_STYLE_ARRAY[@]}-1))
if [ "${imax}" -ge "0" ] ; then
  for i in $(seq 0 $((${imax}))) ; do
    s="\"${ADAC_SWITCHES_STYLE_ARRAY[$i]}\""
    if [ "${i}" -ne "${imax}" ] ; then
      s+=","
    fi
    print_I "                          ${s}"
  done
fi
print_I "                         );"
print_I "Object_Directory      := \"${OBJECT_DIRECTORY}\";"
print_I "Optimization_Level    := \"${OPTIMIZATION_LEVEL}\";"
print_V

#
# Close project.
#
let INDENTATION_LEVEL--
print_I "end ${CONFIGURE_PROJECT};"

log_print "${SCRIPT_FILENAME}: ${CONFIGURE_FILENAME}: done."

exit 0

