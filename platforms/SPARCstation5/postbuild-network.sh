#!/usr/bin/env sh

ELFTOAOUT=/usr/local/bin/elftoaout
TFTP_DIRECTORY=/home/tftpboot
TFTP_FILENAME=C0A80202.SUN4M

# create an AMAGIC (OMAGIC) SPARC a.out executable

${ELFTOAOUT}                           \
  -o ${KERNEL_PARENT_PATH}/kernel.aout \
  ${KERNEL_PARENT_PATH}/kernel.o
chmod a-x ${KERNEL_PARENT_PATH}/kernel.aout

cp -f ${KERNEL_PARENT_PATH}/kernel.aout ${TFTP_DIRECTORY}/${TFTP_FILENAME}

exit 0

