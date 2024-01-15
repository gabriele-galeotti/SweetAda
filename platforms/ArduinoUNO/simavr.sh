#!/usr/bin/env sh

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

SIMAVR_EXEC=${SIMAVR_PREFIX}/bin/simavr
SIMAVR_ARGS=()
SIMAVR_ARGS+=("-v" "-v" "-v")
SIMAVR_ARGS+=("-m" "atmega328p")
SIMAVR_ARGS+=("${SWEETADA_PATH}/${KERNEL_OUTFILE}")

rm -f *.vcd *.vcd.idx

"${SIMAVR_EXEC}" "${SIMAVR_ARGS[@]}"

exit $?

