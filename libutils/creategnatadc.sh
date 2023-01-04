#!/usr/bin/env bash

#
# Create "gnat.adc" file.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = PROFILE
# $2 = GNATADC_FILENAME
#
# Environment variables:
# every variable referenced
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
PROFILE="$1"
if [ "x${PROFILE}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no PROFILE specified."
  exit 1
fi

GNATADC_FILENAME="$2"
if [ "x${GNATADC_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no GNATADC_FILENAME specified."
  exit 1
fi

if [ ! -e "./${GNATADC_FILENAME}.in" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: ${GNATADC_FILENAME}.in not found."
  exit 1
fi

rm -f "${GNATADC_FILENAME}"
touch "${GNATADC_FILENAME}"

while IFS= read -r textline ; do
  # "woc" = without comments
  textline_woc=$(printf "%s" "${textline}" | sed -e "s|^ *--.*\$||")
  if [ "x${textline_woc}" != "x" ] ; then
    pragma=$(printf "%s" "${textline_woc}" | sed -e "s|^\(pragma.*;\)\(.*\)|\1|")
    profiles=$(printf "%s" "${textline_woc}" | sed -e "s|^\(pragma.*--\)\(.*\)|\2|")
    printf "%s" "${profiles}" | grep -q -w "${PROFILE}" 2> /dev/null
    [ ${PIPESTATUS[1]} -eq 0 ] && printf "%s\n" "${pragma}" >> "${GNATADC_FILENAME}"
  fi
done < "${GNATADC_FILENAME}.in"

log_print "${SCRIPT_FILENAME}: ${GNATADC_FILENAME}: done."

exit 0

