#!/bin/sh

#
# Wrapper for dos2unix utility.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
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
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

"${SWEETADA_PATH}"/${LIBUTILS_DIRECTORY}/dos2unix.bat "$@"

exit 0

