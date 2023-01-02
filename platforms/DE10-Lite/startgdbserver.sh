#!/bin/sh

#
# DE-10 Lite GDB server.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
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
# QUARTUS_PATH
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

export PATH=${QUARTUS_PATH}/bin:${PATH}

nios2-gdb-server --cable "USB-Blaster" --device 1 --tcpport 1234 --init-cache &

exit $?

