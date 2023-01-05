#!/usr/bin/env sh

#
# Create a filesystem symbolic/soft link.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
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

target="$1"
link_name="$2"

if [ -d "${target}" ] ; then
  for f in $(ls -A "${target}"/) ; do
    rm -f "${f}"
    ln -s ${VERBOSE_OPTION} "${target}"/"${f}" "${f}" || exit $?
  done
else
  rm -f "${link_name}"
  ln -s ${VERBOSE_OPTION} "${target}" "${link_name}" || exit $?
fi

exit 0

