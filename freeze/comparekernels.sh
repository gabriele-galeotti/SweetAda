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

SWEETADA_1=$(VERBOSE= PROBEVARIABLE="OBJECT_DIRECTORY" make -s probevariable 2> /dev/null)
SWEETADA_2=$(VERBOSE= PROBEVARIABLE="FREEZE_DIRECTORY" make -s probevariable 2> /dev/null)

TOOLCHAIN_PREFIX=$(VERBOSE= PROBEVARIABLE="TOOLCHAIN_PREFIX" make -s probevariable 2> /dev/null)
NM=$(VERBOSE= PROBEVARIABLE="NM" make -s probevariable 2> /dev/null)
OBJDUMP=$(VERBOSE= PROBEVARIABLE="OBJDUMP" make -s probevariable 2> /dev/null)
READELF=$(VERBOSE= PROBEVARIABLE="READELF" make -s probevariable 2> /dev/null)

MELD=/usr/bin/meld

# example: libcore
#${TOOLCHAIN_PREFIX}/bin/${NM} ${SWEETADA_1}/libcore.a > ${TMPDIR}/libcore-new.txt
#${TOOLCHAIN_PREFIX}/bin/${NM} ${SWEETADA_2}/libcore.a > ${TMPDIR}/libcore-old.txt
#${MELD} ${TMPDIR}/libcore-new.txt ${TMPDIR}/libcore-old.txt
#rm -f ${TMPDIR}/libcore-new.txt ${TMPDIR}/libcore-old.txt

# example: core alis
#${MELD} ${SWEETADA_1}/bits.ali ${SWEETADA_2}/bits.ali
#${MELD} ${SWEETADA_1}/integer_math.ali ${SWEETADA_2}/integer_math.ali
#${MELD} ${SWEETADA_1}/malloc.ali ${SWEETADA_2}/malloc.ali
#${MELD} ${SWEETADA_1}/memory_functions.ali ${SWEETADA_2}/memory_functions.ali

# example: uart16x50.o
#${TOOLCHAIN_PREFIX}/bin/${OBJDUMP} -dx ${SWEETADA_1}/uart16x50.o > ${TMPDIR}/uart16x50-new.txt
#${TOOLCHAIN_PREFIX}/bin/${OBJDUMP} -dx ${SWEETADA_2}/uart16x50.o > ${TMPDIR}/uart16x50-old.txt
#${MELD} ${TMPDIR}/uart16x50-new.txt ${TMPDIR}/uart16x50-old.txt
#rm -f ${TMPDIR}/uart16x50-new.txt ${TMPDIR}/uart16x50-old.txt

exit 0

