#!/usr/bin/env sh

#
# Create "gnat.adc" file.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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

# shellcheck disable=SC2086,SC2268

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

NL=$(printf "\n%s" "_") ; NL=${NL%_}

gnatadc=""

while IFS= read -r textline ; do
  # "woc" = without comments
  textline_woc=$(printf "%s" "${textline}" | sed -e "s|^ *--.*\$||")
  if [ "x${textline_woc}" != "x" ] ; then
    pragma=$(printf "%s" "${textline_woc}" | sed -e "s|^\(pragma.*;\)\(.*\)|\1|")
    profiles=$(printf "%s" "${textline_woc}" | sed -e "s|^\(pragma.*--\)\(.*\)|\2|")
    profile_check=$(printf "%s" "${profiles}" | grep -c -w -e "${PROFILE}" 2> /dev/null)
    if [ "x${profile_check}" != "x0" ] ; then
      gnatadc=${gnatadc}$(printf "%s" "${pragma}")${NL}
    fi
  fi
done < "${GNATADC_FILENAME}.in"

printf "%s" "${gnatadc}" > ${GNATADC_FILENAME}

log_print "${SCRIPT_FILENAME}: ${GNATADC_FILENAME}: done."

exit 0

