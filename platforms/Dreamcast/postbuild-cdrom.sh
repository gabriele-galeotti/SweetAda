#!/usr/bin/env sh

if [ "x${USE_PYTHON}" = "xY" ] ; then
  "${PYTHON}" makecdrom.py IP_TMPL IP_TXT "${SWEETADA_PATH}"/${KERNEL_ROMFILE}
else
  "${TCLSH}" makecdrom.tcl IP_TMPL IP_TXT "${SWEETADA_PATH}"/${KERNEL_ROMFILE}
fi

mkisofs -G IP.BIN -J -V SweetAda -l -r -o sweetada.iso 1ST_READ.BIN

exit 0

