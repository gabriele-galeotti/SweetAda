#!/usr/bin/env sh

# create an S-record kernel file for pROBE+ download
${OBJCOPY}                                 \
  -O srec                                  \
  ${SWEETADA_PATH}/${KERNEL_OUTFILE}       \
  ${SWEETADA_PATH}/${KERNEL_BASENAME}.srec

