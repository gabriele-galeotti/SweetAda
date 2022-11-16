#!/usr/bin/env python

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

import sys
# avoid generation of *.pyc
sys.dont_write_bytecode = True

import os

SCRIPT_FILENAME = sys.argv[0]

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

################################################################################
# u32_to_lebytes()                                                             #
#                                                                              #
# Creates a list of byte values with LE layout from a 32-bit value.            #
################################################################################
def u32_to_lebytes(n):
    byte0 = n % 0x100
    byte1 = (n / 0x100) % 0x100
    byte2 = (n / 0x10000) % 0x100
    byte3 = (n / 0x1000000) % 0x100
    return [byte0, byte1, byte2, byte3]

################################################################################
# ls2chs()                                                                     #
#                                                                              #
# Convert a logical sector value to CHS format.                                #
# CHS layout in MBR: [0]=HEAD, [1]=SECTOR|CYLINDERH, [3]=CYLINDERL             #
################################################################################
def ls2chs(sectorn, cyl, hpc, spt):
    c = (sectorn / (spt * hpc)) % cyl
    cl = c % 256
    ch = c / 256
    return [(sectorn / spt) % hpc, ((sectorn % spt) + 1) + (ch * 64), cl]

################################################################################
# write_partition()                                                            #
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
def write_partition(f, sector_start, sector_size):
    global CYL
    global HPC
    global SPT
    fp = open(f, "rb+")
    fp.seek(0x1BE, 0)
    # bootable flag
    fp.write(b'\x80')
    # CHS start
    fp.write(bytearray(ls2chs(sector_start, CYL, HPC, SPT)))
    # partition type (FAT32 CHS mode)
    fp.write(b'\x0B')
    # CHS end; ending sector, not the following one
    fp.write(bytearray(ls2chs((sector_start + sector_size - 1), CYL, HPC, SPT)))
    # LBA sector start
    fp.write(bytearray(u32_to_lebytes(sector_start)))
    # LBA size in sectors
    fp.write(bytearray(u32_to_lebytes(sector_size)))
    fp.close

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
if len(sys.argv) < 4:
    errprintf("%s: *** Error: invalid number of arguments.\n", SCRIPT_FILENAME)
    exit(1)

kernel_filename = sys.argv[1]
bootsegment = sys.argv[2]
device_filename = sys.argv[3]

kernel_size = os.stat(kernel_filename).st_size
#print(kernel_size)

printf("%s: creating hard disk ...\n", SCRIPT_FILENAME)

BPS = 512
# X/16/63 geometry
HPC = 16
SPT = 63
# X/255/63 geometry
#HPC = 255
#SPT = 63

# compute sectors per cylinder
SECTORS_PER_CYLINDER = HPC * SPT
# MBR # of sectors, 1 full cylinder
MBR_SECTORS = SECTORS_PER_CYLINDER
# compute # of sectors sufficient to contain the kernel
KERNEL_SECTORS = (kernel_size + BPS - 1) / BPS
printf("kernel sector count: %d (0x%X)\n", KERNEL_SECTORS, KERNEL_SECTORS)
# compute # of cylinders sufficient to contain the kernel
CYL_PARTITION = (KERNEL_SECTORS + SECTORS_PER_CYLINDER - 1) / SECTORS_PER_CYLINDER
# total device # of cylinders, +1 for full cylinder MBR
CYL = CYL_PARTITION + 1
# sector count of device
DEVICE_SECTORS = CYL * SECTORS_PER_CYLINDER

if len(device_filename) > 0 and device_filename[0] == "+":
    device_type = "FILE"
    device_filename = device_filename[1:]
    fp = open(device_filename, "wb")
    fp.seek(DEVICE_SECTORS * BPS - 1, 0)
    fp.write(b'\x00')
    fp.close()
    print(device_filename)
else:
    device_type = "DEVICE"
    while device_filename == "":
        printf("No device was specified.\n")
        printf("Enter device (e.g., /dev/sdf, <ENTER> to retry): ")
        sys.stdout.flush()
        device_filename = sys.stdin.readline().rstrip()

# partiton starts on cylinder boundary (1st full cylinder reserved for MBR)
PARTITION_SECTOR_START = SECTORS_PER_CYLINDER
PARTITION_SECTORS_SIZE = CYL_PARTITION * SECTORS_PER_CYLINDER
printf("partition sector start: %d\n", PARTITION_SECTOR_START)
printf("partition sector size:  %d\n", PARTITION_SECTORS_SIZE)

# build MBR (MS-DOS 6.22)
os.system(
    os.getenv("TOOLCHAIN_CC") + " " +
    "-o mbr.o -c"             + " " +
    os.path.join(os.getenv("SWEETADA_PATH"), os.getenv("SHARE_DIRECTORY"), "mbr.S")
    )
os.system(os.getenv("TOOLCHAIN_LD")      + " " + "-o mbr.bin -Ttext=0 --oformat=binary mbr.o")
os.system(os.getenv("TOOLCHAIN_OBJDUMP") + " " + "-m i8086 -D -M i8086 -b binary mbr.bin > mbr.lst")

# write MBR @ CHS(0,0,1)
printf("%s: creating MBR ...\n", SCRIPT_FILENAME)
fp = open("mbr.bin", "rb")
mbr = fp.read()
fp.close()
fp = open(device_filename, "rb+")
fp.seek(0, 0)
fp.write(mbr)
fp.close()

# write partition
printf("%s: creating partition ...\n", SCRIPT_FILENAME)
write_partition(device_filename, PARTITION_SECTOR_START, PARTITION_SECTORS_SIZE)

# build bootsector
# handle large partitions
if PARTITION_SECTORS_SIZE > 65535:
    PARTITION_SECTORS_SSIZE = 0
    PARTITION_SECTORS_LSIZE = PARTITION_SECTORS_SIZE
else:
    PARTITION_SECTORS_SSIZE = PARTITION_SECTORS_SIZE
    PARTITION_SECTORS_LSIZE = 0
os.system(
    os.getenv("TOOLCHAIN_CC")                                   + " " +
    "-o bootsector.o"                                           + " " +
    "-c"                                                        + " " +
    "-DCYLINDERS=" + str(CYL)                                   + " " +
    "-DHEADS=" + str(HPC)                                       + " " +
    "-DSPT=" + str(SPT)                                         + " " +
    "-DPARTITION_SECTOR_START=" + str(PARTITION_SECTOR_START)   + " " +
    "-DPARTITION_SECTORS_SSIZE=" + str(PARTITION_SECTORS_SSIZE) + " " +
    "-DPARTITION_SECTORS_LSIZE=" + str(PARTITION_SECTORS_LSIZE) + " " +
    "-DNSECTORS=" + str(KERNEL_SECTORS)                         + " " +
    "-DBOOTSEGMENT=" + bootsegment                              + " " +
    "-DDELAY"                                                   + " " +
    os.path.join(os.getenv("SWEETADA_PATH"), os.getenv("SHARE_DIRECTORY"), "bootsector.S")
    )
os.system(os.getenv("TOOLCHAIN_LD")      + " " + "-o bootsector.bin -Ttext=0 --oformat=binary bootsector.o")
os.system(os.getenv("TOOLCHAIN_OBJDUMP") + " " + "-m i8086 -D -M i8086 -b binary bootsector.bin > bootsector.lst")

# write bootsector @ CHS(1,0,1)
printf("%s: creating bootsector ...\n", SCRIPT_FILENAME)
fp = open("bootsector.bin", "rb")
bootsector = fp.read()
fp.close()
fp = open(device_filename, "rb+")
fp.seek(MBR_SECTORS * BPS, 0)
fp.write(bootsector)
fp.close()

# write kernel @ CHS(1,0,2)
printf("%s: writing input binary file ...\n", SCRIPT_FILENAME)
fp = open(kernel_filename, "rb")
kernel = fp.read()
fp.close()
fp = open(device_filename, "rb+")
fp.seek((MBR_SECTORS + 1) * BPS, 0)
fp.write(kernel)
fp.close()

# flush disk buffers
os.system("sync")
os.system("sync")

exit(0)

