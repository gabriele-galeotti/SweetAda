#!/usr/bin/env sh

"${FILEPAD}" ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} 512

if [ "x${USE_PYTHON}" = "xY" ] ; then
  "${PYTHON}"                                                 \
    ${KERNEL_PARENT_PATH}/${SHARE_DIRECTORY}/pc-x86-bootfd.py \
    ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE}                   \
    0x4000                                                    \
    +pcbootfd.dsk
else
  "${TCLSH}"                                                   \
    ${KERNEL_PARENT_PATH}/${SHARE_DIRECTORY}/pc-x86-bootfd.tcl \
    ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE}                    \
    0x4000                                                     \
    +pcbootfd.dsk
fi

exit 0

