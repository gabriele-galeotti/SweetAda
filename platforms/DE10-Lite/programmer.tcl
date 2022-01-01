#!/usr/bin/env tclsh

#
# Altera® Quartus - SweetAda integration.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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
# KERNEL_OUTFILE
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

if {[get_platform] ne "unix"} {
    puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
    exit 1
}

set QUARTUS_PATH /opt/altera_lite/16.0
# top-level directory of the project
set PROJECT_PATH /root/project/hardware/Altera_DE10-Lite/DE10-Lite_base_design
set SOF_FILE     [file join $PROJECT_PATH output_files/DE10-Lite.sof]
set ELF_FILE     [file join $::env(SWEETADA_PATH) $::env(KERNEL_OUTFILE)]

if {[lindex $argv 0] eq "-jtagd"} {
    exec -ignorestderr >@stdout 2>@stderr [file join $QUARTUS_PATH quartus/bin/jtagd]
    exit 0
}

exec -ignorestderr >@stdout 2>@stderr sh -c "\
cd $QUARTUS_PATH/nios2eds ; \
./nios2_command_shell.sh    \
nios2-configure-sof         \
  --debug                   \
  --cable \"USB-Blaster\"   \
  --device 1                \
  $SOF_FILE                 \
"

# NOTE: needs nios2-elf-objcopy (copy of nios2-sweetada-elf-objcopy)
# --cpu_name "nios2_gen2_0"
# --instance 0
# --jdi ${JDI}
# --reset-target
exec -ignorestderr >@stdout 2>@stderr sh -c "\
cd $QUARTUS_PATH/nios2eds ;                    \
PATH=$::env(TOOLCHAIN_PROGRAM_PREFIX):\${PATH} \
./nios2_command_shell.sh                       \
nios2-download                                 \
  --debug                                      \
  --cable \"USB-Blaster\"                      \
  --device 1                                   \
  --go                                         \
  $ELF_FILE                                    \
"

exit 0

