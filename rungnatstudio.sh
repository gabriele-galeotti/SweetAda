#!/usr/bin/env sh

#
# Start GNAT Studio.
#

# GNAT Studio prefix and executable
GNATSTUDIO_PREFIX=/opt/GNAT/2021
export GNATSTUDIO_PREFIX
GNATSTUDIO="${GNATSTUDIO_PREFIX}"/bin/gnatstudio

# detect toolchain from configuration.in
TOOLCHAIN_PREFIX=$(make PROBEVARIABLE=TOOLCHAIN_PREFIX probevariable)
if [ "x${TOOLCHAIN_PREFIX}" = "x" ] ; then
  printf "%s\n" "*** Warning: no TOOLCHAIN_PREFIX detected." 1>&2
fi

#
# The "--autoconf" option will generate a suitable auto.cgpr file if the
# gprconfig executable is present, then a --config=<cgpr_filename> could be
# used in the command line.
#
CGPR_OPTION=
#CGPR_OPTION="--config=auto.cgpr"
#CGPR_OPTION="--config=..."

"${GNATSTUDIO}"                    \
  --pwd="$(pwd)"                   \
  --path="${TOOLCHAIN_PREFIX}"/bin \
  ${CGPR_OPTION}                   \
  -P sweetada.gpr                  \
  &

exit 0

