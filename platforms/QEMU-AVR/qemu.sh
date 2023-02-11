#!/usr/bin/env sh

#
# QEMU-AVR QEMU.
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

# QEMU executable
QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-avr"

# debug options
if [ "x$1" = "x-debug" ] ; then
  QEMU_SETSID="setsid"
  QEMU_DEBUG="-S -gdb tcp:localhost:1234,ipv4"
else
  QEMU_SETSID=
  QEMU_DEBUG=
fi

# telnet ports
MONITORPORT=4445

# QEMU machine
${QEMU_SETSID} "${QEMU_EXECUTABLE}" \
  -M uno -cpu avr5-avr-cpu \
  -bios ${KERNEL_ROMFILE} \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  ${QEMU_DEBUG} \
  &
QEMU_PID=$!

# normal execution or debug execution
if [ "x$1" = "x" ] ; then
  wait ${QEMU_PID}
elif [ "x$1" = "x-debug" ] ; then
  "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set architecture avr" \
    -iex "set language ada" \
    ${KERNEL_OUTFILE} \
    -ex "target remote tcp:localhost:1234"
fi

exit 0

