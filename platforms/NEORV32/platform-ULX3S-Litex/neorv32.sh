#!/usr/bin/env sh

#
# NEORV32 ULX3S-Litex front-end script.
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
# KERNEL_OUTFILE
# OBJCOPY
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

# generate a pure binary image out of .text/.rodata/.data sections
${OBJCOPY}                                     \
  -j .text -j .rodata -j .data                 \
  -I elf32-little ${KERNEL_OUTFILE}            \
  -O binary ${PLATFORM_DIRECTORY}/sweetada.bin

# upload binary to device using the Litex tools
# we are assuming that the synthesis was done with Litex
USB_PORT=/dev/ttyUSB0

litex_term ${USB_PORT} --kernel=${PLATFORM_DIRECTORY}/sweetada.bin

exit 0

