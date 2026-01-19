#!/usr/bin/env sh

#
# NEORV32 Radiona ULX3S LiteX front-end script.
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
# PLATFORM_DIRECTORY
# ELFSYMBOL
# KERNEL_OUTFILE
# KERNEL_ENTRY_POINT
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

# generate a pure binary image out of .text/.data sections
${OBJCOPY} \
  -j .text -j .data \
  -I elf32-little ${KERNEL_OUTFILE} \
  -O binary ${PLATFORM_DIRECTORY}/sweetada.bin

KERNEL_ENTRY_POINT=$(${ELFSYMBOL} ${KERNEL_ENTRY_POINT} ${KERNEL_OUTFILE})

# upload SweetAda kernel through litex_term

LITEX_PREFIX=/opt/LiteX
export PYTHONPATH="${LITEX_PREFIX}/litex:${PYTHONPATH}"
USB_DEVICE=/dev/ttyUSB0
CWD=$(pwd)
cd "${LITEX_PREFIX}"/litex/litex/tools

printf "%s\n" "Press the 'F1' button to restart BIOS and upload the executable."

./litex_term.py \
  --speed 115200 \
  --serial-boot \
  --kernel "${CWD}"/${PLATFORM_DIRECTORY}/sweetada.bin \
  --kernel-adr ${KERNEL_ENTRY_POINT} \
  ${USB_DEVICE}

exit 0

