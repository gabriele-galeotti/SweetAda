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
"${GXEMUL_EXECUTABLE}" -x -Q -E decstation -e 3min 0xbfc00000:${SWEETADA_PATH}/${KERNEL_ROMFILE}

exit $?

