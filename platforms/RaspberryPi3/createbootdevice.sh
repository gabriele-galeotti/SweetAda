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
# MSDCARD_MOUNTPOINT
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
disable_commandline_tags=1      # prevent filling low memory with ATAGS
arm_control=0x200               # ARMv8 mode
kernel=kernel.rom               # kernel filename
kernel_old=1                    # load kernel at address 0
#kernel_address=0
EOF

cp -f config.txt ${SWEETADA_PATH}/${KERNEL_ROMFILE} ${MSDCARD_MOUNTPOINT}/

exit 0

