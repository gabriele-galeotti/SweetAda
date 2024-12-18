#!/usr/bin/env tclsh

#
# ADF (Amiga Disk File) creation.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = boot asm file without extension
# $2 = kernel filename
# $3 = kernel load address
# $4 = kernel entry point
# $3 = output ADF filename
#
# Environment variables:
# SWEETADA_PATH
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

proc bebytes_to_u32 {block offset} {
    return [expr \
               [scan [string index $block [expr $offset + 0]] %c] * 0x1000000 + \
               [scan [string index $block [expr $offset + 1]] %c] * 0x10000   + \
               [scan [string index $block [expr $offset + 2]] %c] * 0x100     + \
               [scan [string index $block [expr $offset + 3]] %c]               \
               ]
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# 80 cylinders × 2 heads × 11 sectors × 512 bytes/sector = 901120 bytes
set ADF_DISKSIZE [expr 80 * 2 * 11 * 512]

set asmboot_filename ""
set kernel_filename ""
set load_address 0
set entry_point 0
set adf_filename ""

# process arguments
set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    if       {$asmboot_filename eq ""} {
        set asmboot_filename $token
    } elseif {$kernel_filename eq ""} {
        set kernel_filename $token
    } elseif {$load_address == 0} {
        set load_address $token
    } elseif {$entry_point == 0} {
        set entry_point $token
    } elseif {$adf_filename eq ""} {
        set adf_filename $token
    } else {
        puts stderr "$SCRIPT_FILENAME: *** Error: unknown argument."
        exit 1
    }
    incr argv_idx
}

# check parameters
if {$asmboot_filename eq "" || \
    $kernel_filename eq ""  || \
    $load_address == 0      || \
    $entry_point == 0       || \
    $adf_filename eq ""} {
    puts "Usage:"
    puts "adfcreate <asmboot_filename> <kernel_filename> <load_address> <entry_point> <adf_filename>"
    exit 1
    }

set kernel_sectors [expr ([file size $kernel_filename] + (512 - 1)) / 512]
set kernel_start_sector 2

# create a boot binary object
exec {*}$::env(TOOLCHAIN_CC)    \
    -o "$asmboot_filename.o"    \
    -c                          \
    -DLOADADDRESS=$load_address \
    -DNSECTORS=$kernel_sectors  \
    -DENTRYPOINT=$entry_point   \
    "$asmboot_filename.S"
exec {*}$::env(TOOLCHAIN_LD)   \
    -o "$asmboot_filename.bin" \
    -Ttext=0 --oformat=binary  \
    "$asmboot_filename.o"
exec {*}$::env(TOOLCHAIN_OBJDUMP) \
    -D -m m68k -b binary          \
    "$asmboot_filename.bin"       \
    > "$asmboot_filename.lst"

# read the boot binary object
set fd_input [open "$asmboot_filename.bin" "rb"]
fconfigure $fd_input -translation binary
set bootdata [read $fd_input]
close $fd_input

set bootdatalength [string length $bootdata]
if {$bootdatalength != 1024} {
    puts stderr "$SCRIPT_FILENAME: *** Error: input file length is not 1024 bytes."
    exit 1
    }

# compute checksum
set prechecksum 0
set i 0
while {$i < $bootdatalength} {
    if {$i != 4} {
        set u32bytes [string range $bootdata $i [expr $i + 3]]
        set prechecksum [expr $prechecksum + [bebytes_to_u32 $u32bytes 0]]
    }
    incr i 4
}
while {$prechecksum > 0xFFFFFFFF} {
    set prechecksum [expr ($prechecksum & 0xFFFFFFFF) + ($prechecksum >> 32)]
}
set checksum [expr 0xFFFFFFFF - $prechecksum]

# create the floppy disk image
puts "$SCRIPT_FILENAME: creating floppy disk ..."
set fd_adf [open $adf_filename "wb"]
puts -nonewline $fd_adf [string range $bootdata 0 3]
set checksum_string [format "%08x" $checksum]
puts -nonewline $fd_adf [binary format c 0x[string range $checksum_string 0 1]]
puts -nonewline $fd_adf [binary format c 0x[string range $checksum_string 2 3]]
puts -nonewline $fd_adf [binary format c 0x[string range $checksum_string 4 5]]
puts -nonewline $fd_adf [binary format c 0x[string range $checksum_string 6 7]]
puts -nonewline $fd_adf [string range $bootdata 8 $bootdatalength]
for {set i $bootdatalength} {$i < $ADF_DISKSIZE} {incr i} {
    puts -nonewline $fd_adf [binary format c1 0x00]
}
close $fd_adf
set fd_data [open $kernel_filename "rb"]
set data [read $fd_data]
close $fd_data
set fd_adf [open $adf_filename "r+b"]
seek $fd_adf [expr $kernel_start_sector * 512] start
puts -nonewline $fd_adf $data
close $fd_adf

exit 0

