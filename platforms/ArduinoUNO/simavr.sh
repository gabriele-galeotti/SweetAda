#!/usr/bin/env sh

#
# simavr front-end script.
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

rm -f *.vcd *.vcd.idx

"${SIMAVR_PREFIX}"/bin/simavr ${SIMAVR_ARGS} "${SWEETADA_PATH}"/${KERNEL_OUTFILE}

exit $?

