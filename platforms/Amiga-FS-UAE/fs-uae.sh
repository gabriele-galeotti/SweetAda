#!/usr/bin/env sh

#
# Amiga (FS-UAE emulator).
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
# PLATFORM_DIRECTORY
# SHARE_DIRECTORY
# TERMINAL
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

# FS-UAE executable
FS_UAE_EXECUTABLE="/opt/FS-UAE/bin/fs-uae"

# TCP port for serial port
SERIALPORT=1235

# load terminal handling
. ${SHARE_DIRECTORY}/terminal.sh

# FS-UAE caches .adf disks
rm -f ~/"Documents/FS-UAE/Save States/fs-uae/boot.adf"

# change the working directory to platform so that log files do not end up in
# the top-level directory
cd ${PLATFORM_DIRECTORY}

# console for serial port
$(terminal ${TERMINAL}) \
  "stty -icanon -echo ; while ! nc localhost ${SERIALPORT} 2> /dev/null ; do sleep 0.1 ; done" \
  &

# run FS-UAE
"${FS_UAE_EXECUTABLE}" \
  fs-uae.conf \
  &
FS_UAE_PID=$!

wait ${FS_UAE_PID}

exit $?

