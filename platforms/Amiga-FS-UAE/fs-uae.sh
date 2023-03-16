#!/usr/bin/env sh

#
# Amiga (FS-UAE emulator).
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

# make the platform directory the CWD so that log files do not end up in the
# top-level directory
cd ${PLATFORM_DIRECTORY}

# FS-UAE executable
FS_UAE_EXECUTABLE="/opt/FS-UAE/bin/fs-uae"

# TCP port for serial port
SERIALPORT=1235

"${FS_UAE_EXECUTABLE}" \
  fs-uae.conf \
  &
FS_UAE_PID=$!

# console for serial port
tcpport_is_listening ${SERIALPORT} 3 "*** Error"
setsid /usr/bin/xterm \
  -T "FS-UAE" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  "stty -icanon -echo ; nc localhost ${SERIALPORT}" \
  &

wait ${FS_UAE_PID}

exit $?

