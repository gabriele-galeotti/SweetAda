#!/usr/bin/env tclsh

#
# Generate a PC-x86 bootable 18-sector 1.44 MB floppy disk.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
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
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

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

set kernel_filename [lindex $argv 0]
set bootsegment [lindex $argv 1]
set device_filename [lindex $argv 2]

set kernel_size [file size $kernel_filename]

puts "$SCRIPT_FILENAME: creating floppy disk ..."

set BPS 512
set CYL 80
set HPC 2
set SPT 18

# compute sectors per cylinder
set SECTORS_PER_CYLINDER [expr {$HPC * $SPT}]
# sector count of device
set DEVICE_SECTORS [expr {$CYL * $SECTORS_PER_CYLINDER}]

if {[string index $device_filename 0] eq "+"} {
    set device_type FILE
    set device_filename [string trimleft $device_filename "+"]
    set fd [open $device_filename "w"]
    seek $fd [expr {$DEVICE_SECTORS * $BPS - 1}]
    puts -nonewline $fd [binary format c1 0]
    close $fd
} else {
    set device_type DEVICE
    while {$device_filename eq ""} {
        puts "No device was specified."
        puts -nonewline "Enter device (e.g., /dev/sdf, <ENTER> to retry): "
        flush stdout
        gets stdin device_filename
    }
}

# build bootsector
set KERNEL_SECTORS [expr {($kernel_size + $BPS - 1) / $BPS}]
puts [format "%s: kernel sector count: %d (0x%X)" $SCRIPT_FILENAME $KERNEL_SECTORS $KERNEL_SECTORS]
exec {*}$::env(TOOLCHAIN_CC)    \
    -o bootsector.o             \
    -c                          \
    -DFLOPPYDISK                \
    -DNSECTORS=$KERNEL_SECTORS  \
    -DBOOTSEGMENT=$bootsegment  \
    -DDELAY                     \
    "[file join                 \
        $::env(SWEETADA_PATH)   \
        $::env(SHARE_DIRECTORY) \
        bootsector.S]"
exec {*}$::env(TOOLCHAIN_LD) -o bootsector.bin -Ttext=0 --oformat=binary bootsector.o
exec {*}$::env(TOOLCHAIN_OBJDUMP) -m i8086 -D -M i8086 -b binary bootsector.bin > bootsector.lst

# write bootsector @ CHS(0,0,1)
puts "$SCRIPT_FILENAME: creating bootsector ..."
set fd [open bootsector.bin "r"]
fconfigure $fd -translation binary
set bootsector [read $fd]
close $fd
set fd [open $device_filename "a+"]
fconfigure $fd -translation binary
seek $fd [expr {0 * $BPS}]
puts -nonewline $fd $bootsector
close $fd

# write kernel @ CHS(0,0,2)
puts "$SCRIPT_FILENAME: writing input binary file ..."
set fd [open $kernel_filename "r"]
fconfigure $fd -translation binary
set kernel [read $fd]
close $fd
set fd [open $device_filename "a+"]
fconfigure $fd -translation binary
seek $fd [expr {1 * $BPS}]
puts -nonewline $fd $kernel
close $fd

# flush disk buffers
if {[platform_get] eq "unix"} {
    exec sync
    exec sync
}

puts "$SCRIPT_FILENAME: done."

exit 0

