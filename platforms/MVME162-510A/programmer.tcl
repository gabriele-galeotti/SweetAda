#!/usr/bin/env tclsh

#
# MVME 162-510A S-record download.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# SERIALPORT_DEVICE
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# PLATFORM_DIRECTORY
# KERNEL_BASENAME
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

set BAUD_RATE 19200

if {[llength $argv] < 1} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set KERNEL_SRECFILE   [file join $::env(SWEETADA_PATH) $::env(KERNEL_BASENAME).srec]
set SERIALPORT_DEVICE [lindex $argv 0]

set serialport_fd [open $SERIALPORT_DEVICE "r+"]
fconfigure $serialport_fd \
    -blocking 0 \
    -buffering none \
    -eofchar {} \
    -mode $BAUD_RATE,n,8,1 \
    -translation binary
flush $serialport_fd
set sp_data [read $serialport_fd 256]

# download an S19 executable on console port (with echoing)
puts -nonewline $serialport_fd "LO 0;X\x0D\x0A"
after 1000

# read kernel file and write to serial port
set kernel_fd [open $KERNEL_SRECFILE r]
fconfigure $kernel_fd -buffering line
while {[gets $kernel_fd data] >= 0} {
    puts -nonewline $serialport_fd "$data\x0D\x0A"
    puts -nonewline stderr "*"
    #puts stderr $data
    # allow processing of data on remote side
    after 30
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
puts -nonewline $serialport_fd "\x0D\x0A"
puts stderr ""
close $kernel_fd

# execute
after 30
puts -nonewline $serialport_fd "GO $START_ADDRESS\x0D\x0A"

close $serialport_fd

exit 0

