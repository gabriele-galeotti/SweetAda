#!/usr/bin/env sh

#
# Altera 10M50GHRD QEMU configuration file.
#

# QEMU executable
QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-nios2"

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
SERIALPORT0=4446

# console for serial port
setsid /usr/bin/xterm \
  -T "QEMU-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT0} \
  &

# QEMU machine
${QEMU_SETSID} "${QEMU_EXECUTABLE}" \
  -M 10m50-ghrd \
  -kernel ${KERNEL_OUTFILE} \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT0" \
  ${QEMU_DEBUG} \
  &
QEMU_PID=$!

# normal execution or debug execution
if [ "x$1" != "x-debug" ] ; then
  wait ${QEMU_PID}
else
  "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set architecture nios2" \
    -iex "set language ada" \
    "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
    -ex "target remote tcp:localhost:1234"
fi

exit 0

