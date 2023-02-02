#!/usr/bin/env sh

#
# QEMU-RISC-V QEMU configuration file.
#

# QEMU executable
if [ "x${RISCV32}" = "xY" ] ; then
  QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-riscv32"
fi

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
${QEMU_SETSID} "${QEMU_EXECUTABLE}" \
  -M virt \
  -bios "${SWEETADA_PATH}"/${KERNEL_ROMFILE} \
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
  # skip QEMU bootloader by forcing execution until CPU hits _start
  "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set architecture riscv" \
    -iex "set language ada" \
    "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
    -ex "target remote tcp:localhost:1234" \
    -ex "break *0x80000000" \
    -ex "continue"
fi

exit $?

