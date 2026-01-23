#!/usr/bin/env sh

#
# SweetAda GNU/GNAT toolchain build.
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
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

EMBED_SWITCH=

# discard any .py passed by configure as first argument
shift

for s in $@ ; do
  if [ "x${s}" = "x--ldflags" ] ; then
    EMBED_SWITCH="--embed"
    break
  fi
done

exec /usr/bin/python3-config ${EMBED_SWITCH} "$@"

exit 1

