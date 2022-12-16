#!/usr/bin/env tclsh

#
# Generate a PC-x86 bootable hard disk.
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

#
# bootsector.S differences from standard floppy disk bootsector:
# - physical disk number = 0x80
# - nsectorshi, nsectorslo, spt, heads are configurable
# - no floppy disk motor shutdown
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
# ls2chs                                                                       #
#                                                                              #
# Convert a logical sector value to CHS format.                                #
# CHS layout in MBR: [0]=HEAD, [1]=SECTOR|CYLINDERH, [3]=CYLINDERL             #
################################################################################
proc ls2chs {sectorn cyl hpc spt} {
    set chs {}
    lappend chs [expr ($sectorn / $spt) % $hpc]
    set c [expr ($sectorn / ($spt * $hpc)) % $cyl]
    set cl [expr $c % 2**8]
    set ch [expr $c / 2**8]
    lappend chs [expr (($sectorn % $spt) + 1) + ($ch * 2**6)]
    lappend chs $cl
    return $chs
}

################################################################################
# write_partition                                                              #
#                                                                              #
################################################################################
# manually create an MS-DOS partition
# -----------------------------------
# 1st partition descriptor: offset 0x1BE = 446
# 80          = boot indicator                        = bootable
# 00 01 01    = starting encoded CHS, INT 0x13 format = H:0x00 S:0x01 C:0x01 = second cylinder, first head, first sector
# ??          = partition type                        =
# 03 11 1F    = ending encoded CHS, INT 0x13 format   = H:0x03 S:0x11 C:0x1F = last cylinder, last head, last sector
# 44 00 00 00 = starting sector (0-based, LBA)        = 0x00000044 = 4 * 17 = HPC * SPT
# 3C 08 00 00 = partition size in sectors             = 0x0000083C = (32 - 1) * 4 * 17 = (CYL - 1) * HPC * SPT
proc write_partition {f sector_start sector_size} {
    global CYL
    global HPC
    global SPT
    set fd [open $f "a+"]
    fconfigure $fd -translation binary
    seek $fd 0x1BE start
    # bootable flag
    puts -nonewline $fd [binary format c1 0x80]
    # CHS start
    puts -nonewline $fd [binary format c3 [ls2chs $sector_start $CYL $HPC $SPT]]
    # partition type (FAT32 CHS mode)
    puts -nonewline $fd [binary format c1 0x0B]
    # CHS end; ending sector, not the following one
    puts -nonewline $fd [binary format c3 [ls2chs [expr $sector_start + $sector_size - 1] $CYL $HPC $SPT]]
    # LBA sector start
    puts -nonewline $fd [binary format c4 [u32_to_lebytes $sector_start]]
    # LBA size in sectors
    puts -nonewline $fd [binary format c4 [u32_to_lebytes $sector_size]]
    close $fd
}

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

puts "$SCRIPT_FILENAME: creating hard disk ..."

set BPS 512
# X/16/63 geometry
set HPC 16
set SPT 63
# X/255/63 geometry
#set HPC 255
#set SPT 63

# compute sectors per cylinder
set SECTORS_PER_CYLINDER [expr $HPC * $SPT]
# MBR # of sectors, 1 full cylinder
set MBR_SECTORS $SECTORS_PER_CYLINDER
# compute # of sectors sufficient to contain the kernel
set KERNEL_SECTORS [expr ($kernel_size + $BPS - 1) / $BPS]
puts [format "kernel sector count: %d (0x%X)" $KERNEL_SECTORS $KERNEL_SECTORS]
# compute # of cylinders sufficient to contain the kernel
set CYL_PARTITION [expr ($KERNEL_SECTORS + $SECTORS_PER_CYLINDER - 1) / $SECTORS_PER_CYLINDER]
# total device # of cylinders, +1 for full cylinder MBR
set CYL [expr $CYL_PARTITION + 1]
# sector count of device
set DEVICE_SECTORS [expr $CYL * $SECTORS_PER_CYLINDER]

if {[string index $device_filename 0] eq "+"} {
    set device_type FILE
    set device_filename [string trimleft $device_filename "+"]
    set fd [open $device_filename "w"]
    fconfigure $fd -translation binary
    seek $fd [expr $DEVICE_SECTORS * $BPS - 1] start
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

# partiton starts on cylinder boundary (1st full cylinder reserved for MBR)
set PARTITION_SECTOR_START $SECTORS_PER_CYLINDER
set PARTITION_SECTORS_SIZE [expr $CYL_PARTITION * $SECTORS_PER_CYLINDER]
puts "partition sector start: $PARTITION_SECTOR_START"
puts "partition sector size:  $PARTITION_SECTORS_SIZE"

# build MBR (MS-DOS 6.22)
eval exec $::env(TOOLCHAIN_CC)                                    \
  -o mbr.o                                                        \
  -c                                                              \
  [file join $::env(SWEETADA_PATH) $::env(SHARE_DIRECTORY) mbr.S]
eval exec $::env(TOOLCHAIN_LD) -o mbr.bin -Ttext=0 --oformat=binary mbr.o
eval exec $::env(TOOLCHAIN_OBJDUMP) -m i8086 -D -M i8086 -b binary mbr.bin > mbr.lst

# write MBR @ CHS(0,0,1)
puts "$SCRIPT_FILENAME: creating MBR ..."
set fd [open "mbr.bin" "r"]
fconfigure $fd -translation binary
set mbr [read $fd]
close $fd
set fd [open $device_filename "a+"]
fconfigure $fd -translation binary
seek $fd 0 start
puts -nonewline $fd $mbr
close $fd

# write partition
puts "$SCRIPT_FILENAME: creating partition ..."
write_partition $device_filename $PARTITION_SECTOR_START $PARTITION_SECTORS_SIZE

# build bootsector
# handle large partitions
if {$PARTITION_SECTORS_SIZE > 65535} {
    set PARTITION_SECTORS_SSIZE 0
    set PARTITION_SECTORS_LSIZE $PARTITION_SECTORS_SIZE
} else {
    set PARTITION_SECTORS_SSIZE $PARTITION_SECTORS_SIZE
    set PARTITION_SECTORS_LSIZE 0
}
eval exec $::env(TOOLCHAIN_CC)                                           \
  -o bootsector.o                                                        \
  -c                                                                     \
  -DCYLINDERS=$CYL                                                       \
  -DHEADS=$HPC                                                           \
  -DSPT=$SPT                                                             \
  -DPARTITION_SECTOR_START=$PARTITION_SECTOR_START                       \
  -DPARTITION_SECTORS_SSIZE=$PARTITION_SECTORS_SSIZE                     \
  -DPARTITION_SECTORS_LSIZE=$PARTITION_SECTORS_LSIZE                     \
  -DNSECTORS=$KERNEL_SECTORS                                             \
  -DBOOTSEGMENT=$bootsegment                                             \
  -DDELAY                                                                \
  [file join $::env(SWEETADA_PATH) $::env(SHARE_DIRECTORY) bootsector.S]
eval exec $::env(TOOLCHAIN_LD) -o bootsector.bin -Ttext=0 --oformat=binary bootsector.o
eval exec $::env(TOOLCHAIN_OBJDUMP) -m i8086 -D -M i8086 -b binary bootsector.bin > bootsector.lst

# write bootsector @ CHS(1,0,1)
puts "$SCRIPT_FILENAME: creating bootsector ..."
set fd [open "bootsector.bin" "r"]
fconfigure $fd -translation binary
set bootsector [read $fd]
close $fd
set fd [open $device_filename "a+"]
fconfigure $fd -translation binary
seek $fd [expr $MBR_SECTORS * $BPS] start
puts -nonewline $fd $bootsector
close $fd

# write kernel @ CHS(1,0,2)
puts "$SCRIPT_FILENAME: writing input binary file ..."
set fd [open $kernel_filename "r"]
fconfigure $fd -translation binary
set kernel [read $fd]
close $fd
set fd [open $device_filename "a+"]
fconfigure $fd -translation binary
seek $fd [expr ($MBR_SECTORS + 1) * $BPS] start
puts -nonewline $fd $kernel
close $fd

# flush disk buffers
exec sync
exec sync

exit 0

