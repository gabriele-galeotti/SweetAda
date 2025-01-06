#!/usr/bin/env sh

#
# PC-x86 (Bochs emulator).
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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
        printf "%s\n" "$3: timeout waiting for port $1."
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

# MSYS: hand over to cmd.exe
if [ "x${OSTYPE}" = "xmsys" ] ; then
  exec ${PLATFORM_DIRECTORY}/qemu.bat "$@"
  exit $?
fi

# load terminal handling
. ${SHARE_DIRECTORY}/terminal.sh

# Bochs executable and CPU model
BOCHS_EXECUTABLE="/opt/Bochs/bin/bochs-gdb"

# debug options
if [ "x$1" = "x-debug" ] ; then
  BOCHS_DEBUG="gdbstub:  enabled=1, port=1234, text_base=0, data_base=0, bss_base=0"
else
  BOCHS_DEBUG=
fi

# telnet port numbers and listening timeout in s
SERIALPORT0=4446
SERIALPORT1=4447
TILTIMEOUT=3

# create bochsrc
cat > ./${PLATFORM_DIRECTORY}/bochsrc << EOF
log:      ./${PLATFORM_DIRECTORY}/bochs.log
cpu:      count=1, ips=16000000
memory:   guest=4, host=4
romimage: file=${KERNEL_ROMFILE}
vga:      extension=vbe
com1:     enabled=1, mode=socket-server, dev=localhost:${SERIALPORT0}
com2:     enabled=1, mode=socket-server, dev=localhost:${SERIALPORT1}
floppya:  1_44=bootfd, status=inserted
ata0:     enabled=1, ioaddr1=0x1F0, ioaddr2=0x3F0, irq=14
${BOCHS_DEBUG}
EOF

# Bochs machine
"${BOCHS_EXECUTABLE}" -f ./${PLATFORM_DIRECTORY}/bochsrc -q &
BOCHS_PID=$!

# console for serial port
tcpport_is_listening ${SERIALPORT0} ${TILTIMEOUT} "*** Error"
    $(terminal ${TERMINAL}) /bin/telnet localhost ${SERIALPORT0} &
# console for serial port
tcpport_is_listening ${SERIALPORT1} ${TILTIMEOUT} "*** Error"
    $(terminal ${TERMINAL}) /bin/telnet localhost ${SERIALPORT1} &

# debug session
if [ "x$1" = "x-debug" ] ; then
  $(terminal ${TERMINAL}) sh -c '\
    "'"${GDB}"'" \
      -q \
      -iex "set basenames-may-differ" \
      -iex "set architecture i386" \
      -ex "set tcp connect-timeout 30" \
      -ex "target extended-remote tcp:localhost:1234" \
      -ex "tbreak _start" -ex "continue" \
      '${KERNEL_OUTFILE}' \
    ; \
    if [ $? -ne 0 ] ; then \
      printf "%s" "Press any key to continue ... " ; \
      read answer ; \
    fi \
    '
fi

# wait Bochs termination
wait ${BOCHS_PID}

exit $?

