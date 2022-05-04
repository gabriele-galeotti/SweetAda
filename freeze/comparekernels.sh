#!/bin/sh

#
# Compare two SweetAda builds.
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set -o posix
SCRIPT_FILENAME=$(basename "$0")

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

if [ ! -e .sweetada ] ; then
  echo "${SCRIPT_FILENAME} can only be executed in the SweetAda directory."
  exit 1
fi

TMPDIR=$(VERBOSE= PROBEVARIABLE="TMPDIR" make -s probevariable 2> /dev/null)
MELD=/usr/bin/meld

exit 0

