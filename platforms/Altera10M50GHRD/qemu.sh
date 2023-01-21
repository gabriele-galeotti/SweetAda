#!/usr/bin/env sh

#
# Altera 10M50GHRD QEMU configuration file.
#

# QEMU executable
QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-nios2"

# telnet ports
MONITORPORT=4445
SERIALPORT0=4446

# console for serial port
/usr/bin/xterm \
  -T "QEMU-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT0} \
  &

# QEMU machine
"${QEMU_EXECUTABLE}" \
  -M 10m50-ghrd \
  -kernel ${KERNEL_OUTFILE} \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT0" \

exit 0

