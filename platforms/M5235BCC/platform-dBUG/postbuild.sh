#!/usr/bin/env sh

TFTP_DIRECTORY=/home/tftp

${OBJCOPY}                             \
  --strip-all                          \
  -j .vectors -j .text -j .data        \
  -O elf32-m68k                        \
  "${SWEETADA_PATH}"/${KERNEL_OUTFILE} \
  "${TFTP_DIRECTORY}"/kernel.o

exit $?

