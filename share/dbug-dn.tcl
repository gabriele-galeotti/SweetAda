#!/usr/bin/env tclsh

#
# ELF download (dBUG download-network version).
#
# Copyright (C) 2020-2026 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -d <serialport_device> serialport device
# -b <baud_rate>         serialport device baud rate
# -e <elftool>           ELFtool executable
# -f <kernel_filename>   ELF executable filename
# -s <entry_point>       ELF executable entry point symbol
#
# Environment variables:
# none
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
# read_response                                                                #
################################################################################
proc read_response {fd} {
    global timeout
    set timeout 0
    set data_buffer {}
    set data_length 0
    set afterid [after 3000 {set timeout 1}]
    while {$timeout == 0} {
        set input [read $fd 1024]
        set input_length [string length $input]
        if {$input_length > 0} {
            after cancel $afterid
            foreach c [split $input ""] {
                switch $c {
                    "\b" {
                        # spinning indicator
                        set c [string range $data_buffer end-1 0]
                        set data_buffer [string range $data_buffer 0 end-1]
                        puts -nonewline $c
                        puts -nonewline "\b"
                        continue
                    }
                    "\n" {
                        puts $data_buffer
                        set data_buffer {}
                    }
                    default {
                        append data_buffer $c
                    }
                }
            }
            set data_length [string length $data_buffer]
            if {$data_length > 5} {
                set string_check [string range $data_buffer \
                    [expr {$data_length - 6}] \
                    [expr {$data_length - 1}] \
                    ]
                if {$string_check eq "dBUG> "} {
                    return "dBUG> "
                }
            }
            set afterid [after 3000 {set timeout 1}]
        }
        after 10
        update
    }
    return $data_buffer
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

set SERIALPORT_DEVICE ""
set BAUD_RATE         "19200"
set SWEETADA_ELF      ""
set ELFTOOL           ""
set START_SYMBOL      "_start"

set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    switch $token {
        -b {incr argv_idx ; set BAUD_RATE [lindex $argv $argv_idx]}
        -d {incr argv_idx ; set SERIALPORT_DEVICE [lindex $argv $argv_idx]}
        -e {incr argv_idx ; set ELFTOOL [lindex $argv $argv_idx]}
        -f {incr argv_idx ; set SWEETADA_ELF [lindex $argv $argv_idx]}
        -s {incr argv_idx ; set START_SYMBOL [lindex $argv $argv_idx]}
        default {
            puts stderr "$SCRIPT_FILENAME: *** Error: unknown argument."
            exit 1
        }
    }
    incr argv_idx
}

if {$SWEETADA_ELF eq ""} {
    puts stderr "$SCRIPT_FILENAME: *** Error: ELF file not specified."
    exit 1
}

if {$ELFTOOL ne ""} {
    if {[catch {exec "$ELFTOOL" -c findsymbol=$START_SYMBOL "$SWEETADA_ELF"} result] eq 0} {
        set START_ADDRESS [format "0x%X" [expr {$result}]]
    } else {
        puts stderr "$SCRIPT_FILENAME: *** Error: system failure or ELFTOOL executable not found."
        exit 1
    }
} else {
    set START_ADDRESS $START_SYMBOL
}

set serialport_fd [open $SERIALPORT_DEVICE {RDWR NONBLOCK}]
chan configure $serialport_fd \
    -blocking false \
    -buffering none \
    -eofchar {} \
    -handshake xonxoff \
    -mode $BAUD_RATE,n,8,1 \
    -translation binary
flush $serialport_fd

# disable stdout buffering
chan configure stdout -buffering none

# check for dBUG readiness
puts $serialport_fd ""
if {[read_response $serialport_fd] ne "dBUG> "} {
    puts stderr "$SCRIPT_FILENAME: *** Error: no dBUG response."
    close $serialport_fd
    chan configure stdout -buffering line
    exit 1
    }

# wait 1 s otherwise dBUG hangs
#after 1000

# download an ELF executable via TFTP
puts $serialport_fd "dn [file tail $SWEETADA_ELF]"
if {[read_response $serialport_fd] ne "dBUG> "} {
    puts stderr "$SCRIPT_FILENAME: *** Error: no dBUG response."
    close $serialport_fd
    chan configure stdout -buffering line
    exit 1
    }

# execute
puts "Executing \"go $START_ADDRESS\""
puts $serialport_fd "go $START_ADDRESS"

close $serialport_fd

chan configure stdout -buffering line

exit 0

