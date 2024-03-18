#!/usr/bin/env sh

#
# Amiga (FS-UAE emulator).
#
# Copyright (C) 2020-2024 Gabriele Galeotti
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

# make the platform directory the CWD so that log files do not end up in the
# top-level directory
cd ${PLATFORM_DIRECTORY}

# FS-UAE executable
FS_UAE_EXECUTABLE="/opt/FS-UAE/bin/fs-uae"

# TCP port for serial port
SERIALPORT=1235

# console for serial port
setsid /usr/bin/xterm \
  -T "FS-UAE" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  "stty -icanon -echo ; while ! nc localhost ${SERIALPORT} 2> /dev/null ; do sleep 0.1 ; done" \
  &

# FS-UAE caches .adf disks
rm -f ~/"Documents/FS-UAE/Save States/fs-uae/boot.adf"

"${FS_UAE_EXECUTABLE}" \
  fs-uae.conf \
  &
FS_UAE_PID=$!

wait ${FS_UAE_PID}

exit $?

