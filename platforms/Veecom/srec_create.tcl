#!/usr/bin/env tclsh

#
# Logisim S-record creation.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = optional output filename
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

set input_filename ""
set output_filename ""

# process arguments
set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    if {$input_filename eq ""} {
        set input_filename $token
    } else {
        if {$output_filename eq ""} {
            set output_filename $token
        }
    }
    incr argv_idx
}

# check parameters
if {$input_filename eq ""} {
    puts stderr "$SCRIPT_FILENAME: *** Error: no input filename supplied."
    exit 1
}
if {$output_filename eq ""} {
    set output_filename "$input_filename.srec"
}

# read the input binary object
set fd_input [open $input_filename r]
fconfigure $fd_input -encoding binary -translation binary
set data [read $fd_input]
close $fd_input

# create the output object
set fd_output [open $output_filename w]
fconfigure $fd_output
puts $fd_output "v2.0 raw"
set count 0
foreach byte [split $data ""] {
    if {$count == 0} {
        puts $fd_output ""
    } else {
        puts -nonewline $fd_output " "
    }
    puts -nonewline $fd_output [format %02X [scan $byte %c]]
    incr count
    if {$count == 32} {
        set count 0
    }
}
puts $fd_output ""
close $fd_output

exit 0

