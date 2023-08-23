#!/usr/bin/env tclsh

#
# Intel(R) Quartus SweetAda integration.
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
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# TOOLCHAIN_PROGRAM_PREFIX
# QUARTUS_PATH
# QSYS_PROJECT_PATH
# QSYS_SOF_FILE
# QSYS_JDI_FILE
# KERNEL_OUTFILE
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

set QUARTUS_PATH             $::env(QUARTUS_PATH)
set TOOLCHAIN_PROGRAM_PREFIX $::env(TOOLCHAIN_PROGRAM_PREFIX)
set PROJECT_PATH             $::env(QSYS_PROJECT_PATH)
set SOF_FILE                 $::env(QSYS_SOF_FILE)
set JDI_FILE                 $::env(QSYS_JDI_FILE)
set ELF_FILE                 [file join $::env(SWEETADA_PATH) $::env(KERNEL_OUTFILE)]

# default parameters
set CABLE_NAME "USB-Blaster"
set DEVICE_NO  "1"

if {[platform_get] ne "unix"} {
    puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
    exit 1
}

if {[lindex $argv 0] eq "-jtagd"} {
    exec -ignorestderr >@stdout 2>@stderr [file join $QUARTUS_PATH quartus/bin/jtagd]
    exit 0
}

puts stdout "Running nios2-configure-sof ..."
exec -ignorestderr >@stdout 2>@stderr sh -c "\
cd ${QUARTUS_PATH}/nios2eds && \
./nios2_command_shell.sh       \
nios2-configure-sof            \
  --cable \"${CABLE_NAME}\"    \
  --device ${DEVICE_NO}        \
  ${SOF_FILE}                  \
"

# NOTE: needs nios2-elf-objcopy
puts stdout "Running nios2-download ..."
exec -ignorestderr >@stdout 2>@stderr sh -c "\
cd ${QUARTUS_PATH}/nios2eds &&            \
PATH=${TOOLCHAIN_PROGRAM_PREFIX}:\${PATH} \
./nios2_command_shell.sh                  \
nios2-download                            \
  --cable \"${CABLE_NAME}\"               \
  --device ${DEVICE_NO}                   \
  --jdi ${JDI_FILE}                       \
  --reset-target                          \
  --go                                    \
  ${ELF_FILE}                             \
"

exit 0

