#!/usr/bin/env sh

bitinit                                            \
  ${PROJECT_PATH}/system.mhs                       \
  -bm ${PROJECT_PATH}/implementation/system_bd.bmm \
  -bt ${PROJECT_PATH}/implementation/system.bit    \
  -o ${FPGA_BITSTREAM}                             \
  -pe microblaze_0 ${SWEETADA_ELF}                 \
  -log ${BITINIT_LOG}                              \
  -p ${DEVICE}                                     \

exit 0

