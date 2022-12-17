#!/usr/bin/env python

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
# SHARE_DIRECTORY
# TOOLCHAIN_CC
# TOOLCHAIN_LD
# TOOLCHAIN_OBJDUMP
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

import sys
# avoid generation of *.pyc
sys.dont_write_bytecode = True

SCRIPT_FILENAME = sys.argv[0]

################################################################################
#                                                                              #
################################################################################

import os

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
if len(sys.argv) < 4:
    errprintf('%s: *** Error: invalid number of arguments.\n', SCRIPT_FILENAME)
    exit(1)

kernel_filename = sys.argv[1]
bootsegment = sys.argv[2]
device_filename = sys.argv[3]

kernel_size = os.stat(kernel_filename).st_size

printf('%s: creating floppy disk ...\n', SCRIPT_FILENAME)

BPS = 512
CYL = 80
HPC = 2
SPT = 18

# compute sectors per cylinder
SECTORS_PER_CYLINDER = HPC * SPT
# sector count of device
DEVICE_SECTORS = CYL * SECTORS_PER_CYLINDER

if len(device_filename) > 0 and device_filename[0] == '+':
    device_type = 'FILE'
    device_filename = device_filename[1:]
    fd = open(device_filename, 'wb')
    fd.seek(DEVICE_SECTORS * BPS - 1, 0)
    fd.write(b'\x00')
    fd.close()
    print(device_filename)
else:
    device_type = 'DEVICE'
    while device_filename == '':
        printf('No device was specified.\n')
        printf('Enter device (e.g., /dev/sdf, <ENTER> to retry): ')
        sys.stdout.flush()
        device_filename = sys.stdin.readline().rstrip()

# build bootsector
KERNEL_SECTORS = (kernel_size + BPS - 1) / BPS
printf('kernel sector count: %d (0x%X)\n', KERNEL_SECTORS, KERNEL_SECTORS)
os.system(
    os.getenv('TOOLCHAIN_CC')           + ' ' +
    '-o bootsector.o'                   + ' ' +
    '-c'                                + ' ' +
    '-DFLOPPYDISK'                      + ' ' +
    '-DNSECTORS=' + str(KERNEL_SECTORS) + ' ' +
    '-DBOOTSEGMENT=' + bootsegment      + ' ' +
    '-DDELAY'                           + ' ' +
    os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('SHARE_DIRECTORY'), 'bootsector.S')
    )
os.system(os.getenv('TOOLCHAIN_LD')      + ' ' + '-o bootsector.bin -Ttext=0 --oformat=binary bootsector.o')
os.system(os.getenv('TOOLCHAIN_OBJDUMP') + ' ' + '-m i8086 -D -M i8086 -b binary bootsector.bin > bootsector.lst')

# write bootsector @ CHS(0,0,1)
printf('%s: creating bootsector ...\n', SCRIPT_FILENAME)
fd = open('bootsector.bin', 'rb')
bootsector = fd.read()
fd.close()
fd = open(device_filename, 'rb+')
fd.seek(0 * BPS, 0)
fd.write(bootsector)
fd.close()

# write kernel @ CHS(0,0,2)
printf('%s: writing input binary file ...\n', SCRIPT_FILENAME)
fd = open(kernel_filename, 'rb')
kernel = fd.read()
fd.close()
fd = open(device_filename, 'rb+')
fd.seek(1 * BPS, 0)
fd.write(kernel)
fd.close()

# flush disk buffers
os.system('sync')
os.system('sync')

exit(0)

