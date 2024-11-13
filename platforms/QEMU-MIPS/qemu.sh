#!/usr/bin/env sh

#
# QEMU-MIPS (QEMU emulator).
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
# OSTYPE
# PLATFORM_DIRECTORY
# SHARE_DIRECTORY
# CPU_MODEL
# KERNEL_OUTFILE
# KERNEL_ROMFILE
# TERMINAL
# GDB
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")

################################################################################
# tcpport_is_listening()                                                       #
#                                                                              #
# $1 = port                                                                    #
# $2 = timeout in 1 s units                                                    #
# $3 = error message prefix (empty = no message); example: "*** Error"         #
################################################################################
tcpport_is_listening()
{
_time_start=$(date +%s)
while true ; do
  case ${OSTYPE} in
    darwin) _port_listening=$(netstat -a -n -t | grep -c -e "^tcp4.*127.0.0.1.$1.*LISTEN.*\$") ;;
    *)      _port_listening=$(netstat -l -t --numeric-ports | grep -c -e "^tcp.*localhost:$1.*LISTEN.*\$") ;;
  esac
  [ "${_port_listening}" -eq 1 ] && break
  if [ $2 -gt 0 ] ; then
    _time_current=$(date +%s)
    if [ $((_time_current-_time_start)) -gt $2 ] ; then
      if [ "x$3" != "x" ] ; then
        printf "%s\n" "$3: timeout waiting for port $1." 1>&2
      fi
      return 1
    fi
  fi
  sleep 1
done
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

if [ "x${OSTYPE}" = "xmsys" ] ; then
  exec ${PLATFORM_DIRECTORY}/qemu.bat "$@"
  exit $?
fi

# load terminal handling
source ${SHARE_DIRECTORY}/terminal.sh

# QEMU executable and CPU model
case ${CPU_MODEL} in
  MIPS32-24K)
    QEMU_EXECUTABLE="/opt/QEMU/bin/qemu-system-mips"
    QEMU_CPU=24Kf
    GDB_ARCH="mips:isa32"
    ;;
  MIPS64-5K)
    QEMU_EXECUTABLE="/opt/QEMU/bin/qemu-system-mips64"
    QEMU_CPU=5Kf
    GDB_ARCH="mips:isa64"
    ;;
  *)
    printf "%s\n" "${SCRIPT_FILENAME}: *** Error: ${CPU_MODEL}: no CPU or CPU unsupported." 1>&2
    exit 1
    ;;
esac

# debug options
if [ "x$1" = "x-debug" ] ; then
  QEMU_DEBUG="-S -gdb tcp:localhost:1234,ipv4"
else
  QEMU_DEBUG=
fi

# telnet port numbers and listening timeout in s
MONITORPORT=4445
SERIALPORT0=4446
TILTIMEOUT=3

# QEMU machine
"${QEMU_EXECUTABLE}" \
  -M mipssim -cpu ${QEMU_CPU} -m 16 \
  -bios ${KERNEL_ROMFILE} \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=on" \
  -serial "chardev:SERIALPORT0" \
  ${QEMU_DEBUG} \
  &
QEMU_PID=$!

# console for serial port
tcpport_is_listening ${SERIALPORT0} ${TILTIMEOUT} "*** Error"
case ${OSTYPE} in
  darwin)
    osascript -e \
      "tell application \"Terminal\" to do script \"clear ; telnet localhost ${SERIALPORT0} ; exit 0\"" \
      > /dev/null &
    ;;
  *)
    $(terminal ${TERMINAL}) /bin/telnet localhost ${SERIALPORT0} &
    ;;
esac

# debug session
if [ "x$1" = "x-debug" ] ; then
  $(terminal ${TERMINAL}) "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set architecture ${GDB_ARCH}" \
    -ex "set tcp connect-timeout 30" \
    -ex "target extended-remote tcp:localhost:1234" \
    ${KERNEL_OUTFILE}
fi

# wait QEMU termination
wait ${QEMU_PID}

exit $?

