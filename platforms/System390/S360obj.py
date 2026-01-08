#!/usr/bin/env python3

#
# Create a minimal S/360 object file suitable to be IPLed.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# [-a hex_address] [-l loader] [-p] <input_filename> <output_filename>
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
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

sys.path.append(os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('LIBUTILS_DIRECTORY')))
import library

################################################################################
# S/360 object file format utilities                                           #
################################################################################

#
# ASCII -> EBCDIC
#
ASCII2EBCDIC = [
#       x0    x1    x2    x3    x4    x5    x6    x7    x8    x9    xA    xB    xC    xD    xE    xF
#
# 0x    NUL   SOH   STX   ETX   EOT   ENQ   ACK   BEL   BS    HT    LF    VT    FF    CR    SO    SI
        0x00, 0x01, 0x02, 0x03, 0x37, 0x2D, 0x2E, 0x2F, 0x16, 0x05, 0x25, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
# 1x    DLE   DC1   DC2   DC3   DC4   NAK   SYN   ETB   CAN   EM    SUB   ESC   FS    GS    RS    US
        0x10, 0x11, 0x12, 0x13, 0x3C, 0x3D, 0x32, 0x26, 0x18, 0x19, 0x1A, 0x27, 0x22, 0x1D, 0x35, 0x1F,
# 2x    SP    !     "     #     $     %     &     '     (     )     *     +     ,     -     .     /
        0x40, 0x5A, 0x7F, 0x7B, 0x5B, 0x6C, 0x50, 0x7D, 0x4D, 0x5D, 0x5C, 0x4E, 0x6B, 0x60, 0x4B, 0x61,
# 3x    0     1     2     3     4     5     6     7     8     9     :     ;     <     =     >     ?
        0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7, 0xF8, 0xF9, 0x7A, 0x5E, 0x4C, 0x7E, 0x6E, 0x6F,
# 4x    @     A     B     C     D     E     F     G     H     I     J     K     L     M     N     O
        0x7C, 0xC1, 0xC2, 0xC3, 0xC4, 0xC5, 0xC6, 0xC7, 0xC8, 0xC9, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6,
# 5x    P     Q     R     S     T     U     V     W     X     Y     Z     [     \     ]     ^     _
        0xD7, 0xD8, 0xD9, 0xE2, 0xE3, 0xE4, 0xE5, 0xE6, 0xE7, 0xE8, 0xE9, 0xAD, 0xE0, 0xBD, 0x5F, 0x6D,
# 6x    `     a     b     c     d     e     f     g     h     i     j     k     l     m     n     o
        0x79, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96,
# 7x    p     q     r     s     t     u     v     w     x     y     z     {     |     }     ~     DEL
        0x97, 0x98, 0x99, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7, 0xA8, 0xA9, 0xC0, 0x6A, 0xD0, 0xA1, 0x07,
# 8x
        0x68, 0xDC, 0x51, 0x42, 0x43, 0x44, 0x47, 0x48, 0x52, 0x53, 0x54, 0x57, 0x56, 0x58, 0x63, 0x67,
# 9x
        0x71, 0x9C, 0x9E, 0xCB, 0xCC, 0xCD, 0xDB, 0xDD, 0xDF, 0xEC, 0xFC, 0xB0, 0xB1, 0xB2, 0xB3, 0xB4,
# Ax
        0x45, 0x55, 0xCE, 0xDE, 0x49, 0x69, 0x04, 0x06, 0xAB, 0x08, 0xBA, 0xB8, 0xB7, 0xAA, 0x8A, 0x8B,
# Bx
        0x09, 0x0A, 0x14, 0xBB, 0x15, 0xB5, 0xB6, 0x17, 0x1B, 0xB9, 0x1C, 0x1E, 0xBC, 0x20, 0xBE, 0xBF,
# Cx
        0x21, 0x23, 0x24, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x30, 0x31, 0xCA, 0x33, 0x34, 0x36, 0x38, 0xCF,
# Dx
        0x39, 0x3A, 0x3B, 0x3E, 0x41, 0x46, 0x4A, 0x4F, 0x59, 0x62, 0xDA, 0x64, 0x65, 0x66, 0x70, 0x72,
# Ex
        0x73, 0xE1, 0x74, 0x75, 0x76, 0x77, 0x78, 0x80, 0x8C, 0x8D, 0x8E, 0xEB, 0x8F, 0xED, 0xEE, 0xEF,
# Fx
        0x90, 0x9A, 0x9B, 0x9D, 0x9F, 0xA0, 0xAC, 0xAE, 0xAF, 0xFD, 0xFE, 0xFB, 0x3F, 0xEA, 0xFA, 0xFF
    ]

EBCDIC_SPACE = 0x40

################################################################################
# str2ebcdic()                                                                 #
#                                                                              #
################################################################################
def str2ebcdic(string):
    data = []
    for c in string:
        data.append(ASCII2EBCDIC[ord(c)])
    return data

################################################################################
# file_write_byte()                                                            #
#                                                                              #
################################################################################
def file_write_byte(f, byte):
    buffer = bytearray([int(byte)])
    f.write(buffer)
    return

################################################################################
# write_esd_record()                                                           #
#                                                                              #
################################################################################
def write_esd_record(fd, sequence, address, length):
    address_bytes = library.u32_to_bebytes(address)
    nmodules = 1
    size_bytes = library.u16_to_bebytes(nmodules * 16)
    file_write_byte(fd, 0x02)                   # 01 constant
    file_write_byte(fd, ASCII2EBCDIC[ord('E')]) # 02 EBCDIC "E"
    file_write_byte(fd, ASCII2EBCDIC[ord('S')]) # 03 EBCDIC "S"
    file_write_byte(fd, ASCII2EBCDIC[ord('D')]) # 04 EBCDIC "D"
    file_write_byte(fd, EBCDIC_SPACE)           # 05 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 06 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 07 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 08 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 09 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 10 unused
    file_write_byte(fd, size_bytes[0])          # 11 # of bytes, H
    file_write_byte(fd, size_bytes[1])          # 12 # of bytes, L
    file_write_byte(fd, EBCDIC_SPACE)           # 13 flag bits
    file_write_byte(fd, EBCDIC_SPACE)           # 14 flag bits
    file_write_byte(fd, 0x00)                   # 15 ESDID = 1
    file_write_byte(fd, 0x01)                   # 16 ESDID = 1
    # 1st module, 16 bytes
    for p in range (1, 9):                      # 1..8 name
        file_write_byte(fd, EBCDIC_SPACE)
    file_write_byte(fd, 0x04)                   # 9    type = PC
    file_write_byte(fd, address_bytes[1])       # 10   module starting address, byte N
    file_write_byte(fd, address_bytes[2])       # 11   module starting address, byte M
    file_write_byte(fd, address_bytes[3])       # 12   module starting address, byte L
    file_write_byte(fd, 0x00)                   # 13   flag
    length_bytes = library.u32_to_bebytes(length)
    file_write_byte(fd, length_bytes[1])        # 14   binary length (PC), byte N
    file_write_byte(fd, length_bytes[2])        # 15   binary length (PC), byte M
    file_write_byte(fd, length_bytes[3])        # 16   binary length (PC), byte L
    # 2nd module, 16 bytes, none
    for p in range (1, 17):
        file_write_byte(fd, EBCDIC_SPACE)
    # 3rd module, 16 bytes, none
    for p in range (1, 17):
        file_write_byte(fd, EBCDIC_SPACE)
    for p in range (1, 9):                      # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    seqstring = '%08d' % sequence               # 73 deck ID or sequence number
    seqdata = str2ebcdic(seqstring)
    for s in seqdata:
        file_write_byte(fd, s)
    return

################################################################################
# write_txt_record()                                                           #
#                                                                              #
################################################################################
def write_txt_record(fd, sequence, address, data):
    address_bytes = library.u32_to_bebytes(address)
    size_bytes = library.u16_to_bebytes(len(data))
    file_write_byte(fd, 0x02)                   # 01 constant
    file_write_byte(fd, ASCII2EBCDIC[ord('T')]) # 02 EBCDIC "T"
    file_write_byte(fd, ASCII2EBCDIC[ord('X')]) # 03 EBCDIC "X"
    file_write_byte(fd, ASCII2EBCDIC[ord('T')]) # 04 EBCDIC "T"
    file_write_byte(fd, EBCDIC_SPACE)           # 05 unused
    file_write_byte(fd, address_bytes[1])       # 06 address of 1st byte, byte N
    file_write_byte(fd, address_bytes[2])       # 07 address of 1st byte, byte M
    file_write_byte(fd, address_bytes[3])       # 08 address of 1st byte, byte L
    file_write_byte(fd, EBCDIC_SPACE)           # 09 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 10 unused
    file_write_byte(fd, size_bytes[0])          # 11 # of bytes, H
    file_write_byte(fd, size_bytes[1])          # 12 # of bytes, L
    file_write_byte(fd, EBCDIC_SPACE)           # 13 unused
    file_write_byte(fd, EBCDIC_SPACE)           # 14 unused
    file_write_byte(fd, 0x00)                   # 15 ESDID = 1
    file_write_byte(fd, 0x01)                   # 16 ESDID = 1
    for byte in data:                           # 17 56 bytes of data
        file_write_byte(fd, byte)
    for p in range (len(data), 56):             # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    seqstring = '%08d' % sequence               # 73 deck ID or sequence number
    seqdata = str2ebcdic(seqstring)
    for s in seqdata:
        file_write_byte(fd, s)
    return

################################################################################
# write_rld_record()                                                           #
#                                                                              #
################################################################################
def write_rld_record(fd, sequence):
    file_write_byte(fd, 0x02)                   # 01 constant
    file_write_byte(fd, ASCII2EBCDIC[ord('R')]) # 02 EBCDIC "R"
    file_write_byte(fd, ASCII2EBCDIC[ord('L')]) # 03 EBCDIC "L"
    file_write_byte(fd, ASCII2EBCDIC[ord('D')]) # 04 EBCDIC "D"
    for p in range (4, 72):                     # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    seqstring = '%08d' % sequence               # 73 deck ID or sequence number
    seqdata = str2ebcdic(seqstring)
    for s in seqdata:
        file_write_byte(fd, s)
    return

################################################################################
# write_sym_record()                                                           #
#                                                                              #
################################################################################
def write_sym_record(fd, sequence):
    file_write_byte(fd, 0x02)                   # 01 constant
    file_write_byte(fd, ASCII2EBCDIC[ord('S')]) # 02 EBCDIC "S"
    file_write_byte(fd, ASCII2EBCDIC[ord('Y')]) # 03 EBCDIC "Y"
    file_write_byte(fd, ASCII2EBCDIC[ord('M')]) # 04 EBCDIC "M"
    for p in range (4, 72):                     # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    seqstring = '%08d' % sequence               # 73 deck ID or sequence number
    seqdata = str2ebcdic(seqstring)
    for s in seqdata:
        file_write_byte(fd, s)
    return

################################################################################
# write_xsd_record()                                                           #
#                                                                              #
################################################################################
def write_xsd_record(fd, sequence):
    file_write_byte(fd, 0x02)                   # 01 constant
    file_write_byte(fd, ASCII2EBCDIC[ord('X')]) # 02 EBCDIC "X"
    file_write_byte(fd, ASCII2EBCDIC[ord('S')]) # 03 EBCDIC "S"
    file_write_byte(fd, ASCII2EBCDIC[ord('D')]) # 04 EBCDIC "D"
    for p in range (4, 72):                     # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    seqstring = '%08d' % sequence               # 73 deck ID or sequence number
    seqdata = str2ebcdic(seqstring)
    for s in seqdata:
        file_write_byte(fd, s)
    return

################################################################################
# write_end_record()                                                           #
#                                                                              #
################################################################################
def write_end_record(fd, sequence):
    file_write_byte(fd, 0x02)                   # 01 constant
    file_write_byte(fd, ASCII2EBCDIC[ord('E')]) # 02 EBCDIC "E"
    file_write_byte(fd, ASCII2EBCDIC[ord('N')]) # 03 EBCDIC "N"
    file_write_byte(fd, ASCII2EBCDIC[ord('D')]) # 04 EBCDIC "D"
    for p in range (4, 16):                     # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    file_write_byte(fd, ASCII2EBCDIC[ord('S')]) # 17 EBCDIC "S"
    file_write_byte(fd, ASCII2EBCDIC[ord('w')]) # 18 EBCDIC "w"
    file_write_byte(fd, ASCII2EBCDIC[ord('e')]) # 19 EBCDIC "e"
    file_write_byte(fd, ASCII2EBCDIC[ord('e')]) # 20 EBCDIC "e"
    file_write_byte(fd, ASCII2EBCDIC[ord('t')]) # 21 EBCDIC "t"
    file_write_byte(fd, ASCII2EBCDIC[ord('A')]) # 22 EBCDIC "A"
    file_write_byte(fd, ASCII2EBCDIC[ord('d')]) # 23 EBCDIC "d"
    file_write_byte(fd, ASCII2EBCDIC[ord('a')]) # 24 EBCDIC "a"
    for p in range (24, 32):                    # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    file_write_byte(fd, ASCII2EBCDIC[ord('2')]) # 33 EBCDIC "2"
    for p in range (33, 72):                    # pad with blanks
        file_write_byte(fd, EBCDIC_SPACE)
    seqstring = '%08d' % sequence               # 73 deck ID or sequence number
    seqdata = str2ebcdic(seqstring)
    for s in seqdata:
        file_write_byte(fd, s)
    return

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

PSW_FLAG = 0x0C

input_filename = None
output_filename = None
address = 0x18 # default
loader_filename = None
write_psw = False

# process arguments
argc = len(sys.argv)
argv_idx = 1
while argv_idx < argc:
    if sys.argv[argv_idx] == '-a':
        argv_idx += 1
        address = int(sys.argv[argv_idx], 16)
    elif sys.argv[argv_idx] == '-l':
        argv_idx += 1
        loader_filename = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-p':
        write_psw = True
    elif input_filename == None:
        input_filename = sys.argv[argv_idx]
    else:
        output_filename = sys.argv[argv_idx]
    argv_idx += 1

# open files
fd_input = open(input_filename, 'rb')
fd_output = open(output_filename, 'wb')

# prepend the loader
if loader_filename != None:
    fd_loader = open(loader_filename, 'rb')
    while True:
        data = fd_loader.read(1)
        if len(data) < 1:
            break
        file_write_byte(fd_output, data[0])
    fd_loader.close()

# initialize sequence
sequence = 1

# create ESD record
filesize = os.stat(input_filename).st_size
write_esd_record(fd_output, sequence, address, filesize)
sequence += 1

# create TXT PSW record
if write_psw:
    # create TXT record which contains PSW @ 0
    # create S/390 31-bit PSW
    address_bytes = library.u32_to_bebytes(address or 0x80000000)
    psw = [0x00, PSW_FLAG, 0x00, 0x00]
    psw.append(address_bytes[0])
    psw.append(address_bytes[1])
    psw.append(address_bytes[2])
    psw.append(address_bytes[3])
    write_txt_record(fd_output, sequence, 0, psw)
    sequence += 1

# create TXT data records
while True:
    data = fd_input.read(56)
    data_length = len(data)
    if data_length > 0:
        write_txt_record(fd_output, sequence, address, data)
        address += data_length
        sequence += 1
    if data_length < 56:
        break

# create END record
write_end_record(fd_output, sequence)

# write out number of records written
print('{0:s}: number of records written: {1:d}'.format(SCRIPT_FILENAME, sequence))
fd_input.close()
fd_output.close()

exit(0)

