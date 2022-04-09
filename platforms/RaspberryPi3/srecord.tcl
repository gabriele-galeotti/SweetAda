#!/usr/bin/env tclsh

#
# Raspberry Pi 3 S-record download.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# KERNEL_SRECFILE
# SERIALPORT_DEVICE
# BAUD_RATE
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

if {[llength $argv] < 3} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set KERNEL_SRECFILE   [lindex $argv 0]
set SERIALPORT_DEVICE [lindex $argv 1]
set BAUD_RATE         [lindex $argv 2]

set serialport_fp [open $SERIALPORT_DEVICE "r+"]
fconfigure $serialport_fp \
    -blocking 0 \
    -buffering none \
    -eofchar {} \
    -mode $BAUD_RATE,n,8,1 \
    -translation binary
flush $serialport_fp

# read kernel file and write to serial port
set kernel_fp [open $KERNEL_SRECFILE r]
fconfigure $kernel_fp -buffering line
while {[gets $kernel_fp data] >= 0} {
    puts -nonewline $serialport_fp "$data\x0D\x0A"
    puts -nonewline stderr "*"
    #puts stderr $data
    # allow processing of data on remote side
    after 50
    set srec_type [string range $data 0 1]
    if {$srec_type eq "S7"} {
        set START_ADDRESS [string range $data 4 11]
    }
    if {$srec_type eq "S8"} {
        set START_ADDRESS [string range $data 4 9]
    }
    if {$srec_type eq "S9"} {
        set START_ADDRESS [string range $data 4 7]
    }
}
# close download of S-record data
puts -nonewline $serialport_fp "\x0D\x0A"
puts stderr ""
close $kernel_fp

close $serialport_fp

exit 0

