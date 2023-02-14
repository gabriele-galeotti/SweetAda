#!/usr/bin/env sh

"${FILEPAD}" ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} 512

if [ "x${USE_PYTHON}" = "xY" ] ; then
  "${PYTHON}"                                                 \
    ${KERNEL_PARENT_PATH}/${SHARE_DIRECTORY}/pc-x86-boothd.py \
    ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE}                   \
    0x4000                                                    \
    +pcboothd.dsk
else
  "${TCLSH}"                                                   \
    ${KERNEL_PARENT_PATH}/${SHARE_DIRECTORY}/pc-x86-boothd.tcl \
    ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE}                    \
    0x4000                                                     \
    +pcboothd.dsk
fi

exit 0

