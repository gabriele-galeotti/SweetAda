#!/usr/bin/env sh

# kernel file must have .elf extension
cp -f ${KERNEL_PARENT_PATH}/${KERNEL_OUTFILE} ${KERNEL_PARENT_PATH}/${KERNEL_BASENAME}.elf

exit $?

