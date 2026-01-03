#!/usr/bin/env sh

# use the S-Record utility
#srec_cat \
#  -Output "${SWEETADA_PATH}"/kernel.srec -LOGisim \
#  "${SWEETADA_PATH}"/${KERNEL_ROMFILE} -Binary

#"${TCLSH}" srec_create.tcl \
#  "${SWEETADA_PATH}"/${KERNEL_ROMFILE} \
#  "${SWEETADA_PATH}"/${KERNEL_BASENAME}.srec

"${PYTHON}" srec_create.py \
  "${SWEETADA_PATH}"/${KERNEL_ROMFILE} \
  "${SWEETADA_PATH}"/${KERNEL_BASENAME}.srec

exit $?

