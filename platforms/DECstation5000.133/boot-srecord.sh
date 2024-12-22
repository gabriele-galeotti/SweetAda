#!/usr/bin/env sh

${OBJCOPY}                                 \
  -O srec                                  \
  ${SWEETADA_PATH}/${KERNEL_OUTFILE}       \
  ${SWEETADA_PATH}/${KERNEL_BASENAME}.srec
chmod a-x ${SWEETADA_PATH}/${KERNEL_BASENAME}.srec

exit 0

