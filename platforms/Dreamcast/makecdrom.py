#!/usr/bin/env python3

#
# Generate files to create a Dreamcast CD-ROM.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = template filename (IP.TMPL)
# $2 = input filename (IP.TXT)
# $3 = kernel filename
#
# Environment variables:
# none
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

################################################################################
# crc16                                                                        #
#                                                                              #
################################################################################
def crc16(data, offset, length):
    crc = 0xFFFF
    for d in data[offset:offset + length]:
        crc = crc ^ (d << 8)
        for n in range(0, 8):
            if (crc & 0x8000) != 0:
                crc = (crc << 1) ^ 0x1021
            else:
                crc = crc << 1
        crc = crc & 0xFFFF
    return crc

################################################################################
# randomize                                                                    #
#                                                                              #
################################################################################
def randomize():
    global seed
    seed = (seed * 2109 + 9273) & 0x7FFF
    return (seed + 0xC000) & 0xFFFF

################################################################################
# save_chunk                                                                   #
#                                                                              #
################################################################################
def save_chunk(fd, data, offset, size):
    size = size // 32
    table = []
    for i in range(0, size):
        table.append(i)
    for i in range(size - 1, -1, -1):
        x = (randomize() * i) >> 16
        # swap
        tmp = table[i]
        table[i] = table[x]
        table[x] = tmp
        # write a 32-byte chunk
        start = offset + 32 * table[i]
        end = start + 32 - 1
        for b in data[start:end + 1]:
            fd.write(b.to_bytes(1, 'big'))

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# 1st part: generate IP.BIN suitable to be stored in a CD-ROM.
#
# Input:
# - template filename (IP.TMPL)
# - input filename (IP.TXT)
# Output:
# - IP.BIN
#

if len(sys.argv) < 4:
    errprintf('%s: *** Error: invalid number of arguments.\n', SCRIPT_FILENAME)
    exit(1)

#          name             pos   len   check  processed
fields = [
          ['Hardware ID',   0x00, 0x10, False, False],
          ['Maker ID',      0x10, 0x10, False, False],
          ['Device Info',   0x20, 0x10, False, False],
          ['Area Symbols',  0x30, 0x08, True,  False],
          ['Peripherals',   0x38, 0x08, False, False],
          ['Product No',    0x40, 0x0A, False, False],
          ['Version',       0x4A, 0x06, False, False],
          ['Release Date',  0x50, 0x10, False, False],
          ['Boot Filename', 0x60, 0x10, False, False],
          ['SW Maker Name', 0x70, 0x10, False, False],
          ['Game Title',    0x80, 0x80, False, False]
         ]

filetmpl = sys.argv[1]
filein = sys.argv[2]
fileout = 'IP.BIN'

# read template file
fd_tmpl = open(filetmpl, 'rb')
tmpl_data = list(fd_tmpl.read(32768))
fd_tmpl.close()

# read input file
fd_filein = open(filein, 'r')
filein_textlines = fd_filein.readlines()
fd_filein.close()

# parse tokens, perform processing
for line in filein_textlines:
    tokens = line.strip().split(':')
    token_name = tokens[0].strip()
    token_value = tokens[1].strip()
    found = -1
    for i in range(0, len(fields)):
        if token_name == fields[i][0]:
            found = i
            break
    if found < 0:
        errprintf('%s: *** Warning: unknown token: %s.\n', SCRIPT_FILENAME, token_name)
        break
    # now we have the field index in i
    position = fields[i][1]
    length = fields[i][2]
    check = fields[i][3]
    # check length
    if len(token_value) > length:
        errprintf('%s: *** Warning: extra token length: %d.\n', SCRIPT_FILENAME, token_value)
    # check memory areas
    if check == True:
        J = ' '
        U = ' '
        E = ' '
        for c in token_value:
            if   c == 'J':
                 J = 'J'
            elif c == 'U':
                 U = 'U'
            elif c == 'E':
                 E = 'E'
            else:
                errprintf('%s: *** Error: invalid symbol: %s.\n', SCRIPT_FILENAME, token_value)
                exit(1)
        token_value = J + U + E
    # create a maximum length space-padded string and write the value
    # left-justified
    string_padded = token_value.ljust(length)
    tmpl_data[position:position + length] = bytes(string_padded.encode('utf-8'))
    # flag as processed
    fields[i][4] = True

# check for some token not processed
for i in range(0, len(fields)):
    if fields[i][4] != True:
        errprintf('%s: *** Warning: token %s not processed.\n', SCRIPT_FILENAME, fields[i][0])

# compute CRC
crc_value = crc16(tmpl_data, 0x40, 16)
crc_value_current = 0
for c in tmpl_data[0x20:0x23 + 1]:
    crc_value_current = crc_value_current * 16 + (c - 0x30)
# sprintf()-like
if crc_value != crc_value_current:
    printf('Setting CRC to 0x%04X (was 0x%04X).\n', crc_value, crc_value_current)
    tmpl_data[0x20:0x23 + 1] = bytes('{0:04X}'.format(crc_value).encode('utf-8'))
# generate output file
fd_fileout = open(fileout, 'wb')
for b in tmpl_data:
    fd_fileout.write(b.to_bytes(1, 'big'))
fd_fileout.close()

#
# 2nd part: "scramble" the kernel file and generate 1ST_READ.BIN.
#
# Input:
# - kernel filename
# Output:
# - 1ST_READ.BIN
#

MAXCHUNK = 2048 * 1024

filein = sys.argv[3]
fileout = '1ST_READ.BIN'

# read input file
fd_filein = open(filein, 'rb')
filein_data = fd_filein.read()
fd_filein.close()

# file size
filein_size = len(filein_data)

# create a seed
seed = filein_size & 0xFFFF

# generate output file
fd_fileout = open(fileout, 'wb')
# descramble 2 M blocks for as long as possible, then gradually reduce the
# window down to 32 bytes (1 slice)
offset = 0
chunk_size = MAXCHUNK
while chunk_size >= 32:
    while filein_size >= chunk_size:
        save_chunk(fd_fileout, filein_data, offset, chunk_size)
        filein_size = filein_size - chunk_size
        offset = offset + chunk_size
    chunk_size = chunk_size >> 1
# write incomplete slice
if filein_size > 0:
    start = offset
    end = start + filein_size - 1
    for b in filein_data[start:end + 1]:
        fd_fileout.write(b.to_bytes(1, 'big'))
fd_fileout.close()

exit(0)

