#!/usr/bin/env sh

#
# PC-x86 Bochs.
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
    darwin) _port_listening=$(netstat -a -n -t | grep -c "^tcp4.*127.0.0.1.$1.*LISTEN.*\$") ;;
    *)      _port_listening=$(netstat -l -t --numeric-ports | grep -c "^tcp.*localhost:$1.*LISTEN.*\$") ;;
  esac
  [ "${_port_listening}" -eq 1 ] && break
  _time_current=$(date +%s)
  if [ $((_time_current-_time_start)) -gt $2 ] ; then
    if [ "x$3" != "x" ] ; then
      printf "$3: timeout waiting for port $1.\n"
    fi
    return 1
  fi
  sleep 1
done
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# telnet port numbers and listening timeout in s
SERIALPORT0=4446
SERIALPORT1=4447
TILTIMEOUT=3

BOCHS_EXEC=/opt/Bochs/bin/bochs
BOCHS_RC=()
BOCHS_RC+=("log:      ./${PLATFORM_DIRECTORY}/bochs.log")
BOCHS_RC+=("cpu:      count=1, ips=16000000")
BOCHS_RC+=("memory:   guest=4, host=4")
BOCHS_RC+=("romimage: file=./kernel.rom")
BOCHS_RC+=("vga:      extension=vbe")
BOCHS_RC+=("com1:     enabled=1, mode=socket-server, dev=localhost:${SERIALPORT0}")
BOCHS_RC+=("com2:     enabled=1, mode=socket-server, dev=localhost:${SERIALPORT1}")
BOCHS_RC+=("floppya:  1_44=bootfd, status=inserted")
BOCHS_RC+=("ata0:     enabled=1, ioaddr1=0x1F0, ioaddr2=0x3F0, irq=14")
if [ "x$1" = "x-debug" ] ; then
  BOCHS_RC+=("gdbstub:  enabled=1, port=1234, text_base=0, data_base=0, bss_base=0")
fi
rm -f ./${PLATFORM_DIRECTORY}/bochsrc
touch ./${PLATFORM_DIRECTORY}/bochsrc
for rc in "${BOCHS_RC[@]}" ; do
  echo "${rc}" >> ./${PLATFORM_DIRECTORY}/bochsrc
done
"${BOCHS_EXEC}" -f ./${PLATFORM_DIRECTORY}/bochsrc -q &
BOCHS_PID=$!

# console for serial port
tcpport_is_listening ${SERIALPORT0} ${TILTIMEOUT} "*** Error"
  setsid /usr/bin/xterm \
  -T "BOCHS-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT0} \
  &
# console for serial port
tcpport_is_listening ${SERIALPORT1} ${TILTIMEOUT} "*** Error"
  setsid /usr/bin/xterm \
  -T "BOCHS-2" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT1} \
  &

if [ "x$1" = "x" ] ; then
  wait ${BOCHS_PID}
elif [ "x$1" = "x-debug" ] ; then
  GDB_EXEC=/opt/toolchains/bin/i686-elf-gdb
  GDB_ARGS=()
  GDB_ARGS+=("-iex" "set basenames-may-differ")
  GDB_ARGS+=("-iex" "set architecture i386")
  GDB_ARGS+=(${KERNEL_OUTFILE})
  GDB_ARGS+=("-ex" "target remote tcp:localhost:1234")
  GDB_ARGS+=("-ex" "break _start" "-ex" "continue")
  "${GDB_EXEC}" "${GDB_ARGS[@]}"
fi

exit $?

