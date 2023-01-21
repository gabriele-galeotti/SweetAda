#!/usr/bin/env sh

#
# Integrator/CP QEMU configuration file.
#

# QEMU executable
QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-arm"
# GDB executable
GDB_EXECUTABLE="/opt/sweetada/bin/arm-sweetada-eabi-gdb"

# debug options
if [ "x$1" = "x-debug" ] ; then
  QEMU_DEBUG="-S -gdb tcp:localhost:1234,ipv4"
else
  QEMU_DEBUG=
fi

# telnet ports
MONITORPORT=4445
SERIALPORT0=4446
SERIALPORT1=4447

# console for serial port
setsid /usr/bin/xterm \
  -T "QEMU-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT0} \
  &
# console for serial port
setsid /usr/bin/xterm \
  -T "QEMU-2" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT1} \
  &

# QEMU machine
setsid "${QEMU_EXECUTABLE}" \
  -M integratorcp -m 128 \
  -kernel "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT0" \
  -chardev "socket,id=SERIALPORT1,port=${SERIALPORT1},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT1" \
  ${QEMU_DEBUG} \
  &
QEMU_PID=$!

# normal execution or debug execution
if [ "x$1" != "x-debug" ] ; then
  wait ${QEMU_PID}
else
  "${GDB_EXECUTABLE}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set architecture armv5te" \
    -iex "set endian little" \
    -iex "set language ada" \
    "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
    -ex "target remote tcp:localhost:1234"
fi

exit $?

