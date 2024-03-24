#!/usr/bin/env python3

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
import os

SCRIPT_FILENAME = os.path.basename(sys.argv[0])

################################################################################
#                                                                              #
################################################################################

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

def bebytes_to_u32(block, offset):
    return block[offset + 0] * 0x1000000 + \
           block[offset + 1] * 0x10000   + \
           block[offset + 2] * 0x100     + \
           block[offset + 3]

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# 80 cylinders × 2 heads × 11 sectors × 512 bytes/sector = 901120 bytes
ADF_DISKSIZE = 80 * 2 * 11 * 512

asmboot_filename = None
kernel_filename = None
load_address = None
entry_point = None
adf_filename = None

# process arguments
argc = len(sys.argv)
argv_idx = 1
while argv_idx < argc:
    if   asmboot_filename == None:
        asmboot_filename = sys.argv[argv_idx]
    elif kernel_filename == None:
        kernel_filename = sys.argv[argv_idx]
    elif load_address == None:
        load_address = sys.argv[argv_idx]
    elif entry_point == None:
        entry_point = sys.argv[argv_idx]
    elif adf_filename == None:
        adf_filename = sys.argv[argv_idx]
    else:
        errprintf('%s: *** Error: unknown argument.\n', SCRIPT_FILENAME)
    argv_idx += 1

if asmboot_filename == None or \
   kernel_filename == None  or \
   load_address == None     or \
   entry_point == None      or \
   adf_filename == None:
    printf('Usage:\n')
    printf('adfcreate <asmboot_filename> <kernel_filename> <load_address> <entry_point> <adf_filename>\n')
    exit(1)

kernel_sectors = (os.stat(kernel_filename).st_size + (512 - 1)) // 512
kernel_start_sector = 2

os.system(
    os.getenv('TOOLCHAIN_CC')            + ' ' +
    '-o ' + asmboot_filename + '.o'      + ' ' +
    '-c'                                 + ' ' +
    '-DLOADADDRESS=' + str(load_address) + ' ' +
    '-DNSECTORS=' + str(kernel_sectors)  + ' ' +
    '-DENTRYPOINT=' + str(entry_point)   + ' ' +
    os.path.join(
        '"' + os.getenv('SWEETADA_PATH') + '"',
        os.getenv('SHARE_DIRECTORY'),
        asmboot_filename + '.S'
        )
    )
os.system(
    os.getenv('TOOLCHAIN_LD')         + ' ' +
    '-o ' + asmboot_filename + '.bin' + ' ' +
    '-Ttext=0 --oformat=binary'       + ' ' +
    asmboot_filename + '.o'
    )
os.system(
    os.getenv('TOOLCHAIN_OBJDUMP') + ' ' +
    '-D -m m68k -b binary'         + ' ' +
    asmboot_filename + '.bin'      + ' ' +
    '> adfboot.lst'
    )

fd_input = open(asmboot_filename + '.bin', 'rb')
bootdata = fd_input.read(-1)
fd_input.close()

bootdatalength = len(bootdata)
if bootdatalength != 1024:
    errprintf('%s: *** Error: input file length is not 1024 bytes.\n', SCRIPT_FILENAME)
    exit(1)

prechecksum = 0
i = 0
while i < bootdatalength:
    if i != 4:
        u32bytes = [bootdata[i + 0], bootdata[i + 1], bootdata[i + 2], bootdata[i + 3]]
        prechecksum += bebytes_to_u32(u32bytes, 0)
    i += 4
while prechecksum > 0xFFFFFFFF:
    prechecksum = (prechecksum & 0xFFFFFFFF) + (prechecksum >> 32)
checksum = 0xFFFFFFFF - prechecksum

printf('%s: creating floppy disk ...\n', SCRIPT_FILENAME)

fd_adf = open(adf_filename, 'wb')
fd_adf.write(bootdata[0:4])
fd_adf.write(checksum.to_bytes(4, byteorder='big'))
fd_adf.write(bootdata[8:bootdatalength + 1])
for i in range(bootdatalength, ADF_DISKSIZE):
    fd_adf.write(b'\x00')
fd_adf.close()

fd_data = open(kernel_filename, 'rb')
data = fd_data.read(-1)
fd_data.close()

fd_adf = open(adf_filename, 'r+b')
fd_adf.seek(kernel_start_sector * 512, 0)
fd_adf.write(data)
fd_adf.close()

exit(0)

