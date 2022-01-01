#!/usr/bin/env tclsh

#
# Generate a PC-x86 bootable 18-sector 1.44 MB floppy disk.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input binary file
# $2 = BOOTSEGMENT (CS value)
# $3 = ID of physical device or virtual device filename (prefixed with "+")
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# SHARE_DIRECTORY
# TOOLCHAIN_CC
# TOOLCHAIN_LD
# TOOLCHAIN_OBJDUMP
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

#
# Basic input parameters check.
#
if {[llength $argv] < 3} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set kernel_filename [lindex $argv 0]
set bootsegment [lindex $argv 1]
set device_filename [lindex $argv 2]

puts "$SCRIPT_FILENAME: creating floppy disk ..."

set BPS 512
set CYL 80
set HPC 2
set SPT 18

set SECTORS_PER_CYLINDER [expr $HPC * $SPT]
set SECTOR_COUNT [expr $CYL * $SECTORS_PER_CYLINDER]

if {[string index $device_filename 0] eq "+"} {
    set device_type FILE
    set device_filename [string trimleft $device_filename "+"]
    set fp [open $device_filename "w"]
    seek $fp [expr $SECTOR_COUNT * $BPS - 1]
    puts -nonewline $fp [binary format c1 0]
    close $fp
} else {
    set device_type DEVICE
    while {$device_filename eq ""} {
        puts "No device was specified."
        puts -nonewline "Enter device (e.g., /dev/sdf, <ENTER> to retry): "
        flush stdout
        gets stdin device_filename
    }
}

# build bootrecord
set kernel_size [file size $kernel_filename]
set NSECTORS [expr ($kernel_size + $BPS - 1) / $BPS]
puts [format "kernel sector count: %d (0x%X)" $NSECTORS $NSECTORS]
eval exec $::env(TOOLCHAIN_CC)                                           \
  -o bootsector.o                                                        \
  -c                                                                     \
  -DFLOPPYDISK                                                           \
  -DNSECTORS=$NSECTORS                                                   \
  -DBOOTSEGMENT=$bootsegment                                             \
  -DDELAY                                                                \
  [file join $::env(SWEETADA_PATH) $::env(SHARE_DIRECTORY) bootsector.S]
eval exec $::env(TOOLCHAIN_LD) -o bootsector.bin -Ttext=0 --oformat=binary bootsector.o
eval exec $::env(TOOLCHAIN_OBJDUMP) -m i8086 -D -M i8086 -b binary bootsector.bin > bootsector.lst

# write bootrecord @ CHS(0,0,1)
puts "$SCRIPT_FILENAME: creating bootrecord ..."
set fp [open bootsector.bin "r"]
fconfigure $fp -translation binary
set bootrecord [read $fp]
close $fp
set fp [open $device_filename "a+"]
fconfigure $fp -translation binary
seek $fp [expr 0 * $BPS]
puts -nonewline $fp $bootrecord
close $fp

# write kernel @ CHS(0,0,2)
puts "$SCRIPT_FILENAME: writing input binary file ..."
set fp [open $kernel_filename "r"]
fconfigure $fp -translation binary
set kernel [read $fp]
close $fp
set fp [open $device_filename "a+"]
fconfigure $fp -translation binary
seek $fp [expr 1 * $BPS]
puts -nonewline $fp $kernel
close $fp

# flush disk buffers
exec sync
exec sync

exit 0

