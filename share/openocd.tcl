#!/usr/bin/env tclsh

#
# SweetAda OpenOCD code download.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -c <OPENOCD_CFGFILE>    OpenOCD configuration filename
# -commandfile <filename> source a Tcl OpenOCD command file
# -command <list>         semicolon-separated list of OpenOCD commands
# -debug                  enable debug mode (no autorun)
# -e <ELFTOOL>            ELFTOOL executable used to extract the start symbol
# -f <SWEETADA_ELF>       ELF executable to be downloaded via JTAG
# -p <OPENOCD_PREFIX>     OpenOCD installation prefix
# -s <START_SYMBOL>       start symbol ("_start") or start address if -e option not present
# -server                 start OpenOCD server
# -shutdown               shutdown OpenOCD server
# -thumb                  ARM Thumb address handling
# -w                      wait after OpenOCD termination
#
# Environment variables:
# OSTYPE
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

set OSTYPE $::env(OSTYPE)
set PLATFORM [platform_get]

set OPENOCD_PREFIX  ""
set OPENOCD_CFGFILE ""
set COMMAND_FILE    ""
set COMMAND_LIST    ""
set DEBUG_MODE      0
set SERVER_MODE     0
set SHUTDOWN_MODE   0
set SWEETADA_ELF    ""
set ELFTOOL         ""
set START_SYMBOL    ""
set ARM_THUMB       0
set WAIT_FLAG       0

set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    switch $token {
        -c           {incr argv_idx ; set OPENOCD_CFGFILE [lindex $argv $argv_idx]}
        -commandfile {incr argv_idx ; set COMMAND_FILE [lindex $argv $argv_idx]}
        -command     {incr argv_idx ; set COMMAND_LIST [lindex $argv $argv_idx]}
        -debug       {set DEBUG_MODE 1}
        -e           {incr argv_idx ; set ELFTOOL [lindex $argv $argv_idx]}
        -f           {incr argv_idx ; set SWEETADA_ELF [lindex $argv $argv_idx]}
        -p           {incr argv_idx ; set OPENOCD_PREFIX [lindex $argv $argv_idx]}
        -s           {incr argv_idx ; set START_SYMBOL [lindex $argv $argv_idx]}
        -server      {set SERVER_MODE 1}
        -shutdown    {set SHUTDOWN_MODE 1}
        -thumb       {set ARM_THUMB 1}
        -w           {set WAIT_FLAG 1}
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
        puts stderr "$SCRIPT_FILENAME: *** Error: no OpenOCD prefix specified."
        exit 1
    }
    if {$PLATFORM eq "windows"} {
        set ::env(PATH) [join [list [file join $OPENOCD_PREFIX bin] $::env(PATH)] ";"]
        set cmd_args ""
        if {$WAIT_FLAG ne 0} {
            append cmd_args "/K "
        } else {
            append cmd_args "/C "
        }
        append cmd_args "openocd.exe -f \"$OPENOCD_CFGFILE\""
        if {[catch {eval exec {$::env(ComSpec)} /C START {$::env(ComSpec)} $cmd_args &} result] ne 0} {
            puts stderr "$SCRIPT_FILENAME: *** Error: system failure or OpenOCD executable not found."
            exit 1
        }
    } elseif {$PLATFORM eq "unix"} {
        set ::env(PATH) [join [list [file join $OPENOCD_PREFIX bin] $::env(PATH)] ":"]
        if {$OSTYPE eq "darwin"} {
            set osascript_args ""
            append osascript_args " -e \"tell application \\\"Terminal\\\"\""
            append osascript_args " -e \"do script \\\"openocd -f \\\\\\\"$OPENOCD_CFGFILE\\\\\\\""
            if {$WAIT_FLAG eq 0} {
                append osascript_args " ; exit"
            }
            append osascript_args "\\\"\""
            append osascript_args " -e \"end tell\""
            if {[catch {eval exec /usr/bin/osascript $osascript_args &} result] ne 0} {
                puts stderr "$SCRIPT_FILENAME: *** Error: system failure or OpenOCD executable not found."
                exit 1
            }
        } else {
            # __FIX__
            # if this script is called from Makefile, and the output is redirected
            # on a tee pipe (menu-dialog.sh), then the script hangs because tee
            # seems to wait on an inherited stdout file descriptor, which is kept
            # opened by the xterm sub-process; have we to re-open it?
            close stdout
            set xterm_args ""
            if {$WAIT_FLAG ne 0} {
                append xterm_args "-hold "
            }
            append xterm_args "-e "
            append xterm_args "openocd -f \"$OPENOCD_CFGFILE\""
            if {[catch {eval exec xterm $xterm_args &} result] ne 0} {
                puts stderr "$SCRIPT_FILENAME: *** Error: system failure or OpenOCD executable not found."
                exit 1
            }
        }
    } else {
        puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
        exit 1
    }
    exit 0
}

# local OpenOCD server
if {[catch {openocd_rpc_init 127.0.0.1 6666} result] ne 0} {
    puts stderr "$SCRIPT_FILENAME: *** Error: no connection to OpenOCD server."
    exit 1
}

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
    if {[catch {eval exec "\"$ELFTOOL\"" -c findsymbol=$START_SYMBOL "\"$SWEETADA_ELF\""} result] eq 0} {
        set START_ADDRESS [format "0x%X" [expr $result]]
        if {$ARM_THUMB ne 0} {
            # ARM Thumb functions have LSb = 1
            set START_ADDRESS [format "0x%X" [expr $START_ADDRESS & 0xFFFFFFFE]]
        }
    } else {
        puts stderr "$SCRIPT_FILENAME: *** Error: system failure or ELFTOOL executable not found."
        openocd_rpc_disconnect
        exit 1
    }
} else {
    set START_ADDRESS $START_SYMBOL
}
puts "START ADDRESS = $START_ADDRESS"

openocd_rpc_tx "set start_address $START_ADDRESS ; list"
openocd_rpc_rx

if {$COMMAND_FILE ne ""} {
    openocd_rpc_tx "source \"$COMMAND_FILE\""
    openocd_rpc_rx
}

foreach command [split $COMMAND_LIST ";"] {
    openocd_rpc_tx $command
    openocd_rpc_rx
}

openocd_rpc_tx "load_image \"$SWEETADA_ELF\""
openocd_rpc_rx

if {$DEBUG_MODE eq 0} {
    openocd_rpc_tx "resume $START_ADDRESS"
    openocd_rpc_rx
}

openocd_rpc_disconnect

if {$PLATFORM eq "windows"} {
    puts ""
}

exit 0

