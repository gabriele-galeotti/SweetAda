#!/usr/bin/env sh

"${PYTHON}" adfcreate.py adfboot ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} 0x80000 0x80400 boot.adf
#"${TCLSH}" adfcreate.tcl adfboot ${KERNEL_PARENT_PATH}/${KERNEL_ROMFILE} 0x80000 0x80400 boot.adf

exit $?

