#!/usr/bin/env sh

#
# CCS front-end.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# PLATFORM_DIRECTORY
# CCS_PREFIX
# CCS_NETSERVER_PORT
# USBTAP_SN
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")

################################################################################
# tcpport_is_listening()                                                       #
#                                                                              #
# $1 = port                                                                    #
# $2 = timeout in 1 s units                                                    #
# $3 = error message prefix (empty = no message); example: "*** Error"         #
################################################################################
tcpport_is_listening()
{
_time_start=$(date +%s)
while true ; do
  netstat -l -t --numeric-ports | grep -e ":$1[^0-9]" > /dev/null
  _exit_status=$?
  if   [ "${_exit_status}" -eq 0 ] ; then
    break
  elif [ "${_exit_status}" -eq 2 ] ; then
    printf "%s\n" "$3: command error."
    return 1
  fi
  _time_current=$(date +%s)
  if [ $((_time_current-_time_start)) -gt $2 ] ; then
    if [ "x$3" != "x" ] ; then
      printf "%s\n" "$3: timeout waiting for port $1."
    fi
    return 1
  fi
  sleep 1
done
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

case "x$1" in
  "x-server")
    ${CCS_PREFIX}/bin/ccs -file "${SWEETADA_PATH}"/${LIBUTILS_DIRECTORY}/libccs.tcl
    tcpport_is_listening ${CCS_NETSERVER_PORT} 3 "*** Error"
    if [ $? -ne 0 ] ; then
      exit 1
    fi
    cat << EOF | nc -q 0 localhost ${CCS_NETSERVER_PORT}
#findcc utaps
config cc utap:${USBTAP_SN}
show cc
ccs::config_chain mpc83xx
ccs::display_get_config_chain
ccs::display_core_run_mode 0
EOF
    ;;
  "x-shutdown")
    echo "quit" | nc -q 0 localhost ${CCS_NETSERVER_PORT}
    ;;
  "x-run"|"x-debug")
    cat << EOF | nc -q 0 localhost ${CCS_NETSERVER_PORT}
ccs::stop_core 0
ccs::stat
ccs::reset_to_debug
puts "Loading som.tcl ..."
source [file join "${SWEETADA_PATH}" ${PLATFORM_DIRECTORY} som.tcl]
puts "Loading kernel.rom ..."
loadbinaryfile [file join "${SWEETADA_PATH}" kernel.rom]
ccs::write_reg 0 iar 0
ccs::write_reg 0 iabr 0
ccs::run_core 0
EOF
    ;;
esac

exit 0

