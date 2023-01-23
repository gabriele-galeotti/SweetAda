#!/usr/bin/env sh

#
# Malta QEMU configuration file.
#

# QEMU executable
if [ "x${CPU_MODEL}" = "xMIPS32-24K" ] ; then
  QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-mips"
  QEMU_CPU=24Kf
  GDB_ARCH="mips:isa32"
else
  QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-mips64"
  QEMU_CPU=5Kc
  GDB_ARCH="mips:isa64"
fi
# GDB executable
GDB_EXECUTABLE="/opt/sweetada/bin/mips-sweetada-elf-gdb"

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
"${QEMU_EXECUTABLE}" \
  -M malta -cpu ${QEMU_CPU} \
  -L "${SWEETADA_PATH}" -bios "${KERNEL_ROMFILE}" \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT0" \
  -chardev "socket,id=SERIALPORT1,port=${SERIALPORT1},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT1" \
  &
QEMU_PID=$!

# normal execution or debug execution
if [ "x$1" != "x-debug" ] ; then
  wait ${QEMU_PID}
else
  "${GDB_EXECUTABLE}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set architecture ${GDB_ARCH}" \
    -iex "set language ada" \
    "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
    -ex "target remote tcp:localhost:1234" \
    -ex "break *0x80000000" \
    -ex "continue"
fi

exit $?

