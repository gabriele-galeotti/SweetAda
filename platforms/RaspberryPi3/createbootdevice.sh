#!/usr/bin/env sh

#
# Raspberry Pi 3 boot device creation.
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
# KERNEL_ROMFILE
# USDCARD_UUID
# USDCARD_MOUNTPOINT
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

# install SweetAda on FAT32 1st partition of a micro-SD memory card

USDCARD_DEVICE=$(blkid | grep -e "UUID=\"${USDCARD_UUID}\"" | sed -e "s|^\(/dev/.*\)\(:.*\)\$|\1|")
if [ "x${USDCARD_DEVICE}" = "x" ] ; then
  echo "*** Error: UUID=${USDCARD_UUID}: no device found."
  exit 1
fi

cat > config.txt << EOF
arm_64bit=1                     # ARMv8 mode
core_freq=250                   # core clock frequency
arm_freq=250                    # ARM clock frequency
kernel=${KERNEL_ROMFILE}
enable_jtag_gpio=1              # enable JTAG (GPIO22..27)
EOF

mount ${USDCARD_DEVICE} ${USDCARD_MOUNTPOINT}
cp -f -v config.txt ${SWEETADA_PATH}/${KERNEL_ROMFILE} ${USDCARD_MOUNTPOINT}/ || exit 1
sync ; sync
umount ${USDCARD_MOUNTPOINT}

exit 0

