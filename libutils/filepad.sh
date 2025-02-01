#!/usr/bin/env sh

#
# Pad a file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = final length or size modulo (allowed specification like "512k")
#
# Environment variables:
# OSTYPE
#

# shellcheck disable=SC2016,SC2086,SC2181,SC2268,SC3028

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
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi
if [ "x$2" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no file length specified."
  exit 1
fi

if [ "x${OSTYPE}" = "xdarwin" ] ; then
  FILESIZE=$(stat -f "%z" "$1" 2> /dev/null)
else
  FILESIZE=$(stat -c "%s" "$1" 2> /dev/null)
fi

#
# Parse a number (eventually in units of kB).
# The strange "s + 0" is a workaround for Darwin awk which lacks strtonum().
#
AWK_SCRIPT_FUNCTION='\
$1 ~ /^[0-9]+[k|K]?$/               \
{                                   \
        s = toupper($1);            \
        l = length($1);             \
        n = s + 0;                  \
        if (substr(s, l, 1) == "K") \
        {                           \
                n = n * 1024;       \
        }                           \
        printf "%d\n", n            \
}                                   \
'
REQUESTEDSIZE=$(printf "%s\n" "$2" | awk "${AWK_SCRIPT_FUNCTION}")

#
# If the supplied file length is less than the current file size, it is
# taken as a "modulo".
#
if [ "${REQUESTEDSIZE}" -lt "${FILESIZE}" ] ; then
  MODULOREM=$(printf "%s\n" "${FILESIZE}%${REQUESTEDSIZE}" | bc)
  if [ "${MODULOREM}" -gt 0 ] ; then
    PADCOUNT=$(($2-MODULOREM))
  else
    PADCOUNT=0
  fi
else
  PADCOUNT=$((REQUESTEDSIZE-FILESIZE))
fi

log_print "${SCRIPT_FILENAME}: padding file \"$(basename $1)\"."

if [ "${PADCOUNT}" -gt 0 ] ; then
  dd if=/dev/zero ibs=1 count="${PADCOUNT}" >> "$1" 2> /dev/null
  if [ $? -ne 0 ] ; then
    log_print_error "${SCRIPT_FILENAME}: *** Error: dd."
    exit 1
  fi
fi

exit 0

