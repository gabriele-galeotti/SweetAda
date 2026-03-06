#!/usr/bin/env sh

#
# DE-10 Lite GDB server.
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
# PATH
# QUARTUS_ROOTDIR
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

QUARTUS_ROOTDIR=/opt/intelFPGA_lite/22.1std/quartus

export PATH=${QUARTUS_ROOTDIR}/bin:${PATH}

nios2-gdb-server --cable "USB-Blaster" --device 1 --tcpport 1234 --init-cache &

exit $?

