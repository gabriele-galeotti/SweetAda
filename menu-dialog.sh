#!/bin/sh

#
# SweetAda configuration and Makefile front-end (dialog version).
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -h       = help
# -p       = pause before exiting
# <action> = action to perform: "configure", "all", etc
#
# Environment variables:
# OS
# MSYSTEM
# PLATFORM
# SUBPLATFORM
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
# dialog_menu()                                                                #
#                                                                              #
################################################################################
dialog_menu()
{
local _s
local _dialog_items_string
local _nitems
local _dialog_height
local _dialog_width
local _dialog_result
_dialog_items_string=""
_nitems=0
_dialog_height=50
_dialog_width=64
for _s in $2 ; do
  #                       tag       item status
  _dialog_items_string+=" \"${_s}\" \"\" off"
  let _nitems++
done
_dialog_result=$(printf "%s\n" "${_dialog_items_string}" | xargs \
  dialog              \
    --stdout          \
    ${ERASE_ON_EXIT}  \
    --radiolist       \
    "\"$1\""          \
    ${_dialog_height} \
    ${_dialog_width}  \
    ${_nitems}        \
    2> /dev/null)
printf "%s\n" ""
eval $3=${_dialog_result}
return 0
}

################################################################################
# createkernelcfg()                                                            #
#                                                                              #
################################################################################
createkernelcfg()
{
local _platforms
local _platform_from_command_line
local _subplatforms
local _f
if [ "x${PLATFORM}" = "x" ] ; then
  # discard SUBPLATFORM
  SUBPLATFORM=""
  # no PLATFORM supplied, select from menu
  _platforms=$(cd platforms ; ls -A -d * 2> /dev/null)
  dialog_menu "Select Platform" "${_platforms}" "PLATFORM"
  _platform_from_command_line="N"
else
  _platform_from_command_line="Y"
fi
# check whether PLATFORM is available, either from command line or the select menu
if [ "x${PLATFORM}" != "x" ] ; then
  _subplatforms=$(cd platforms/${PLATFORM} ; ls -A -d platform-* 2> /dev/null | sed -e "s|platform-||g" -e "s|/\$||g")
  if [ "x${_subplatforms}" != "x" ] ; then
    # subplatforms exist
    if [ "x${SUBPLATFORM}" = "x" ] ; then
      # no SUBPLATFORM supplied
      if [ "${_platform_from_command_line}" = "N" ] ; then
        dialog_menu "Select sub-Platform" "${_subplatforms}" "SUBPLATFORM"
      fi
      # if no SUBPLATFORM supplied, stop configuring
      if [ "x${SUBPLATFORM}" = "x" ] ; then
        log_print "Available subplatforms are:"
        log_print "${_subplatforms}"
        return 1
      fi
    fi
  else
    # no subplatforms
    if [ "${_platform_from_command_line}" = "Y" ] ; then
      # wrongly entered as a command line parameter
      log_print "${SCRIPT_FILENAME}: *** Warning: no subplatform \"${SUBPLATFORM}\" for platform \"${PLATFORM}\", ignoring."
    fi
    SUBPLATFORM=""
  fi
  return 0
fi
return 1
}

################################################################################
# log_build_errors()                                                           #
#                                                                              #
################################################################################
log_build_errors()
{
if [ -s make.errors.log ] ; then
  printf "%s\n" ""
  printf "%s\n" "Detected errors and/or warnings:"
  printf "%s\n" "--------------------------------"
  cat make.errors.log
fi
return 0
}

################################################################################
# action_execute()                                                             #
#                                                                              #
################################################################################
action_execute()
{
local exit_status
case $1 in
  "createkernelcfg")
    rm -f make.log make.errors.log
    createkernelcfg
    if [ $? -eq 0 ] ; then
      PLATFORM=${PLATFORM} SUBPLATFORM=${SUBPLATFORM} "${MAKE}" createkernelcfg 2> make.errors.log | tee make.log
      exit_status=${PIPESTATUS[0]}
      log_build_errors
    fi
    # invalidate PLATFORM and SUBPLATFORM
    PLATFORM=
    SUBPLATFORM=
    ;;
  "configure")
    rm -f make.log make.errors.log
    "${MAKE}" ${MAKE_DEBUG_OPTIONS} configure 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  "all")
    rm -f make.log make.errors.log
    "${MAKE}" ${MAKE_DEBUG_OPTIONS} all 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  "kernel")
    rm -f make.log make.errors.log
    "${MAKE}" ${MAKE_DEBUG_OPTIONS} kernel 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  "postbuild")
    rm -f make.log make.errors.log
    "${MAKE}" ${MAKE_DEBUG_OPTIONS} postbuild 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  "session-start")
    "${MAKE}" session-start
    exit_status=$?
    ;;
  "session-end")
    "${MAKE}" session-end
    exit_status=$?
    ;;
  "run")
    "${MAKE}" run
    exit_status=$?
    ;;
  "debug")
    "${MAKE}" debug
    exit_status=$?
    ;;
  "clean")
    "${MAKE}" clean
    exit_status=$?
    ;;
  "distclean")
    "${MAKE}" distclean
    exit_status=$?
    ;;
  "rts")
    rm -f make.log make.errors.log
    "${MAKE}" ${MAKE_DEBUG_OPTIONS} rts 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  *)
    usage
    exit_status=1
    ;;
esac
return ${exit_status}
}

################################################################################
# usage()                                                                      #
#                                                                              #
################################################################################
usage()
{
printf "%s\n" "${SCRIPT_FILENAME} [-h] [-p] <action>"
printf "%s\n" "-h = help"
printf "%s\n" "-p = pause after execution"
printf "%s\n" "actions:"
printf "%s\n" " createkernelcfg"
printf "%s\n" " configure"
printf "%s\n" " all"
printf "%s\n" " kernel"
printf "%s\n" " postbuild"
printf "%s\n" " session-start"
printf "%s\n" " session-end"
printf "%s\n" " run"
printf "%s\n" " debug"
printf "%s\n" " clean"
printf "%s\n" " distclean"
printf "%s\n" " rts"
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Some ancient versions of dialog do not have this option.
#
DIALOG_VERSION=$(dialog --version | sed -e "s|Version: \([0-9]*[.]*\)*-||")
if [ $((${DIALOG_VERSION})) -ge 20201126 ] ; then
  ERASE_ON_EXIT="--erase-on-exit"
else
  ERASE_ON_EXIT=""
fi

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
    SWEETADA_MAKE="/c/Program Files/SweetAda/bin/make.exe"
    if [ -e "${SWEETADA_MAKE}" ] ; then
      MAKE="${SWEETADA_MAKE}"
    else
      MAKE=make
    fi
    ;;
  *)
    # defaults to system make
    MAKE=make
    ;;
esac

PLATFORM=
SUBPLATFORM=
CPU=

ACTIONS="createkernelcfg configure all kernel postbuild session-start session-end run debug clean distclean rts"
ACTION=""
PAUSE=""

MAKE_DEBUG_OPTIONS=""
#MAKE_DEBUG_OPTIONS="--debug=b" # basic

#
# Parse command line arguments.
#
token_seen=N
while [ $# -gt 0 ] ; do
  if [ "x${1:0:1}" = "x-" ] ; then
    # "-" option
    argument=${1:1}
    case ${argument} in
      "h")
        usage ; exit $?
        ;;
      "p")
        PAUSE="Y"
        ;;
      *)
        printf "%s\n" "Unknown option \"${argument}\"." ; usage ; exit 1
        ;;
    esac
  else
    # no "-" option
    if [ "x${token_seen}" = "xN" ] ; then
      token_seen=Y
      ACTION="$1"
    else
      printf "%s\n" "Multiple actions specified."
      usage
      exit 1
    fi
  fi
  shift
done

#
# Main logic.
#
if [ "x${ACTION}" = "x" ] ; then
  while true ; do
    dialog_menu "Select action" "${ACTIONS}" "RESULT"
    if [ "x${RESULT}" = "x" ] ; then
      exit_status=0
      break
    fi
    action_execute ${RESULT}
    exit_status=$?
    if [ ${exit_status} -eq 0 ] ; then
      read -p "Press <ENTER> to continue: "
    else
      break
    fi
  done
else
  action_execute ${ACTION}
  exit_status=$?
  if [ "x${PAUSE}" = "xY" ] ; then
    read -p "Press <ENTER> to continue: "
  fi
fi

exit ${exit_status}

