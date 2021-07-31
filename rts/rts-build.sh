#!/bin/sh

#
# Ada Run-Time System build.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# OS
# MSYSTEM
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set -o posix
SCRIPT_FILENAME=$(basename "$0")
if [ "x${OS}" = "xWindows_NT" ] ; then
  if [ "x${MSYSTEM}" = "x" ] ; then
    OSTYPE=cmd
  else
    OSTYPE=msys
  fi
else
  OSTYPE=$(uname -s 2> /dev/null | tr "[:upper:]" "[:lower:]" | sed -e "s|[^a-z].*||" -e "s|mingw|msys|")
fi

################################################################################
# log_initialize()                                                             #
#                                                                              #
# $1 = log filename                                                            #
# $2 = log text prefix                                                         #
################################################################################
log_initialize()
{
if [ "x$1" != "x" ] ; then
  __LIBRARY_LOG_FILENAME__="$1"
  rm -f "${__LIBRARY_LOG_FILENAME__}"
  touch "${__LIBRARY_LOG_FILENAME__}"
fi
__LIBRARY_LOG_PREFIX__="$2"
return 0
}

################################################################################
# log_echo()                                                                   #
#                                                                              #
# $1       = specifier or message                                              #
# $2 .. $n = messages, one per line                                            #
#                                                                              #
# specifier: "%..."                                                            #
# + = next arg is an additional prefix                                         #
# - = suppress prefix                                                          #
# C = disable logfile output (console mode)                                    #
# E = log to stderr                                                            #
# N = print "<EMPTY>" on empty message                                         #
################################################################################
log_echo()
{
local _prefix2
local _specifier
local _i
local _flag
local _flag_noprefix
local _flag_error
local _flag_console
local _flag_null
local _prefix
local _arg
_prefix2=""
_specifier="$1"
case ${_specifier} in
  %*)
    shift
    # scan specifiers
    for ((_i=1 ; _i<${#_specifier} ; _i++)) ; do
      _flag="${_specifier:$_i:1}"
      case ${_flag} in
        +) _prefix2="$1" ; shift ;;
        -) _flag_noprefix=Y ;;
        C) _flag_console=Y ;;
        E) _flag_error=Y ;;
        N) _flag_null=Y ;;
        %) ;;
        *) ;;
      esac
    done
    if [ "x${_flag_noprefix}" = "xY" ] ; then
      _prefix=""
    else
      _prefix="${__LIBRARY_LOG_PREFIX__}"
    fi
    ;;
  *)
    _prefix="${__LIBRARY_LOG_PREFIX__}"
    ;;
esac
_i=0
while [ $# -gt 0 ] ; do
  if [ "x$1" != "x" ] ; then
    _arg="$1"
  else
    if [ "x${_flag_null}" = "xY" ] ; then
      _arg="<EMPTY>"
    else
      _arg=""
    fi
  fi
  if [ "x${__LIBRARY_LOG_FILENAME__}" != "x" ] && [ "x${_flag_console}" != "xY" ] ; then
    if [ "x${_flag_error}" = "xY" ] ; then
      printf "%s\n" "${_prefix}${_prefix2}${_arg}" | tee -a "${__LIBRARY_LOG_FILENAME__}" 1>&2
    else
      printf "%s\n" "${_prefix}${_prefix2}${_arg}" | tee -a "${__LIBRARY_LOG_FILENAME__}"
    fi
  else
    if [ "x${_flag_error}" = "xY" ] ; then
      printf "%s\n" "${_prefix}${_prefix2}${_arg}" 1>&2
    else
      printf "%s\n" "${_prefix}${_prefix2}${_arg}"
    fi
  fi
  let _i++
  shift
done
return 0
}

################################################################################
# copy_rts_files()                                                             #
#                                                                              #
# Helper function to copy RTS files from one directory to another.             #
# RTS_FILES    = global array holding filename list                            #
# NOCOPY_FILES = global array holding files to be ignored during mass copy     #
# $1           = source directory                                              #
# $2           = destination directory                                         #
################################################################################
copy_rts_files()
{
local nfiles
local nfiles_nocopy
local i
local nocopy
local j
nfiles=${#RTS_FILES[@]}
nfiles_nocopy=${#NOCOPY_FILES[@]}
for ((i=0 ; i<${nfiles} ; i++)) ; do
  nocopy=
  for ((j=0 ; j<${nfiles_nocopy} ; j++)) ; do
    if [ "${RTS_FILES[$i]}" = "${NOCOPY_FILES[$j]}" ] ; then
      nocopy=Y
      break
    fi
  done
  if [ "x${nocopy}" = "xY" ] ; then
    log_echo "%" "discarding: ${RTS_FILES[$i]}"
  else
    log_echo "%" "copying: ${RTS_FILES[$i]} -> $2"
    cp -f "$1"/${RTS_FILES[$i]} "$2"/ || return $?
  fi
done
return 0
}

################################################################################
# rts_build_multilib()                                                         #
#                                                                              #
# $1 = multilib directory                                                      #
# $2 = multilib switches                                                       #
################################################################################
rts_build_multilib()
{
# RTS build path with multilib spec ("base"), parent of adainclude and adalib
local RTS_PATH
local MULTILIB_SWITCHES
local ADAINCLUDE
local ADALIB
local nfiles
local nfiles_nolib
local i
local nolib
local j
local exit_status
RTS_PATH="$1"
MULTILIB_SWITCHES="$2"
# assemble "working" RTS multilib subdirectory names
ADAINCLUDE="${RTS_PATH}"/adainclude
ADALIB="${RTS_PATH}"/adalib
log_echo "%" "ADAINCLUDE: ${ADAINCLUDE}"
log_echo "%" "ADALIB:     ${ADALIB}"
# create new RTS multilib subdirectories
mkdir -p "${ADAINCLUDE}"
mkdir -p "${ADALIB}"
# initialize arrays for RTS file handling
RTS_FILES=()             # array of files to be copied in copy_rts_files()
NOCOPY_FILES=()          # array of files to be ignored in copy_rts_files()
LIBGNAT_FILES=()         # array filled by configuration.in
LIBGNARL_FILES=()        # array filled by configuration.in
LIBGNAT_FILES_TARGET=()  # array filled by configuration.in
LIBGNARL_FILES_TARGET=() # array filled by configuration.in
NOLIB_FILES=()           # array of files not to be included in build
LIBGNAT_SRCS=()          # list of files for Makefile
LIBGNARL_SRCS=()         # list of files for Makefile
# NOTE: configuration.in files (both RTS-common and target-dependent) are
# sourced (and thus executed) in theirs respective directories
# NOTE: sourced scripts, if they want, should manipulate files by explicitly
# overriding/copying/deleting/creating them by referring to ADAINCLUDE
# (which is an absolute path)
# NOTE: included script fragments should explicitly export variables which are
# used afterwards by Makefile
####################################
# 1) common section: configuration #
####################################
if [ -e ${RTS_SOURCE_PATH}/configuration.in ] ; then
  pushd ${RTS_SOURCE_PATH} > /dev/null
  log_echo "%" "loading $(pwd)/configuration.in"
  . ./configuration.in
  popd > /dev/null
else
  log_echo "%E" "*** Warning: no \"RTS-common\" configuration.in."
fi
##############################################
# 2) target-dependent section: configuration #
##############################################
if [ -e ${RTS_SOURCE_PATH_TARGET}/configuration.in ] ; then
  pushd ${RTS_SOURCE_PATH_TARGET} > /dev/null
  log_echo "%" "loading $(pwd)/configuration.in"
  . ./configuration.in
  popd > /dev/null
else
  log_echo "%E" "*** Warning: no \"target-dependent\" configuration.in."
fi
##############################
# 3) common section: actions #
##############################
if [ -e ${RTS_SOURCE_PATH}/rts-build.in ] ; then
  pushd ${RTS_SOURCE_PATH} > /dev/null
  log_echo "%" "loading $(pwd)/rts-build.in"
  . ./rts-build.in
  popd > /dev/null
else
  log_echo "%E" "*** Warning: no \"RTS-common\" rts-build.in."
fi
########################################
# 4) target-dependent section: actions #
########################################
if [ -e ${RTS_SOURCE_PATH_TARGET}/rts-build.in ] ; then
  pushd ${RTS_SOURCE_PATH_TARGET} > /dev/null
  log_echo "%" "loading $(pwd)/rts-build.in"
  . ./rts-build.in
  popd > /dev/null
else
  log_echo "%E" "*** Warning: no \"target-dependent\" rts-build.in."
fi
##########################################
# 5) target-dependent Makefile variables #
##########################################
if [ -e ${RTS_SOURCE_PATH_TARGET}/Makefile.rts.in ] ; then
  pushd ${RTS_SOURCE_PATH_TARGET} > /dev/null
  log_echo "%" "installing $(pwd)/Makefile.rts.in"
  cp -f ./Makefile.rts.in "${ADAINCLUDE}" || exit $?
  popd > /dev/null
fi
# generate RTS list for Makefile
log_echo "%" "creating RTS list for Makefile"
##############################
# 1) LIBGNAT: common section #
##############################
nfiles=${#LIBGNAT_FILES[@]}
nfiles_nolib=${#NOLIB_FILES[@]}
for ((i=0 ; i<${nfiles} ; i++)) ; do
  nolib=
  for ((j=0 ; j<${nfiles_nolib} ; j++)) ; do
    if [ "${RTS_FILES[$i]}" = "${NOLIB_FILES[$j]}" ] ; then
      nolib=Y
      break
    fi
  done
  if [ "x${nolib}" = "xY" ] ; then
    continue
  fi
  case ${LIBGNAT_FILES[$i]} in
    *.ads)
      LIBGNAT_SRCS+=("${LIBGNAT_FILES[$i]}")
      ;;
    *)
      ;;
  esac
done
########################################
# 2) LIBGNAT: target-dependent section #
########################################
nfiles=${#LIBGNAT_FILES_TARGET[@]}
for ((i=0 ; i<${nfiles} ; i++)) ; do
  case ${LIBGNAT_FILES_TARGET[$i]} in
    *.ads)
      LIBGNAT_SRCS+=("${LIBGNAT_FILES_TARGET[$i]}")
      ;;
    *)
      ;;
  esac
done
###############################
# 3) LIBGNARL: common section #
###############################
nfiles=${#LIBGNARL_FILES[@]}
nfiles_nolib=${#NOLIB_FILES[@]}
for ((i=0 ; i<${nfiles} ; i++)) ; do
  nolib=
  for ((j=0 ; j<${nfiles_nolib} ; j++)) ; do
    if [ "${RTS_FILES[$i]}" = "${NOLIB_FILES[$j]}" ] ; then
      nolib=Y
      break
    fi
  done
  if [ "x${nolib}" = "xY" ] ; then
    continue
  fi
  case ${LIBGNARL_FILES[$i]} in
    *.ads)
      LIBGNARL_SRCS+=("${LIBGNARL_FILES[$i]}")
      ;;
    *)
      ;;
  esac
done
#########################################
# 4) LIBGNARL: target-dependent section #
#########################################
nfiles=${#LIBGNARL_FILES_TARGET[@]}
for ((i=0 ; i<${nfiles} ; i++)) ; do
  case ${LIBGNARL_FILES_TARGET[$i]} in
    *.ads)
      LIBGNARL_SRCS+=("${LIBGNARL_FILES_TARGET[$i]}")
      ;;
    *)
      ;;
  esac
done
# RTS build takes place in RTS_BUILD_PATH/<multilib>/adainclude
cd "${ADAINCLUDE}"
log_echo "%" "installing Makefile in $(pwd)"
cp -f ${MAKEFILE_DIRECTORY}/Makefile "${ADAINCLUDE}" || exit $?
cat > Makefile.srcs.in << EOF
LIBGNAT_SRCS  := ${LIBGNAT_SRCS[@]}
LIBGNARL_SRCS := ${LIBGNARL_SRCS[@]}
EOF
export RTS_PATH
export MULTILIB_SWITCHES
#log_echo "%" "using ADAC switches: \"${ADAC_SWITCHES_RTS}\""
#log_echo "%" "using CC switches:   \"${CC_SWITCHES_RTS}\""
# diagnostic
#log_echo "%" "pwd: $(pwd)"
log_echo "%" "build RTS in ${ADAINCLUDE}"
"${MAKE}" 2>&1 | tee -a "${LOG_FILENAME}"
exit_status=${PIPESTATUS[0]}
# delete unnecessary files after RTS compilation
rm -f "${ADAINCLUDE}"/Makefile "${ADAINCLUDE}"/Makefile.srcs.in "${ADAINCLUDE}"/Makefile.rts.in
[ ${exit_status} -eq 0 ] || return 1
return 0
}

################################################################################
# rts_build()                                                                  #
#                                                                              #
################################################################################
rts_build()
{
local MULTILIBS
local MULTILIB_DIRECTORY
local MULTILIB_SWITCHES
local MULTILIB_SWITCHES_STRING
local m
# NOTE: do not use GCC_MULTIDIR variable sourced from master Makefile (it is
# the *specific* multilib path referring to the selected target, generated by
# "-print-multi-directory")
MULTILIBS=$(${TOOLCHAIN_GCC} -print-multi-lib 2> /dev/null)
log_echo "%" ""
log_echo "%" "${TARGET}: multilib output list from GCC:"
for m in ${MULTILIBS} ; do
  log_echo "%" "${m}"
done
if [ "x$1" = "x" ] ; then
  log_echo "%" ""
  log_echo "%" "${TARGET}: no multilib specified, build all available multilibs"
else
  log_echo "%" ""
  log_echo "%" "${TARGET}: build multilib \"$1\""
fi
# from: build-gcc.../<target>/libgcc/Makefile, target "multi-do"
for m in ${MULTILIBS} ; do
  MULTILIB_DIRECTORY=$(printf "%s\n" ${m} | sed -e "s|;.*\$||")
  # if a multilib is explicitly specified but does not match, ignore it
  if [ "x$1" != "x" ] && [ "$1" != "${MULTILIB_DIRECTORY}" ] ; then
    continue
  fi
  # compute switches
  MULTILIB_SWITCHES=$(printf "%s\n" ${m} | sed -e "s|^[^;]*;||" -e "s|@| -|g" -e "s|^ ||")
  if [ "x${MULTILIB_SWITCHES}" != "x" ] ; then
    MULTILIB_SWITCHES_STRING="${MULTILIB_SWITCHES}"
  else
    MULTILIB_SWITCHES_STRING="<none>"
  fi
  log_echo "%" ""
  log_echo "%" "--------------------------------------------------------------------------------"
  log_echo "%" "TARGET:             ${TARGET}"
  log_echo "%" "RTS:                ${RTS}"
  log_echo "%" "multilib directory: ${MULTILIB_DIRECTORY}"
  log_echo "%" "compiler switches:  ${MULTILIB_SWITCHES_STRING}"
  log_echo "%" "install directory:  ${RTS_BUILD_PATH}/${MULTILIB_DIRECTORY}"
  log_echo "%" "--------------------------------------------------------------------------------"
  log_echo "%" ""
  # delete current multilib RTS subdirectory
  rm -f "${RTS_BUILD_PATH}"/${MULTILIB_DIRECTORY}/adainclude/*
  rm -f "${RTS_BUILD_PATH}"/${MULTILIB_DIRECTORY}/adalib/*
  # build
  rts_build_multilib "${RTS_BUILD_PATH}"/${MULTILIB_DIRECTORY} "${MULTILIB_SWITCHES}" || return 1
  log_echo "%" ""
done
# install Makefile.rts.in (will be used by SweetAda Makefile.tc.in)
cp -f "${RTS_SOURCE_PATH_TARGET}"/Makefile.rts.in "${RTS_BUILD_PATH}"/
# done
log_echo "%" "RTS build successful."
log_echo "%" ""
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

LOG_FILENAME="$(pwd)/${SCRIPT_FILENAME}.log"
log_initialize "${LOG_FILENAME}" "${SCRIPT_FILENAME}: "

case ${OSTYPE} in
  darwin)
    # use SweetAda make (try a standard installation prefix)
    SWEETADA_MAKE=/opt/sweetada/bin/make
    if [ -e "${SWEETADA_MAKE}" ] ; then
      MAKE="${SWEETADA_MAKE}"
    else
      MAKE=make
    fi
    ;;
  msys)
    # use SweetAda make (try a standard installation prefix)
    MAKE="/c/Program Files/SweetAda/bin/make.exe"
    ;;
  *)
    # defaults to system make
    MAKE=make
    ;;
esac

# remember, to copy Makefile in the build directory
MAKEFILE_DIRECTORY=$(pwd)

# detect parameters from top-level configuration.in
pushd .. > /dev/null
TOOLCHAIN_PREFIX=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_PREFIX" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_AArch64=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_AArch64" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_ARM=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_ARM" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_ARMeb=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_ARMeb" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_AVR=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_AVR" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_M68k=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_M68k" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_MIPS=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_MIPS" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_MIPS64=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_MIPS64" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_MicroBlaze=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_MicroBlaze" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_NiosII=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_NiosII" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_PowerPC=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_PowerPC" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_RISCV=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_RISCV" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_SH4=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_SH4" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_SPARC=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_SPARC" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_SPARC64=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_SPARC64" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_SuperH=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_SuperH" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_System390=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_System390" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_x86=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_x86" "${MAKE}" -s probevariable 2> /dev/null)
TOOLCHAIN_NAME_x86_64=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_NAME_x86_64" "${MAKE}" -s probevariable 2> /dev/null)
RTS_BASE_PATH=$(VERBOSE= PROBEVARIABLE="RTS_BASE_PATH" "${MAKE}" -s probevariable 2> /dev/null)
ADA_MODE=$(VERBOSE= PROBEVARIABLE="ADA_MODE" "${MAKE}" -s probevariable 2> /dev/null)
#RTS=$(VERBOSE= PROBEVARIABLE="RTS" "${MAKE}" -s probevariable 2> /dev/null)
popd > /dev/null

# force the RTS type for whole build (avoid to pick up a private setting from a
# platform-dependent configuration.in that could override it)
#RTS=zfp
RTS=sfp

TOOLCHAIN_NAMES=()
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_AArch64})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_ARM})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_ARMeb})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_AVR})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_M68k})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_MIPS})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_MIPS64})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_MicroBlaze})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_NiosII})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_PowerPC})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_RISCV})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_SH4})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_SPARC})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_SPARC64})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_SuperH})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_System390})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_x86})
TOOLCHAIN_NAMES+=(${TOOLCHAIN_NAME_x86_64})

for TOOLCHAIN_NAME in "${TOOLCHAIN_NAMES[@]}" ; do
  # assemble toolchain executables
  TOOLCHAIN_GCC="${TOOLCHAIN_NAME}-gcc"
  TOOLCHAIN_GCC_WRAPPER="${TOOLCHAIN_NAME}-gcc-wrapper"
  TOOLCHAIN_ADAC="${TOOLCHAIN_NAME}-gcc -x ada"
  TOOLCHAIN_CC="${TOOLCHAIN_NAME}-gcc"
  TOOLCHAIN_AR="${TOOLCHAIN_NAME}-ar"
  TOOLCHAIN_RANLIB="${TOOLCHAIN_NAME}-ranlib"
  # RTS build context: "TARGET" is synonymous with "TOOLCHAIN_NAME"
  TARGET=${TOOLCHAIN_NAME}
  # assemble RTS build paths
  RTS_SOURCE_PATH=${RTS_BASE_PATH}/src/${RTS}
  RTS_SOURCE_PATH_TARGET=${RTS_BASE_PATH}/src/targets/${TARGET}
  RTS_BUILD_PATH=${RTS_BASE_PATH}/${RTS}/${TARGET}
  # dump build informations
  log_echo "%" "================================================================================"
  log_echo "%" ""
  log_echo "%" "TOOLCHAIN_PREFIX:      ${TOOLCHAIN_PREFIX}"
  log_echo "%" "TOOLCHAIN_NAME:        ${TOOLCHAIN_NAME}"
  log_echo "%" "TOOLCHAIN_GCC:         ${TOOLCHAIN_GCC}"
  log_echo "%" "TOOLCHAIN_GCC_WRAPPER: ${TOOLCHAIN_GCC_WRAPPER}"
  log_echo "%" "TOOLCHAIN_ADAC:        ${TOOLCHAIN_ADAC}"
  log_echo "%" "TOOLCHAIN_CC:          ${TOOLCHAIN_CC}"
  log_echo "%" "TOOLCHAIN_AR:          ${TOOLCHAIN_AR}"
  log_echo "%" "TOOLCHAIN_RANLIB:      ${TOOLCHAIN_RANLIB}"
  log_echo "%" "RTS:                   ${RTS}"
  log_echo "%" "RTS_BASE_PATH:         ${RTS_BASE_PATH}"
  log_echo "%" "RTS_SOURCE_PATH:       ${RTS_SOURCE_PATH}"
  log_echo "%" "RTS_BUILD_PATH:        ${RTS_BUILD_PATH}"
  log_echo "%" "ADA_MODE:              ${ADA_MODE}"
  #read -p "Press <ENTER> to continue or <CTRL-C> to abort: "
  # export variables to Makefile
  export PATH=${TOOLCHAIN_PREFIX}/bin:${PATH}
  export TOOLCHAIN_GCC
  export TOOLCHAIN_GCC_WRAPPER
  export TOOLCHAIN_ADAC
  export TOOLCHAIN_CC
  export TOOLCHAIN_AR
  export TOOLCHAIN_RANLIB
  export ADA_MODE
  rts_build || exit $?
done

exit 0

