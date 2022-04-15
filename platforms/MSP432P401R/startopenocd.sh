#!/bin/sh

#
# OpenOCD server startup script.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# none
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set -o posix
SCRIPT_FILENAME=$(basename "$0")

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

OPENOCD_PREFIX=/usr/local
OPENOCD_EXECUTABLE=${OPENOCD_PREFIX}/bin/openocd

OPENOCD_ARGS=()
#OPENOCD_ARGS+=("-d3")
OPENOCD_ARGS+=("-f" "${OPENOCD_PREFIX}/share/openocd/scripts/board/ti_msp432_launchpad.cfg")

xterm -hold -e "${OPENOCD_EXECUTABLE}" "${OPENOCD_ARGS[@]}" &

exit $?

