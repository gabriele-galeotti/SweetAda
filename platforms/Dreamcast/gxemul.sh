#!/usr/bin/env sh

#
# Dreamcast (GXemul emulator).
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
case ${BOOTTYPE} in
  "ROM")   GXEMUL_BOOT="0xa0000000:\"${SWEETADA_PATH}\"/${KERNEL_ROMFILE}" ;;
  "CDROM") GXEMUL_BOOT="-d ${PLATFORM_DIRECTORY}/sweetada.iso" ;;
esac
"${GXEMUL_EXECUTABLE}" \
  -X -E dreamcast \
  ${GXEMUL_BOOT}

exit 0

