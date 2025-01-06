#!/usr/bin/env sh

#
# Raspberry Pi 3 OpenOCD-GDB.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# OSTYPE
# PLATFORM_DIRECTORY
# SHARE_DIRECTORY
# KERNEL_OUTFILE
# TERMINAL
# GDB
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# MSYS: hand over to cmd.exe
if [ "x${OSTYPE}" = "xmsys" ] ; then
  exec ${PLATFORM_DIRECTORY}/openocd-gdb.bat "$@"
  exit $?
fi

# load terminal handling
. ${SHARE_DIRECTORY}/terminal.sh

# GDB session
$(terminal ${TERMINAL}) sh -c '\
  "'"${GDB}"'" \
    -q \
    -iex "set basenames-may-differ" \
    -ex "target extended-remote tcp:localhost:3333" \
    -ex "set language asm" \
    -ex "set \$pc=_start" \
    '${KERNEL_OUTFILE}' \
  ; \
  if [ $? -ne 0 ] ; then \
    printf "%s" "Press any key to continue ... " ; \
    read answer ; \
  fi \
  '

exit 0

