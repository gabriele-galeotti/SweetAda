#!/usr/bin/env sh

"${PYTHON}"                                                         \
  ${KERNEL_PARENT_PATH}/${SHARE_DIRECTORY}/adfcreate.py             \
  adfboot ${KERNEL_PARENT_PATH}/kernel.rom 0x80000 0x80400 boot.adf

exit $?

