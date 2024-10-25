#!/usr/bin/env sh

# GNAT Studio executable
GNATSTUDIO=/opt/GNAT/2021/bin/gnatstudio

# detect toolchain from configuration.in
TOOLCHAIN_PREFIX=$(make PROBEVARIABLE=TOOLCHAIN_PREFIX probevariable)
if [ "x${TOOLCHAIN_PREFIX}" = "x" ] ; then
  printf "%s\n" "*** Warning: no TOOLCHAIN_PREFIX detected." 1>&2
fi

# avoid complaints about gnatls
export PATH=${TOOLCHAIN_PREFIX}\bin:${PATH}

"${GNATSTUDIO}" sweetada.gpr &

exit 0

