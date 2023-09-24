#!/usr/bin/env sh

#
# NEORV32 GHDL front-end script.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# PATH
# PLATFORM_DIRECTORY
# KERNEL_OUTFILE
# OBJCOPY
# NEORV32_HOME
# GHDL_PATH
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# as a prerequisite, go into the "<NEORV32_HOME>/sw/example/hello_world"
# directory an do a "make ../../../sw/image_gen/image_gen" to create the
# executable used in translating the Sweetada binary image

# paths and filenames extracted from "<NEORV32_HOME>/sw/common/common.mk"
NEORV32_RTL_PATH="${NEORV32_HOME}"/rtl/core
NEORV32_SIM_PATH="${NEORV32_HOME}"/sim
IMAGE_GEN="${NEORV32_HOME}"/sw/image_gen/image_gen
APP_IMG=neorv32_application_image.vhd

# generate a pure binary image out of .text/.rodata/.data sections
${OBJCOPY}                                     \
  -j .text -j .rodata -j .data                 \
  -I elf32-little ${KERNEL_OUTFILE}            \
  -O binary ${PLATFORM_DIRECTORY}/sweetada.bin
# elaborate a SweetAda VHDL source
cd ${PLATFORM_DIRECTORY}
"${IMAGE_GEN}" -app_img sweetada.bin "${NEORV32_RTL_PATH}"/${APP_IMG}
# run the simulation
PATH=${GHDL_PATH}/bin:${PATH} xterm                \
  -T "NEORV32" -geometry 132x50 -bg blue -fg white \
  -e "${NEORV32_SIM_PATH}"/simple/ghdl.sh          \
  &

exit 0

