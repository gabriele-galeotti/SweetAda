#!/usr/bin/env sh

# load terminal handling
source ${SHARE_DIRECTORY}/terminal.sh

$(terminal ${TERMINAL}) ${GDB} \
  -q \
  -ex "target extended-remote localhost:3333" \
  -ex "set language asm" \
  -ex "set \$pc=_start" \
  ${KERNEL_OUTFILE}

exit 0

