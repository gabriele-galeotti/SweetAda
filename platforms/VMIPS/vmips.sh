#!/usr/bin/env sh

#
# VMIPS (VMIPS emulator).
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
# SWEETADA_PATH
# KERNEL_OUTFILE
# KERNEL_ROMFILE
# VMIPS_ENDIAN
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

VMIPS_EXECUTABLE=/opt/VMIPS/bin/vmips

case ${VMIPS_ENDIAN} in
  BIG|big)       VMIPS_ENDIAN_OPT="-o bigendian" ;;
  LITTLE|little) VMIPS_ENDIAN_OPT="-o nobigendian" ;;
esac

if [ "x$1" = "x-debug" ] ; then
  VMIPS_DEBUG="-o debug -o debugport=1234"
fi

setsid /usr/bin/xterm \
  -T "QEMU-2" -geometry 120x50 -bg blue -fg white -sl 1024 -e \
  ${VMIPS_EXECUTABLE}                                         \
    ${VMIPS_ENDIAN_OPT}                                       \
    -o clockdevice                                            \
    -o clockdeviceirq=7                                       \
    -o clockintr=100000000                                    \
    -o testdev                                                \
    ${VMIPS_DEBUG}                                            \
    ${SWEETADA_PATH}/${KERNEL_ROMFILE}                        \
  &
VMIPS_PID=$!

# normal execution or debug execution
if [ "x$1" = "x" ] ; then
  wait ${VMIPS_PID}
elif [ "x$1" = "x-debug" ] ; then
  TERMINAL_RUN_SPEC="xterm -geometry 132x50 -bg rgb:3f/3f/3f -fg rgb:ff/ff/ff -sl 1024 -sb -e"
  #TERMINAL_RUN_SPEC="urxvt -e"
  #TERMINAL_RUN_SPEC="xfce4-terminal -e"
  #TERMINAL_RUN_SPEC="gnome-terminal --"
  #TERMINAL_RUN_SPEC="konsole -e"
  case ${XDG_CONFIG_HOME} in
    "${GNATSTUDIO_PREFIX}"*)
      export XDG_CONFIG_HOME=
      ;;
    *)
      ;;
  esac
  case "${XDG_DATA_DIRS}" in
    "${GNATSTUDIO_PREFIX}"*)
      export XDG_DATA_DIRS=
      ;;
    *)
      ;;
  esac
  ${TERMINAL_RUN_SPEC} "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -ex "target remote tcp:localhost:1234" \
    ${KERNEL_OUTFILE}
  wait $!
fi

exit 0

