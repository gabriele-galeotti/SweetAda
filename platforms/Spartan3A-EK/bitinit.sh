#!/usr/bin/env sh

cp -f "${SWEETADA_PATH}"/${KERNEL_OUTFILE} /home/public

printf "%s" "Start sweetada.sh in the EDK shell and press <ENTER> when download.bit is available. "
read answer

cp -f /home/public/download.bit "${SWEETADA_PATH}"/${PLATFORM_DIRECTORY}/

#bitinit                                              \
#  "${PROJECT_PATH}"/system.mhs                       \
#  -bm "${PROJECT_PATH}"/implementation/system_bd.bmm \
#  -bt "${PROJECT_PATH}"/implementation/system.bit    \
#  -o ${FPGA_BITSTREAM}                               \
#  -pe microblaze_0 ${SWEETADA_ELF}                   \
#  -log ${BITINIT_LOG}                                \
#  -p ${DEVICE}                                       \

exit 0

