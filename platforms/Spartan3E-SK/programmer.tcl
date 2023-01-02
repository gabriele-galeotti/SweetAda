#!/usr/bin/env tclsh

#
# Xilinx EDK - SweetAda integration.
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
# PLATFORM_DIRECTORY
# KERNEL_BASENAME
# ELFTOOL
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

if {[platform_get] ne "unix"} {
    puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
    exit 1
}

set XILINX_PATH       /opt/Xilinx/14.7/ISE_DS
# top-level directory of the project
set PROJECT_PATH      /root/project/hardware/Xilinx_Spartan3E/Spartan3E_SK-MicroBlaze_base_design
set BOOTLOOP_ELF_FILE [file join $XILINX_PATH EDK/sw/lib/microblaze/mb_bootloop.elf]
set SWEETADA_ELF_FILE [file join $::env(SWEETADA_PATH) $::env(KERNEL_BASENAME).elf]
set DEVICE            xc3s500efg320-4

#
# Build download.bit.
#
# hardware-only bitstream is $PROJECT_PATH/implementation/system.bit
# final bitstream is $PROJECT_PATH/implementation/download.bit
#
# NOTE: bitinit does not seem to return an exit error code, so check if
# download.bit is correctly generated (with backup)
#
# NOTE: we use the original download.bit project file (which has an elementary
# bootloop embedded inside), then we download the SweetAda binary file via XMD
#
set DOWNLOAD_BIT [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) download.bit]
set BITINIT_LOG [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) bitinit.log]
if {[file exists $DOWNLOAD_BIT]} {
    file rename -force $DOWNLOAD_BIT $DOWNLOAD_BIT.tmp
}
exec -ignorestderr >@stdout 2>@stderr sh -c "\
source $XILINX_PATH/settings64.sh ;              \
bitinit                                          \
  $PROJECT_PATH/system.mhs                       \
  -bm $PROJECT_PATH/implementation/system_bd.bmm \
  -bt $PROJECT_PATH/implementation/system.bit    \
  -o $DOWNLOAD_BIT                               \
  -pe microblaze_0 $BOOTLOOP_ELF_FILE            \
  -lp $PROJECT_PATH/..                           \
  -log $BITINIT_LOG                              \
  -p $DEVICE                                     \
"
if {[file exists $DOWNLOAD_BIT]} {
    file delete -force $DOWNLOAD_BIT.tmp
} else {
    # bitinit failed
    if {[file exists $DOWNLOAD_BIT.tmp]} {
        file rename -force $DOWNLOAD_BIT.tmp $DOWNLOAD_BIT
    }
    exit 1
}

#
# Create impact.cmd.
#
set IMPACT_CMD [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) impact.cmd]
set IMPACT_LOG [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) impact.log]
set impact_cmd_fd [open $IMPACT_CMD w]
puts $impact_cmd_fd "setLog -file $IMPACT_LOG"
puts $impact_cmd_fd "setMode -bscan"
puts $impact_cmd_fd "setCable -p auto"
puts $impact_cmd_fd "identify"
puts $impact_cmd_fd "assignfile -p 1 -file $DOWNLOAD_BIT"
puts $impact_cmd_fd "program -p 1"
puts $impact_cmd_fd "quit"
close $impact_cmd_fd

#
# Run iMPACT.
#
exec -ignorestderr >@stdout 2>@stderr sh -c "source $XILINX_PATH/settings64.sh ; impact -batch $IMPACT_CMD"

#
# Create xmd.ini.
#
set XMD_INI [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) xmd.ini]
set xmd_ini_fd [open $XMD_INI w]
puts $xmd_ini_fd "connect mb mdm -debugdevice cpunr 1"
# use SweetAda kernel
puts $xmd_ini_fd "dow $SWEETADA_ELF_FILE"
# reset processor
#puts $xmd_ini_fd "rst"
puts $xmd_ini_fd "run"
# do not exit from XMD
#puts $xmd_ini_fd "exit"
close $xmd_ini_fd

#
# Run XMD.
#
exec -ignorestderr >@stdout 2>@stderr sh -c "source $XILINX_PATH/settings64.sh ; xmd -nx -opt $XMD_INI"

exit 0

