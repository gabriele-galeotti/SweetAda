#!/usr/bin/env tclsh

#
# S-record download.
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
    -mode $baud_rate,n,8,1 \
    -translation binary
flush $serialport_fd

# delay for processing of data on remote side
switch $baud_rate {
    "115200" {set delay 10}
    "57600"  {set delay 20}
    "38400"  {set delay 30}
    default  {set delay 50}
}

# read kernel file and write to the serial port
set kernel_fd [open $kernel_srecfile r]
fconfigure $kernel_fd -buffering line
fconfigure stdout -buffering none
puts -nonewline stdout "sending "
while {[gets $kernel_fd data] >= 0} {
    puts -nonewline $serialport_fd "$data\x0D\x0A"
    puts -nonewline stdout "."
    after $delay
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
puts -nonewline $serialport_fd "\x0D\x0A"
puts stdout ""
fconfigure stdout -buffering line
close $kernel_fd

close $serialport_fd

exit 0

