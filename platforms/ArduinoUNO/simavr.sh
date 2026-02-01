#!/usr/bin/env sh

#
# simavr front-end script.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# SWEETADA_PATH
# PLATFORM_DIRECTORY
# KERNEL_OUTFILE
# SIMAVR_PREFIX
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

cd "${SWEETADA_PATH}"/${PLATFORM_DIRECTORY}

SIMAVR_ARGS=""
SIMAVR_ARGS="${SIMAVR_ARGS} -v -v"
if [ "x$1" = "x-debug" ] ; then
  SIMAVR_ARGS="${SIMAVR_ARGS} -g"
fi
SIMAVR_ARGS="${SIMAVR_ARGS} -m atmega328p"

rm -f *.vcd *.vcd.idx

if [ "x$1" = "x-debug" ] ; then
  "${SIMAVR_PREFIX}"/bin/simavr ${SIMAVR_ARGS} "${SWEETADA_PATH}"/${KERNEL_OUTFILE} &
  xterm -e sh -c '\
    "'"${GDB}"'" \
      -q \
      -ex "target extended-remote tcp:localhost:1234" \
      "'"${SWEETADA_PATH}"'"/'${KERNEL_OUTFILE}
else
  "${SIMAVR_PREFIX}"/bin/simavr ${SIMAVR_ARGS} "${SWEETADA_PATH}"/${KERNEL_OUTFILE}
fi

exit $?

