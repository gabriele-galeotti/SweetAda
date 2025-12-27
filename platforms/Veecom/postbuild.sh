#!/usr/bin/env sh

srec_cat \
  -Output "${SWEETADA_PATH}"/kernel.srec -LOGisim \
  "${SWEETADA_PATH}"/${KERNEL_ROMFILE} -Binary

exit $?

