#!/usr/bin/env sh

"${PYTHON}" makecdrom.py IP_TMPL IP_TXT "${SWEETADA_PATH}"/${KERNEL_ROMFILE}
#"${TCLSH}" makecdrom.tcl IP_TMPL IP_TXT "${SWEETADA_PATH}"/${KERNEL_ROMFILE}

mkisofs -G IP.BIN -J -V SweetAda -l -r -o sweetada.iso 1ST_READ.BIN

exit 0

