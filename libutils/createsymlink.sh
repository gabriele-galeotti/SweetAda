#!/bin/sh

#
# Create a filesystem symbolic/soft link.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = filename (target) or directory
# $2 = filename (link name)
#
# Environment variables:
# VERBOSE
#

#
# If $1 is a directory, all files contained in the directory are made targets
# (with the same filename) of a correspondent symlink, regardless of $2.
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

if [ "x${VERBOSE}" = "xY" ] ; then
  VERBOSE_OPTION="-v"
else
  VERBOSE_OPTION=""
fi

if [ -d "$1" ] ; then
  for f in $(ls -A "$1"/) ; do
    rm -f "${f}"
    ln -s ${VERBOSE_OPTION} "$1"/"${f}" "${f}"
  done
else
  rm -f "$2"
  ln -s ${VERBOSE_OPTION} "$1" "$2"
fi

exit $?

