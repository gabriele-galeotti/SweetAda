#!/usr/bin/env tclsh

#
# dBUG S-record download.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = KERNEL_SRECFILE
# $2 = SERIALPORT_DEVICE
# $3 = BAUD_RATE
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
if {[llength $argv] < 3} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set kernel_srecfile [lindex $argv 0]
set serialport_device [lindex $argv 1]
set baud_rate [lindex $argv 2]

set serialport_fd [open $serialport_device "r+"]
fconfigure $serialport_fd \
    -blocking 0 \
    -buffering none \
    -eofchar {} \
    -handshake xonxoff \
    -mode $baud_rate,n,8,1 \
    -translation binary
flush $serialport_fd

# download an S19 executable on console port (with echoing)
puts -nonewline $serialport_fd "dl\x0D\x0A"
after 1000

# read kernel file and write to serial port
set kernel_fd [open $kernel_srecfile r]
fconfigure $kernel_fd -buffering line
while {[gets $kernel_fd data] >= 0} {
    puts -nonewline $serialport_fd "$data\x0D\x0A"
    puts -nonewline stderr "."
    # allow processing of data on remote side
    after 30
    set srec_type [string range $data 0 1]
    if {$srec_type eq "S7"} {
        set start_address [string range $data 4 11]
    }
    if {$srec_type eq "S8"} {
        set start_address [string range $data 4 9]
    }
    if {$srec_type eq "S9"} {
        set start_address [string range $data 4 7]
    }
}
# close download of S-record data
puts -nonewline $serialport_fd "\x0D\x0A"
puts stderr ""
close $kernel_fd

# execute
after 1000
puts -nonewline $serialport_fd "go $start_address\x0D\x0A"

close $serialport_fd

exit 0

