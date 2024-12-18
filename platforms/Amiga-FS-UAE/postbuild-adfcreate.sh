#!/usr/bin/env sh

"${PYTHON}" adfcreate.py adfboot ${KERNEL_PARENT_PATH}/kernel.rom 0x80000 0x80400 boot.adf
#"${TCLSH}" adfcreate.tcl adfboot ${KERNEL_PARENT_PATH}/kernel.rom 0x80000 0x80400 boot.adf

exit $?

