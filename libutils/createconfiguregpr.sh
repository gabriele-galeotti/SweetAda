#!/usr/bin/env sh

#
# Create "configure.gpr" GPRbuild project file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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
# GPRBUILD_PREFIX
# TOOLCHAIN_NAME
# GCC_WRAPPER
# GNATADC_FILENAME
# LIBRARY_DIRECTORY
# OBJECT_DIRECTORY
# PLATFORM
# CPU
# CPU_MODEL
# RTS_PATH
# RTS
# PROFILE
# ADA_MODE
# OPTIMIZATION_LEVEL
# STACK_LIMIT
# GNATBIND_SECSTACK
# USE_LIBGCC
# USE_LIBM
# USE_LIBADA
# USE_CLIBRARY
# ADAC_SWITCHES_RTS
# CC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
# LOWLEVEL_FILES_PLATFORM
# GCC_SWITCHES_LOWLEVEL_PLATFORM
# INCLUDE_DIRECTORIES
# IMPLICIT_ALI_UNITS
#

# shellcheck disable=SC2016,SC2086,SC2268

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

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
_is=""
_i=0
while [ "$((_i+=1))" -le ${INDENTATION_LEVEL} ] ; do
  _is="${_is}${INDENTATION_ADA}"
done
printf "%s\n" "${_is}$1"
return 0
}

################################################################################
# print_list()                                                                 #
#                                                                              #
# Print a list of items with indentation.                                      #
################################################################################
print_list()
{
_string=""
_is=""
_i=0
while [ "$((_i+=1))" -le "$2" ] ; do
  _is="${_is}${INDENTATION_ADA}"
done
for _i in $1 ; do
  _string=$(printf "%s%s%s\"%s\",\n_" \
            "${_string}"              \
            "${_is}"                  \
            "$3"                      \
            "${_i}"                   \
           )
  _string="${_string%_}"
done
if [ "x${_string}" != "x" ] ; then
  _string="${_string%?}" ; _string="${_string%,}"
  printf "%s\n" "${_string}"
fi
return 0
}

################################################################################
# LFPL_list()                                                                  #
#                                                                              #
# Build a list of the source languages detected in input arguments.            #
################################################################################
LFPL_list()
{
_LFP_S_files=
_LFP_C_files=
_LFP_AD_files=
_LFPL_list=""
for f in "$@" ; do
  case ${f} in
    *.S)
      if [ "x${_LFP_S_files}" != "xY" ] ; then
        _LFP_S_files=Y
        _LFPL_list="${_LFPL_list:+${_LFPL_list} }Asm_Cpp"
      fi
      ;;
    *.c)
      if [ "x${_LFP_C_files}" != "xY" ] ; then
        _LFP_C_files=Y
        _LFPL_list="${_LFPL_list:+${_LFPL_list} }C"
      fi
      ;;
    *.adb|*.ads)
      if [ "x${_LFP_AD_files}" != "xY" ] ; then
        _LFP_AD_files=Y
        _LFPL_list="${_LFPL_list:+${_LFPL_list} }Ada"
      fi
      ;;
  esac
done
printf "%s\n" "${_LFPL_list}"
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

NL=$(printf "\n%s" "_") ; NL=${NL%_}

INDENTATION_ADA="   " # Ada 3-space indentation style

INDENTATION_LEVEL=0

configuregpr=""

#
# Initial empty line.
#
configuregpr=$NL

#
# Declare project.
#
configuregpr=${configuregpr}$(print_I "abstract project ${CONFIGURE_PROJECT} is")$NL
configuregpr=${configuregpr}$NL
INDENTATION_LEVEL=$((INDENTATION_LEVEL+1))

#
# Configuration declarations.
#
configuregpr=${configuregpr}$(print_I "SweetAda_Path                     := \"${SWEETADA_PATH}\";")${NL}
configuregpr=${configuregpr}$(print_I "Toolchain_Prefix                  := \"${TOOLCHAIN_PREFIX}\";")${NL}
configuregpr=${configuregpr}$(print_I "Gprbuild_Prefix                   := \"${GPRBUILD_PREFIX}\";")${NL}
configuregpr=${configuregpr}$(print_I "Toolchain_Name                    := \"${TOOLCHAIN_NAME}\";")${NL}
configuregpr=${configuregpr}$(print_I "GCC_Wrapper                       := \"${GCC_WRAPPER}\";")${NL}
configuregpr=${configuregpr}$(print_I "GnatAdc_Filename                  := \"${GNATADC_FILENAME}\";")${NL}
configuregpr=${configuregpr}$(print_I "Library_Directory                 := \"${LIBRARY_DIRECTORY}\";")${NL}
configuregpr=${configuregpr}$(print_I "Object_Directory                  := \"${OBJECT_DIRECTORY}\";")${NL}
configuregpr=${configuregpr}$(print_I "Platform                          := \"${PLATFORM}\";")${NL}
configuregpr=${configuregpr}$(print_I "Cpu                               := \"${CPU}\";")${NL}
configuregpr=${configuregpr}$(print_I "Cpu_Model                         := \"${CPU_MODEL}\";")${NL}
configuregpr=${configuregpr}$(print_I "RTS_Path                          := \"${RTS_PATH}\";")${NL}
configuregpr=${configuregpr}$(print_I "RTS                               := \"${RTS}\";")${NL}
configuregpr=${configuregpr}$(print_I "Profile                           := \"${PROFILE}\";")${NL}
configuregpr=${configuregpr}$(print_I "Ada_Mode                          := \"${ADA_MODE}\";")${NL}
configuregpr=${configuregpr}$(print_I "Optimization_Level                := \"${OPTIMIZATION_LEVEL}\";")${NL}
configuregpr=${configuregpr}$(print_I "Stack_Limit                       := \"${STACK_LIMIT}\";")${NL}
configuregpr=${configuregpr}$(print_I "Gnatbind_SecStack                 := \"${GNATBIND_SECSTACK}\";")${NL}
configuregpr=${configuregpr}$(print_I "Use_LibGCC                        := \"${USE_LIBGCC}\";")${NL}
configuregpr=${configuregpr}$(print_I "Use_Libm                          := \"${USE_LIBM}\";")${NL}
configuregpr=${configuregpr}$(print_I "Use_LibAda                        := \"${USE_LIBADA}\";")${NL}
configuregpr=${configuregpr}$(print_I "Use_CLibrary                      := \"${USE_CLIBRARY}\";")${NL}
INDENTL="                                      "
configuregpr=${configuregpr}$(print_I "ADAC_Switches_RTS                 := (")${NL}
string=$(print_list "${ADAC_SWITCHES_RTS}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "CC_Switches_RTS                   := (")${NL}
string=$(print_list "${CC_SWITCHES_RTS}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "GCC_Switches_Platform             := (")${NL}
string=$(print_list "${GCC_SWITCHES_PLATFORM}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "Lowlevel_Files_Platform           := (")${NL}
string=$(print_list "${LOWLEVEL_FILES_PLATFORM}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "Lowlevel_Files_Platform_Languages := (")${NL}
string=$(print_list "$(LFPL_list ${LOWLEVEL_FILES_PLATFORM})" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "GCC_Switches_Lowlevel_Platform    := (")${NL}
string=$(print_list "${GCC_SWITCHES_LOWLEVEL_PLATFORM}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "Include_Directories               := (")${NL}
string=$(print_list "${INCLUDE_DIRECTORIES}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}
configuregpr=${configuregpr}$(print_I "Implicit_ALI_Units                := (")${NL}
string=$(print_list "${IMPLICIT_ALI_UNITS}" "${INDENTATION_LEVEL}" "${INDENTL}")
if [ "x${string}" != "x" ] ; then configuregpr=${configuregpr}${string}${NL} ; fi
configuregpr=${configuregpr}$(print_I "                                     );")${NL}

#
# Close project.
#
INDENTATION_LEVEL=$((INDENTATION_LEVEL-1))
configuregpr=${configuregpr}$NL
configuregpr=${configuregpr}$(print_I "end ${CONFIGURE_PROJECT};")${NL}

printf "%s" "${configuregpr}" > "${CONFIGURE_FILENAME}"

log_print "${SCRIPT_FILENAME}: ${CONFIGURE_FILENAME}: done."

exit 0

