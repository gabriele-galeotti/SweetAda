#!/usr/bin/env sh

#
# Extract a symbol value from an ELF file.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# optional initial -p <prefix_string>
# $1 = symbol name
# $2 = filename
#
# Environment variables:
# TOOLCHAIN_NM
#

# shellcheck disable=SC2016,SC2268,SC2329

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

PREFIX_STRING=""

#
# Check for an optional prefix string.
#
if [ "x$1" = "x-p" ] ; then
   shift ; PREFIX_STRING="$1" ; shift
fi

#
# Basic input parameters check.
#
if [ "x$1" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no symbol name specified."
  exit 1
fi
if [ "x$2" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi

AWK_SCRIPT='{ for (i = 1 ; i <= NF ; i++) { if ($i == "'"$1"'") { print $3 ; next } } }'
SYMBOL_VALUE=$(${TOOLCHAIN_NM} --format=posix "$2" 2> /dev/null | \
               awk -- "${AWK_SCRIPT}"                           | \
               head -n 1 | tr "[:lower:]" "[:upper:]")

if [ "x${SYMBOL_VALUE}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no symbol \"$1\" found."
  exit 1
fi

printf "%s0x%s\n" "${PREFIX_STRING}" "${SYMBOL_VALUE}"

exit 0

