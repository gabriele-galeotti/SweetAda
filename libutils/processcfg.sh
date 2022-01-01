#!/bin/sh

#
# Process a configuration template file.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = output filename
#
# Environment variables:
# every variable referenced in the input file
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
INPUT_FILENAME="$1"
if [ "x${INPUT_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi
OUTPUT_FILENAME="$2"
if [ "x${OUTPUT_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no output file specified."
  exit 1
fi

#
# Gather "@"-delimited symbols from input file.
#
SYMBOLS=$(grep --binary -o "@[_A-Za-z][_A-Za-z0-9]*@" "${INPUT_FILENAME}" 2> /dev/null)
if [ $? -eq 2 ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: in processing input file \"${INPUT_FILENAME}\"."
  exit 1
fi

#
# Perform variable substitution.
#
if [ "x${SYMBOLS}" != "x" ] ; then
  sed_command_string=()
  for symbol in ${SYMBOLS} ; do
    variable=$(echo ${symbol} | sed -e "s|^\(.*@\)\(.*\)\(@.*\)\$|\2|")
    value="${!variable}"
    if [ "x${value}" = "x" ] ; then
      log_print_error "${SCRIPT_FILENAME}: *** Warning: variable \"${variable}\" has no value."
    fi
    sed_command_string+=("-e")
    sed_command_string+=("s|${symbol}|${value}|")
  done
  sed "${sed_command_string[@]}" "${INPUT_FILENAME}" > "${OUTPUT_FILENAME}" 2> /dev/null
  if [ $? -ne 0 ] ; then
    log_print_error "${SCRIPT_FILENAME}: *** Error: in processing input file \"${INPUT_FILENAME}\"."
    exit 1
  fi
else
  cp -f "${INPUT_FILENAME}" "${OUTPUT_FILENAME}"
fi

log_print "${SCRIPT_FILENAME}: ${OUTPUT_FILENAME}: done."

exit 0

