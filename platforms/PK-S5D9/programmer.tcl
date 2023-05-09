#!/usr/bin/env tclsh

#
# SweetAda OpenOCD code download.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -c <OPENOCD_CFGFILE> OpenOCD configuration filename
# -debug               enable debug mode
# -e <ELFTOOL>         ELFTOOL executable to extract the start symbol
# -f <SWEETADA_ELF>    ELF executable to download via JTAG
# -p <OPENOCD_PREFIX>  OpenOCD installation prefix
# -s <START_SYMBOL>    start symbol ("_start") or start address if -e option not present
# -server              start OpenOCD server
# -shutdown            shutdown OpenOCD server
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
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
source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) libopenocd.tcl]

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

set PLATFORM [platform_get]

set OPENOCD_PREFIX  ""
set OPENOCD_CFGFILE ""
set DEBUG_MODE      0
set SERVER_MODE     0
set SHUTDOWN_MODE   0
set SWEETADA_ELF    ""
set ELFTOOL         ""
set START_SYMBOL    ""

set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    switch $token {
        -c        {incr argv_idx ; set OPENOCD_CFGFILE [lindex $argv $argv_idx]}
        -debug    {set DEBUG_MODE 1}
        -e        {incr argv_idx ; set ELFTOOL [lindex $argv $argv_idx]}
        -f        {incr argv_idx ; set SWEETADA_ELF [lindex $argv $argv_idx]}
        -p        {incr argv_idx ; set OPENOCD_PREFIX [lindex $argv $argv_idx]}
        -s        {incr argv_idx ; set START_SYMBOL [lindex $argv $argv_idx]}
        -server   {set SERVER_MODE 1}
        -shutdown {set SHUTDOWN_MODE 1}
        default {
            puts stderr "$SCRIPT_FILENAME: *** Error: unknown argument."
            exit 1
        }
    }
    incr argv_idx
}

if {$SHUTDOWN_MODE ne 0} {
    set SERVER_MODE 0
}

if {$SERVER_MODE ne 0} {
    if {$OPENOCD_PREFIX eq ""} {
        puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
        exit 1
    }
    if {$PLATFORM eq "windows"} {
        set OPENOCD_EXECUTABLE [file join $OPENOCD_PREFIX bin openocd.exe]
        exec cmd.exe /C START "" "$OPENOCD_EXECUTABLE" -f "$OPENOCD_CFGFILE" &
    } elseif {$PLATFORM eq "unix"} {
        set OPENOCD_EXECUTABLE [file join $OPENOCD_PREFIX bin openocd]
        # __FIX__
        # if this script is called from Makefile, and the output is redirected
        # on a tee pipe (menu-dialog.sh), then the script hangs because tee
        # seems to wait on an inherited stdout file descriptor, which is kept
        # opened by the xterm sub-process; have we to re-open it?
        close stdout
        exec xterm -e "$OPENOCD_EXECUTABLE" -f "$OPENOCD_CFGFILE" &
    } else {
        puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
        exit 1
    }
    exit 0
}

# local OpenOCD server
openocd_rpc_init 127.0.0.1 6666

if {$SHUTDOWN_MODE ne 0} {
    openocd_rpc_tx "shutdown"
    openocd_rpc_disconnect
    exit 0
}

if {$SWEETADA_ELF eq ""} {
    puts stderr "$SCRIPT_FILENAME: *** Error: ELF file not specified."
    openocd_rpc_disconnect
    exit 1
}

if {$START_SYMBOL eq ""} {
    puts stderr "$SCRIPT_FILENAME: *** Error: START symbol not specified."
    openocd_rpc_disconnect
    exit 1
}

if {$ELFTOOL ne ""} {
    if {[catch {exec $ELFTOOL -c findsymbol=$START_SYMBOL $SWEETADA_ELF} result] eq 0} {
        # ARM Thumb functions have LSB = 1
        set START_ADDRESS [format "0x%08X" [expr $result & 0xFFFFFFFE]]
    } else {
        puts stderr "$SCRIPT_FILENAME: *** Error: $ELFTOOL error."
        openocd_rpc_disconnect
        exit 1
    }
} else {
    set START_ADDRESS $START_SYMBOL
}
puts "START ADDRESS = $START_ADDRESS"

openocd_rpc_tx "reset halt"
openocd_rpc_rx
after 1000
openocd_rpc_tx "load_image $SWEETADA_ELF"
openocd_rpc_rx
openocd_rpc_tx "resume $START_ADDRESS"
openocd_rpc_rx

openocd_rpc_disconnect

exit 0

