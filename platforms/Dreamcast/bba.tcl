#!/usr/bin/env tclsh

#
# Download and run a SweetAda executable through a Dreamcast BBA adapter.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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
# ELFTOOL
# KERNEL_OUTFILE
# KERNEL_ROMFILE
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
#                                                                              #
################################################################################

# communication takes place on a UDP socket
package require udp

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

################################################################################
# send_command                                                                 #
#                                                                              #
################################################################################
proc send_command {s command address size data} {
    set buffer ""
    append buffer $command
    foreach byte [u32_to_bebytes $address] {
        append buffer [binary format c1 $byte]
    }
    foreach byte [u32_to_bebytes $size] {
        append buffer [binary format c1 $byte]
    }
    if {[string length $data] ne 0} {
        append buffer $data
    }
    #puts "sending [string length $buffer] bytes"
    puts -nonewline $s $buffer
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

set ELFTOOL              $::env(ELFTOOL)
set KERNEL_OUTFILE       [file join $::env(SWEETADA_PATH) $::env(KERNEL_OUTFILE)]
set KERNEL_ROMFILE       [file join $::env(SWEETADA_PATH) $::env(KERNEL_ROMFILE)]
set START_SYMBOL         _start
set HOST_IP_ADDRESS      192.168.2.1
set DREAMCAST_IP_ADDRESS 192.168.2.2
set DREAMCAST_UDP_PORT   31313
set BBA_MAC_ADDRESS      00:d0:f1:02:bc:5d

set CMD_EXECUTE  "EXEC" ;# execute
set CMD_LOADBIN  "LBIN" ;# begin receiving binary
set CMD_PARTBIN  "PBIN" ;# part of a binary
set CMD_DONEBIN  "DBIN" ;# end receiving binary
set CMD_SENDBIN  "SBIN" ;# send a binary
set CMD_SENDBINQ "SBIQ" ;# send a binary, quiet
set CMD_VERSION  "VERS" ;# send version info
set CMD_RETVAL   "RETV" ;# return value
set CMD_REBOOT   "RBOT" ;# reboot

# load address
if {[catch {exec $ELFTOOL -c sectionvaddr=.text $KERNEL_OUTFILE} result] eq 0} {
    set START_ADDRESS [format "0x%08X" $result]
} else {
    puts stderr "$SCRIPT_FILENAME: *** Error: no $KERNEL_OUTFILE file available or no section \".text\"."
    exit 1
}

# start address
if {[catch {exec $ELFTOOL -c findsymbol=$START_SYMBOL $KERNEL_OUTFILE} result] eq 0} {
    set START_ADDRESS [format "0x%08X" $result]
} else {
    puts stderr "$SCRIPT_FILENAME: *** Error: no $KERNEL_OUTFILE file available or no symbol \"$START_SYMBOL\"."
    exit 1
}

# setup network connection
if {[catch {exec >@stdout 2>@stderr ifconfig -v eth0 $HOST_IP_ADDRESS} result] ne 0} {
    puts stderr "$SCRIPT_FILENAME: *** Error: ifconfig failed."
    exit 1
}
if {[catch {exec >@stdout 2>@stderr arp -s $DREAMCAST_IP_ADDRESS $BBA_MAC_ADDRESS} result] ne 0} {
    puts stderr "$SCRIPT_FILENAME: *** Error: arp failed."
    exit 1
}

# create UDP socket
set s [udp_open]
chan configure $s -remote [list $DREAMCAST_IP_ADDRESS $DREAMCAST_UDP_PORT]
chan configure $s -buffering none -encoding binary -eofchar {}

# open the binary file
set fd_input [open $KERNEL_ROMFILE r]
fconfigure $fd_input -encoding binary -translation binary

# upload a binary file
send_command $s $CMD_LOADBIN $LOAD_ADDRESS [file size $KERNEL_ROMFILE] ""
set recv_data [read $s 4096]
if {[eof $s]} {
    puts stderr "$SCRIPT_FILENAME: *** Error: CMD_LOADBIN error."
    close $s
    exit 1
}
if {[string compare -length 4 $recv_data $CMD_LOADBIN]} {
    puts "CMD_LOADBIN @$LOAD_ADDRESS OK."
} else {
    puts stderr "$SCRIPT_FILENAME: *** Error: CMD_LOADBIN error."
    close $s
    exit 1
}

# send the binary file in chunks with size 1kB
chan configure stdout -buffering none
set chunk_length 1024
set sequence 1
puts -nonewline "sending "
while {true} {
    set data [read $fd_input $chunk_length]
    set data_length [string length $data]
    if {$data_length < 1} {
        break
    }
    send_command $s $CMD_PARTBIN $LOAD_ADDRESS $data_length $data
    puts -nonewline "."
    if {$data_length < $chunk_length} {
        break
    }
    set LOAD_ADDRESS [expr {$LOAD_ADDRESS + $data_length}]
    incr sequence
    msleep 30
}
puts ""
chan configure stdout -buffering line

# close the binary file
close $fd_input

# upload done
send_command $s $CMD_DONEBIN 0 0 ""
set recv_data [read $s 4096]
if {[eof $s]} {
    puts stderr "$SCRIPT_FILENAME: *** Error: CMD_DONEBIN error."
    close $s
    exit 1
}
if {[string compare -length 4 $recv_data $CMD_DONEBIN]} {
    puts "CMD_DONEBIN OK."
} else {
    puts stderr "$SCRIPT_FILENAME: *** Error: CMD_DONEBIN error."
    close $s
    exit 1
}

# execute
send_command $s $CMD_EXECUTE $START_ADDRESS 0 ""
set recv_data [read $s 4096]
if {[eof $s]} {
    puts stderr "$SCRIPT_FILENAME: *** Error: CMD_EXECUTE error."
    close $s
    exit 1
}
if {[string compare -length 4 $recv_data $CMD_EXECUTE]} {
    puts "CMD_EXECUTE @$START_ADDRESS OK."
} else {
    puts stderr "$SCRIPT_FILENAME: *** Error: CMD_EXECUTE error."
    close $s
    exit 1
}

# close UDP socket
close $s

exit 0

