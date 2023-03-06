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
# Main loop.                                                                   #
#                                                                              #
################################################################################

# make the platform directory the CWD so that log files do not end up in the
# top-level directory
cd ${PLATFORM_DIRECTORY}

# FS-UAE executable
FSUAE_EXECUTABLE="/opt/FS-UAE/bin/fs-uae"

"${FSUAE_EXECUTABLE}" \
  fs-uae.conf

exit $?

