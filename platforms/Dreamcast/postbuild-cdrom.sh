#!/usr/bin/env sh

"${PYTHON}" makecdrom.py IP_TMPL IP_TXT "${SWEETADA_PATH}"/${KERNEL_ROMFILE}
#"${TCLSH}" makecdrom.tcl IP_TMPL IP_TXT "${SWEETADA_PATH}"/${KERNEL_ROMFILE}

#mkisofs -G IP.BIN -J -V SweetAda -l -r -o sweetada.iso 1ST_READ.BIN

# -m, --no-mr                 disable the default MR boot image
# -N, --no-padding            specify to disable padding of the data track
# -p, --ipbin                 ip.bin file to use instead of the default one
mkdcdisc \
  --no-mr \
  --no-padding \
  --ipbin "$(pwd)"/IP.BIN \
  -e "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
  -o sweetada.cdi

exit 0

