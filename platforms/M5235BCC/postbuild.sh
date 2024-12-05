#!/usr/bin/env sh

# create an S-record kernel file for dBUG download

${OBJCOPY}                                 \
  -O srec                                  \
  ${SWEETADA_PATH}/${KERNEL_OUTFILE}       \
  ${SWEETADA_PATH}/${KERNEL_BASENAME}.srec
chmod a-x ${SWEETADA_PATH}/${KERNEL_BASENAME}.srec

exit $?

