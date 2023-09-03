#!/usr/bin/env sh

#
# DECstation 500/133 (GXemul emulator).
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
# SWEETADA_PATH
# KERNEL_ROMFILE
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

# GXemul executable
GXEMUL_EXECUTABLE="/opt/GXemul/bin/gxemul"

#
# GXemul parameters and control
#
# activate interactive debugger
# -V
# print executed instructions (-i) and dump registers (-r) on stdout
# -i -r
#
"${GXEMUL_EXECUTABLE}"                          \
  -X -x -Q                                      \
  -E decstation -e 3min                         \
  0xBFC00000:${SWEETADA_PATH}/${KERNEL_ROMFILE} \
  &

exit $?

