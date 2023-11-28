#!/usr/bin/env sh

#
# SweetAda configuration and Makefile front-end (dialog version).
#
# Copyright (C) 2020-2023 Gabriele Galeotti
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
# PLATFORM
# SUBPLATFORM
#

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
# dialog_menu()                                                                #
#                                                                              #
################################################################################
dialog_menu()
{
_dialog_items_string=""
_nitems=0
_dialog_height=50
_dialog_width=64
for _s in $2 ; do
  #                                             tag       item status
  _dialog_items_string="${_dialog_items_string} \"${_s}\" \"\" off"
  _nitems=$((_nitems+1))
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
if [ "x${PLATFORM}" = "x" ] ; then
  # discard SUBPLATFORM
  SUBPLATFORM=""
  # no PLATFORM supplied, select from menu
  _platforms=$(cd platforms && ls -A -d * 2> /dev/null)
  dialog_menu "Select Platform" "${_platforms}" "PLATFORM"
  _platform_from_command_line="N"
else
  _platform_from_command_line="Y"
fi
# check whether PLATFORM is available, either from command line or the select menu
if [ "x${PLATFORM}" != "x" ] ; then
  _subplatforms=$(cd platforms/${PLATFORM} && ls -A -d platform-* 2> /dev/null | sed -e "s|platform-||g" -e "s|/\$||g")
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
# make_tee()                                                                   #
#                                                                              #
# $1 make target                                                               #
# $2 make errors file                                                          #
# $3 tee logfile                                                               #
################################################################################
make_tee()
{
exec 4>&1
_exit_status=$(                                \
               {                               \
                 {                             \
                   ${MAKE} "$1" 2> "$2" 3>&- ; \
                   printf "%s" "$?" 1>&3     ; \
                 } 4>&- | tee "$3" 1>&4      ; \
               } 3>&1                          \
              )
exec 4>&-
return ${_exit_status}
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
case $1 in
  "createkernelcfg")
    rm -f make.log make.errors.log
    createkernelcfg
    if [ $? -eq 0 ] ; then
      PLATFORM=${PLATFORM} SUBPLATFORM=${SUBPLATFORM} "${MAKE}" createkernelcfg
      _exit_status=$?
      log_build_errors
    fi
    # invalidate PLATFORM and SUBPLATFORM
    PLATFORM=
    SUBPLATFORM=
    ;;
  "configure")
    rm -f make.log make.errors.log
    "${MAKE}" configure
    _exit_status=$?
    log_build_errors
    ;;
  "all")
    rm -f make.log make.errors.log
    make_tee all make.errors.log make.log
    _exit_status=$?
    log_build_errors
    ;;
  "kernel")
    rm -f make.log make.errors.log
    make_tee kernel make.errors.log make.log
    _exit_status=$?
    log_build_errors
    ;;
  "postbuild")
    rm -f make.log make.errors.log
    make_tee postbuild make.errors.log make.log
    _exit_status=$?
    log_build_errors
    ;;
  "session-start")
    "${MAKE}" session-start
    _exit_status=$?
    ;;
  "session-end")
    "${MAKE}" session-end
    _exit_status=$?
    ;;
  "run")
    "${MAKE}" run
    _exit_status=$?
    ;;
  "debug")
    "${MAKE}" debug
    _exit_status=$?
    ;;
  "clean")
    "${MAKE}" clean
    _exit_status=$?
    ;;
  "distclean")
    "${MAKE}" distclean
    _exit_status=$?
    ;;
  "rts")
    rm -f make.log make.errors.log
    make_tee rts make.errors.log make.log
    _exit_status=$?
    log_build_errors
    ;;
  *)
    usage
    _exit_status=1
    ;;
esac
return ${_exit_status}
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
if [ "${DIALOG_VERSION}" -ge 20201126 ] ; then
  ERASE_ON_EXIT="--erase-on-exit"
else
  ERASE_ON_EXIT=""
fi

if [ "x${MAKE}" = "x" ] ; then
  MAKE=make
fi

PLATFORM=
SUBPLATFORM=
CPU=

ACTIONS="createkernelcfg configure all kernel postbuild session-start session-end run debug clean distclean rts"
ACTION=""
PAUSE=""

#
# Parse command line arguments.
#
token_seen=N
while [ $# -gt 0 ] ; do
  if [ "x${1%${1#?}}" = "x-" ] ; then
    # "-" option
    argument=${1#?}
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
    if [ "${exit_status}" -eq 0 ] ; then
      printf "Press <ENTER> to continue: "
      read answer
    else
      break
    fi
  done
else
  action_execute ${ACTION}
  exit_status=$?
  if [ "x${PAUSE}" = "xY" ] ; then
    printf "Press <ENTER> to continue: "
    read answer
  fi
fi

exit ${exit_status}

