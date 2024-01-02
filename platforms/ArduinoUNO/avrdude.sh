#!/usr/bin/env sh

#
# AVRDUDE front-end script.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# KERNEL_ROMFILE
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

AVRDUDE_PREFIX=/opt/avrdude

AVRDUDE_ARGS=""
AVRDUDE_ARGS="${AVRDUDE_ARGS} -v -v -V"
AVRDUDE_ARGS="${AVRDUDE_ARGS} -p atmega328p"
AVRDUDE_ARGS="${AVRDUDE_ARGS} -P /dev/ttyACM0"
AVRDUDE_ARGS="${AVRDUDE_ARGS} -c arduino"
AVRDUDE_ARGS="${AVRDUDE_ARGS} -D"
AVRDUDE_ARGS="${AVRDUDE_ARGS} -U flash:w:${KERNEL_ROMFILE}:i"

printf "%s" "Press RESET on board and press <ENTER>, then release RESET ... "
read answer

"${AVRDUDE_PREFIX}"/bin/avrdude ${AVRDUDE_ARGS}

exit $?

