#!/usr/bin/env sh

#
# Dreamcast (GXemul emulator).
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
# SWEETADA_PATH
# PLATFORM_DIRECTORY
# KERNEL_ROMFILE
# BOOT_TYPE
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
case ${BOOT_TYPE} in
  "ROM")
    GXEMUL_BOOT="0xA0000000:${SWEETADA_PATH}/${KERNEL_ROMFILE}"
    ;;
  "CD-ROM")
    GXEMUL_BOOT="-d ${PLATFORM_DIRECTORY}/sweetada.iso"
    ;;
esac

"${GXEMUL_EXECUTABLE}" \
  -X                   \
  -E dreamcast         \
  ${GXEMUL_BOOT}

exit $?

