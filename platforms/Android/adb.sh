#!/usr/bin/env sh

#
# Android ADB front-end script.
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
# KERNEL_OUTFILE
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

# ADB tool
ADB_EXECUTABLE=/opt/platform-tools/adb
# smartphone directory (as seen from the device) where to store the kernel
DEVICE_DIRECTORY=/sdcard

${ADB_EXECUTABLE} push ${KERNEL_OUTFILE} ${DEVICE_DIRECTORY}
${ADB_EXECUTABLE} shell "${DEVICE_DIRECTORY}/${KERNEL_OUTFILE} ; echo \"exit status = \$?\" ; exit"

exit 0

