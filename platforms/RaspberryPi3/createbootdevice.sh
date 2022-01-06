#!/bin/sh

#
# Raspberry Pi 3 boot device creation.
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
# SWEETADA_PATH
# KERNEL_ROMFILE
# USDCARD_MOUNTPOINT
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

cat > config.txt << EOF
# prevent filling low memory with ATAGS
disable_commandline_tags=1
# core clock frequency
core_freq=250
# ARM clock frequency
arm_freq=250
# ARMv8 mode
arm_control=0x200
#arm_64bit=1
# kernel filename
kernel=kernel.rom
# load kernel at address 0
kernel_old=1
#kernel_address=0
# enable JTAG (GPIO22..27)
enable_jtag_gpio=1
# enable UART (GPIO14,15)
enable_uart=1
EOF

cp -f -v config.txt ${SWEETADA_PATH}/${KERNEL_ROMFILE} ${USDCARD_MOUNTPOINT}/ || exit 1

sync ; sync

exit 0

