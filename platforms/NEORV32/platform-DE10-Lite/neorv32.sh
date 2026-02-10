#!/usr/bin/env sh

#
# NEORV32 DE10-Lite front-end script.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
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
NEORV32_RTL_PATH="${NEORV32_HOME}"/rtl/core
NEORV32_SIM_PATH="${NEORV32_HOME}"/sim
IMAGE_GEN="${NEORV32_HOME}"/sw/image_gen/image_gen
APP_IMG=neorv32_application_image.vhd

# generate a pure binary image out of .text/.data sections
${OBJCOPY} \
  -j .text -j .data \
  -I elf32-little ${KERNEL_OUTFILE} \
  -O binary ${PLATFORM_DIRECTORY}/sweetada.bin
# elaborate a SweetAda VHDL source
cd ${PLATFORM_DIRECTORY}
"${IMAGE_GEN}" -i sweetada.bin -o "${NEORV32_RTL_PATH}"/${APP_IMG} -t app_bin

# send executable to bootloader (which is waiting in "u" mode)
SERIALPORT_DEVICE=/dev/ttyUSB-PL2303
cat "${NEORV32_RTL_PATH}"/${APP_IMG} > ${SERIALPORT_DEVICE}

exit 0

