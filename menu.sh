#!/bin/sh

#
# SweetAda configuration and Makefile front-end.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
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
# setplatform()                                                                #
#                                                                              #
################################################################################
setplatform()
{
# select a platform
#PLATFORM=Altera10M50GHRD ; SUBPLATFORM=
#PLATFORM=Amiga-FS-UAE ; SUBPLATFORM=68010
#PLATFORM=ArduinoUno ; SUBPLATFORM=
#PLATFORM=DE10-Lite ; SUBPLATFORM=
#PLATFORM=IntegratorCP ; SUBPLATFORM=
#PLATFORM=LEON3 ; SUBPLATFORM=
#PLATFORM=ML605 ; SUBPLATFORM=
#PLATFORM=Malta ; SUBPLATFORM=
PLATFORM=PC-x86 ; SUBPLATFORM=QEMU-ROM
#PLATFORM=PC-x86-64 ; SUBPLATFORM=QEMU-ROM
#PLATFORM=QEMU-RISC-V-32 ; SUBPLATFORM=
#PLATFORM=SBC5206 ; SUBPLATFORM=
#PLATFORM=SPARCstation5 ; SUBPLATFORM=
#PLATFORM=System390 ; SUBPLATFORM=
#PLATFORM=Taihu ; SUBPLATFORM=
#PLATFORM=XilinxZynqA9 ; SUBPLATFORM=
return 0
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
# usage()                                                                      #
#                                                                              #
################################################################################
usage()
{
printf "%s\n" "Usage: ${SCRIPT_FILENAME} <action>"
printf "%s\n" ""
printf "%s\n" "<action> is one of:"
printf "%s\n" "help            - build system help"
printf "%s\n" "createkernelcfg - create a kernel.cfg file"
printf "%s\n" "configure       - configure the system for a build"
printf "%s\n" "all             - build target"
printf "%s\n" "postbuild       - auxiliary post-processing"
printf "%s\n" "session-start   - perform session start activities"
printf "%s\n" "session-end     - perform session end activities"
printf "%s\n" "run             - run the target"
printf "%s\n" "debug           - debug the target"
printf "%s\n" "clean           - cleanup a build"
printf "%s\n" "distclean       - cleanup and reset the build system"
printf "%s\n" "rts             - build an RTS"
printf "%s\n" ""
printf "%s\n" "Specify PLATFORM=<platform> (and optionally SUBPLATFORM) in the"
printf "%s\n" "environment variable space before executing the \"createkernelcfg\" action."
printf "%s\n" ""
printf "%s\n" "Specify CPU=<cpu> TOOLCHAIN_NAME=<toolchain_name> RTS=<rts> (and"
printf "%s\n" "optionally CPU_MODEL=<cpu_model>) in the environment variable space"
printf "%s\n" "before executing the \"rts\" action."
printf "%s\n" ""
printf "%s\n" "OSTYPE:              ${OSTYPE}"
printf "%s\n" "MAKE:                ${MAKE}"
printf "%s\n" "default PLATFORM:    ${PLATFORM}"
printf "%s\n" "default SUBPLATFORM: ${SUBPLATFORM}"
printf "%s\n" ""
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

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

case $1 in
  "help")
    "${MAKE}" help
    ;;
  "createkernelcfg")
    rm -f make.log make.errors.log
    if [ "x${PLATFORM}" = "x" ] ; then
      setplatform
    fi
    if [ $? -eq 0 ] ; then
      PLATFORM=${PLATFORM} SUBPLATFORM=${SUBPLATFORM} "${MAKE}" createkernelcfg
      exit_status=$?
      log_build_errors
    fi
    ;;
  "configure")
    rm -f make.log make.errors.log
    "${MAKE}" configure
    exit_status=$?
    log_build_errors
    ;;
  "all")
    rm -f make.log make.errors.log
    "${MAKE}" all 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  "kernel")
    rm -f make.log make.errors.log
    "${MAKE}" kernel 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  "postbuild")
    rm -f make.log make.errors.log
    "${MAKE}" postbuild 2> make.errors.log | tee make.log
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
    "${MAKE}" rts 2> make.errors.log | tee make.log
    exit_status=${PIPESTATUS[0]}
    log_build_errors
    ;;
  *)
    usage
    exit_status=1
    ;;
esac

exit ${exit_status}

