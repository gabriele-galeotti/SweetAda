#!/usr/bin/env sh

#
# Start Kate.
#

# Ada Language Server executable installation path
ALS_PATH=/opt/integration/vscode/ada/x64/linux

# detect toolchain from configuration.in
TOOLCHAIN_PREFIX=$(VERBOSE= make PROBEVARIABLE=TOOLCHAIN_PREFIX probevariable 2> /dev/null)
if [ "x${TOOLCHAIN_PREFIX}" = "x" ] ; then
  printf "%s\n" "*** Warning: no TOOLCHAIN_PREFIX detected." 1>&2
else
  export PATH=${ALS_PATH}:${TOOLCHAIN_PREFIX}/bin:${PATH}
fi

kate

exit 0

