#!/usr/bin/env sh

${GDB} \
  -q \
  -ex "target extended-remote localhost:3333" \
  -ex "set language asm" \
  -ex "set \$pc=_start" \
  ${KERNEL_OUTFILE}

exit 0

