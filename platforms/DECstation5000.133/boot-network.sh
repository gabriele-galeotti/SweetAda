#!/usr/bin/env sh

TFTP_DIRECTORY=/home/public
TFTP_FILENAME=08002b32bd8f.SYS

cp -f ${KERNEL_PARENT_PATH}/kernel.o ${TFTP_DIRECTORY}/${TFTP_FILENAME}

exit 0

