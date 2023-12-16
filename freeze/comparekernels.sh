#!/usr/bin/env sh

#
# Compare two SweetAda builds.
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

if [ ! -e .sweetada ] ; then
  printf "%s\n" "${SCRIPT_FILENAME} can only be executed in the SweetAda directory."
  exit 1
fi

TMPDIR=$(VERBOSE= PROBEVARIABLE="TMPDIR" make probevariable 2> /dev/null)
MELD=/usr/bin/meld

exit 0

