#!/usr/bin/env sh

#
# NEORV32 DE10-Lite front-end script.
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
# PATH
# PLATFORM_DIRECTORY
# KERNEL_OUTFILE
# OBJCOPY
# NEORV32_HOME
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

# paths and filenames extracted from "<NEORV32_HOME>/sw/common/common.mk"
IMAGE_GEN="${NEORV32_HOME}"/sw/image_gen/image_gen
APP_BIN=neorv32_exe.bin
SERIALPORT_DEVICE=/dev/ttyUSB-PL2303

# generate a pure binary image out of .text/.rodata/.data sections
${OBJCOPY}                                     \
  -j .text -j .rodata -j .data                 \
  -I elf32-little ${KERNEL_OUTFILE}            \
  -O binary ${PLATFORM_DIRECTORY}/sweetada.bin
# elaborate a SweetAda executable
cd ${PLATFORM_DIRECTORY}
"${IMAGE_GEN}" -app_bin sweetada.bin ${APP_BIN}
# send executable to bootloader (which is waiting in "u" mode)
cat ${APP_BIN} > ${SERIALPORT_DEVICE}

exit 0

