#!/usr/bin/env sh

#
# VMIPS (VMIPS emulator).
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -debug
#
# Environment variables:
# SWEETADA_PATH
# KERNEL_OUTFILE
# KERNEL_ROMFILE
# VMIPS_ENDIAN
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

# MSYS: hand over to cmd.exe
if [ "x${OSTYPE}" = "xmsys" ] ; then
  exec ${PLATFORM_DIRECTORY}/vmips.bat "$@"
  exit $?
fi

# load terminal handling
. ${SHARE_DIRECTORY}/terminal.sh

VMIPS_EXECUTABLE=/opt/VMIPS/bin/vmips

case ${VMIPS_ENDIAN} in
  BIG|big)       VMIPS_ENDIAN_OPT="-o bigendian" ;;
  LITTLE|little) VMIPS_ENDIAN_OPT="-o nobigendian" ;;
esac

if [ "x$1" = "x-debug" ] ; then
  VMIPS_DEBUG="-o debug -o debugport=1234"
fi

# VMIPS machine
$(terminal ${TERMINAL}) \
  ${VMIPS_EXECUTABLE} \
    ${VMIPS_ENDIAN_OPT} \
    -o clockdevice \
    -o clockdeviceirq=7 \
    -o clockintr=100000000 \
    -o testdev \
    ${VMIPS_DEBUG} \
    ${SWEETADA_PATH}/${KERNEL_ROMFILE} \
  &
VMIPS_PID=$!

# debug session
if [ "x$1" = "x-debug" ] ; then
  $(terminal ${TERMINAL}) "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -ex "target remote tcp:localhost:1234" \
    ${KERNEL_OUTFILE}
fi

# wait VMIPS termination
wait ${VMIPS_PID}

exit $?

