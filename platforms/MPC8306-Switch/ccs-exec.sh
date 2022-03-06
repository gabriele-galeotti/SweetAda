#!/bin/sh

#
# CCS front-end.
#

#
# Arguments:
# none
#
# Environment variables:
# SWEETADA_PATH
# PLATFORM_DIRECTORY
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

CCS_PREFIX=/root/project/hardware/PowerPC/USBTAP

cp -f ${SWEETADA_PATH}/${PLATFORM_DIRECTORY}/autoexec.tcl ${CCS_PREFIX}/bin/
cd ${CCS_PREFIX}/bin
./ccs -console &

exit 0

