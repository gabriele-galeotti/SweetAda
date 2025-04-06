#!/usr/bin/env sh

#
# Start GNAT Studio.
#

# detect OSTYPE
OSTYPE=$(make PROBEVARIABLE=OSTYPE probevariable)
if [ "x${OSTYPE}" = "x" ] ; then
  printf "%s\n" "*** Warning: no OSTYPE detected." 1>&2
else
  export OSTYPE
fi

# GNAT Studio prefix and executable
case ${OSTYPE} in
  msys)
    GNATSTUDIO_PREFIX="C:/Program Files"/GNATSTUDIO
    GNATSTUDIO_FILENAME=gnatstudio.exe
    ;;
  *)
    GNATSTUDIO_PREFIX=/opt/GNAT/2021
    GNATSTUDIO_FILENAME=gnatstudio
    ;;
esac
export GNATSTUDIO_PREFIX
GNATSTUDIO="${GNATSTUDIO_PREFIX}"/bin/${GNATSTUDIO_FILENAME}

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

"${GNATSTUDIO}" \
  --pwd="$(pwd)" \
  --path="${TOOLCHAIN_PREFIX}"/bin \
  ${CGPR_OPTION} \
  -P sweetada.gpr \
  &

exit 0

