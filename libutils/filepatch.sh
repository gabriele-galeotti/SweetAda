#!/usr/bin/env bash

#
# Patch a file.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = filename
# $2 = offset (hexadecimal)
# $3 = string containing the hexadecimal representation of a byte to patch in
#
# Environment variables:
# none
#
# Example:
# filepatch.sh mbr.bin 1FE "55 AA"
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
if [ "x$1" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no file specified."
  exit 1
fi
if [ "x$2" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no offset supplied."
  exit 1
fi
if [ "x$3" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no data supplied."
  exit 1
fi

OFFSET=$((16#$2))

BYTES_STRING=""
for BYTE in $3 ; do
  BYTES_STRING+="\x${BYTE}"
done

printf "%s" "${BYTES_STRING}" | dd of="$1" bs=1 seek="${OFFSET}" conv=notrunc 2> /dev/null
if [ ${PIPESTATUS[1]} -ne 0 ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: dd."
  exit 1
fi

exit 0

