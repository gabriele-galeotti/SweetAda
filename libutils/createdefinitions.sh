#!/usr/bin/env sh

#
# Create a GNATPREP definitions file.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = definitions filename
#
# Environment variables:
# PLATFORM
# SUBPLATFORM
# CPU
# CPU_MODEL
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
DEFINITIONS_FILENAME="$1"
if [ "x${DEFINITIONS_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no input file specified."
  exit 1
fi

rm -f "${DEFINITIONS_FILENAME}"
touch "${DEFINITIONS_FILENAME}"

printf "%s\n" "-- ${SCRIPT_FILENAME}" >> "${DEFINITIONS_FILENAME}"

printf "%s\n" "PLATFORM := \"${PLATFORM}\"" >> "${DEFINITIONS_FILENAME}"
if [ "x${SUBPLATFORM}" != "x" ] ; then
  printf "%s\n" "SUBPLATFORM := \"${SUBPLATFORM}\"" >> "${DEFINITIONS_FILENAME}"
fi
printf "%s\n" "CPU := \"${CPU}\"" >> "${DEFINITIONS_FILENAME}"
printf "%s\n" "CPU_MODEL := \"${CPU_MODEL}\"" >> "${DEFINITIONS_FILENAME}"

log_print "${SCRIPT_FILENAME}: ${DEFINITIONS_FILENAME}: done."

exit 0

