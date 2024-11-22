#!/usr/bin/env tclsh

#
# SweetAda OpenOCD manager.
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
# -debug                  debug mode (implies -noexec)
# -e <ELFTOOL>            ELFTOOL executable used to extract the start symbol
# -f <SWEETADA_ELF>       ELF executable to be downloaded via JTAG
# -noexec                 do not run target CPU
# -noload                 do not download executable to target memory
# -p <OPENOCD_PREFIX>     OpenOCD installation prefix
# -s <START_SYMBOL>       start symbol ("_start") or start address if -e option is not present
# -server                 start OpenOCD server (no executable processing)
# -shutdown               shutdown OpenOCD server (no executable processing)
# -thumb                  ARM Thumb address handling
#
# The following hold inside OpenOCD command execution:
# -debug sets $debug_mode and $noexec_flag to 1 (default 0)
# -f <SWEETADA_ELF> sets $sweetada_elf to <SWEETADA_ELF> (default "")
# -noexec sets $noexec_flag to 1 (default 0)
# -noload sets $noload_flag to 1 (default 0)
# $start_address resolves to the detected start address of the executable
#
# Environment variables:
# OSTYPE
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# SHARE_DIRECTORY
# TEMP
# TERMINAL
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
set NOEXEC_FLAG     0
set NOLOAD_FLAG     0
set SERVER_MODE     0
set SHUTDOWN_MODE   0
set SWEETADA_ELF    ""
set ELFTOOL         ""
set START_SYMBOL    ""
set ARM_THUMB       0

set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    switch $token {
        -c           {incr argv_idx ; set OPENOCD_CFGFILE [lindex $argv $argv_idx]}
        -commandfile {incr argv_idx ; set COMMAND_FILE [lindex $argv $argv_idx]}
        -command     {incr argv_idx ; set COMMAND_LIST [lindex $argv $argv_idx]}
        -debug       {set DEBUG_MODE 1 ; set NOEXEC_FLAG 1}
        -e           {incr argv_idx ; set ELFTOOL [lindex $argv $argv_idx]}
        -f           {incr argv_idx ; set SWEETADA_ELF [lindex $argv $argv_idx]}
        -noexec      {set NOEXEC_FLAG 1}
        -noload      {set NOLOAD_FLAG 1}
        -p           {incr argv_idx ; set OPENOCD_PREFIX [lindex $argv $argv_idx]}
        -s           {incr argv_idx ; set START_SYMBOL [lindex $argv $argv_idx]}
        -server      {set SERVER_MODE 1}
        -shutdown    {set SHUTDOWN_MODE 1}
        -thumb       {set ARM_THUMB 1}
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

# cmd.exe file helper
if {$PLATFORM eq "windows"} {
    set TEMP [file nativename $::env(TEMP)]
    set helperfilename [file join $TEMP openocd-tcl.bat]
}

if {$SERVER_MODE ne 0} {
    if {$OPENOCD_PREFIX eq ""} {
        puts stderr "$SCRIPT_FILENAME: *** Error: no OpenOCD prefix specified."
        exit 1
    }
    if {$PLATFORM eq "windows"} {
        set ::env(PATH) [join [list [file join $OPENOCD_PREFIX bin] $::env(PATH)] ";"]
        set fd [open $helperfilename "w"]
        set batch_cmds ""
        append batch_cmds "@ECHO OFF\n"
        append batch_cmds "SET \"PATH=$OPENOCD_PREFIX\\bin;%PATH%\"\n"
        append batch_cmds "openocd.exe -f \"$OPENOCD_CFGFILE\"\n"
        append batch_cmds "IF NOT \"%ERRORLEVEL%\" == \"0\" PAUSE\n"
        puts -nonewline $fd $batch_cmds
        close $fd
        if {[catch {exec $::env(ComSpec) /C START "OpenOCD " $::env(ComSpec) /C $helperfilename &} result] ne 0} {
            puts stderr "$SCRIPT_FILENAME: *** Error: system failure or OpenOCD executable not found."
            file delete -force $helperfilename
            exit 1
        }
    } elseif {$PLATFORM eq "unix"} {
        if {$OSTYPE eq "darwin"} {
            set OPENOCD_EXECUTABLE "$OPENOCD_PREFIX/bin/openocd"
            set osascript_cmds ""
            append osascript_cmds "tell application \"Terminal\"\ndo script \""
            append osascript_cmds "clear"                                                      " ; "
            append osascript_cmds "\\\"$OPENOCD_EXECUTABLE\\\" -f \\\"$OPENOCD_CFGFILE\\\""    " ; "
            append osascript_cmds "if \[ \$? -ne 0 \] ; then"                                    " "
            append osascript_cmds "  printf \\\"%s\\\" \\\"Press any key to continue ... \\\"" " ; "
            append osascript_cmds "  read answer"                                              " ; "
            append osascript_cmds "fi"                                                         " ; "
            append osascript_cmds "exit 0"
            append osascript_cmds "\"\nend tell\n"
            if {[catch {exec osascript -e $osascript_cmds > /dev/null} result] ne 0} {
                puts stderr "$SCRIPT_FILENAME: *** Error: system failure or OpenOCD executable not found."
                exit 1
            }
        } else {
            set ::env(PATH) [join [list [file join $OPENOCD_PREFIX bin] $::env(PATH)] ":"]
            set sh_cmds ""
            append sh_cmds ". [file join $::env(SHARE_DIRECTORY) terminal.sh]"     " ; "
            append sh_cmds "\$(terminal $::env(TERMINAL)) /bin/sh -c \""                  " "
            append sh_cmds "openocd -f \\\"$OPENOCD_CFGFILE\\\""                        " ; "
            append sh_cmds "if \[ \\\$? -ne 0 \] ; then"                                  " "
            append sh_cmds "  printf \\\"%s\\\" \\\"Press any key to continue ... \\\"" " ; "
            append sh_cmds "  read answer"                                              " ; "
            append sh_cmds "fi"                                                         " ; "
            append sh_cmds "exit 0"
            append sh_cmds "\""
            if {[catch {exec /bin/sh -c $sh_cmds &} result] ne 0} {
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
    if {$PLATFORM eq "windows"} {
        file delete -force $helperfilename
    }
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
    if {[catch {exec "$ELFTOOL" -c findsymbol=$START_SYMBOL "$SWEETADA_ELF"} result] eq 0} {
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

openocd_rpc_tx "set sweetada_elf \"$SWEETADA_ELF\" ; list"
openocd_rpc_rx
openocd_rpc_tx "set start_address $START_ADDRESS ; list"
openocd_rpc_rx
openocd_rpc_tx "set debug_mode $DEBUG_MODE ; list"
openocd_rpc_rx
openocd_rpc_tx "set noload_flag $NOLOAD_FLAG ; list"
openocd_rpc_rx
openocd_rpc_tx "set noexec_flag $NOEXEC_FLAG ; list"
openocd_rpc_rx

if {$COMMAND_FILE ne ""} {
    openocd_rpc_tx "source \"$COMMAND_FILE\""
    openocd_rpc_rx
}

foreach command [split $COMMAND_LIST ";"] {
    openocd_rpc_tx $command
    openocd_rpc_rx
}

if {$NOLOAD_FLAG eq 0} {
    openocd_rpc_tx "load_image \"$SWEETADA_ELF\""
    openocd_rpc_rx
}

if {$NOEXEC_FLAG eq 0} {
    openocd_rpc_tx "resume $START_ADDRESS"
    openocd_rpc_rx
}

openocd_rpc_disconnect

if {$PLATFORM eq "windows"} {
    puts ""
}

exit 0

