#!/usr/bin/env python3

#
# ELF download (dBUG download-network version).
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -p <serialport_device> serialport device
# -b <baud_rate>         serialport device baud rate
# -e <elftool>           ELFtool executable
# -f <kernel_filename>   ELF executable filename
# -s <entry_point>       ELF executable entry point symbol
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

import subprocess
import serial

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

################################################################################
# read_response()                                                              #
################################################################################
def read_response(fd, response):
    output = []
    while True:
        bytesread = fd.read()
        if len(bytesread) == 0:
            break
        for b in bytesread:
            # spinning indicator
            if b == 8:
                if len(output) > 0:
                    print(output[-1], end='')
                    sys.stdout.flush()
                    output.pop()
                print('\b', end='')
                sys.stdout.flush()
                continue
            output += chr(b)
            if output[-1] == '\n':
                print(''.join(output[:-1]))
                output = []
        if ''.join(output[-len(response):]) == response:
            break
    outputline = ''.join(output)
    return outputline

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

SERIALPORT_DEVICE = None
BAUD_RATE         = None
SWEETADA_ELF      = None
ELFTOOL           = None
START_SYMBOL      = None

argc = len(sys.argv)
argv_idx = 1
while argv_idx < argc:
    if   sys.argv[argv_idx] == '-b':
        argv_idx += 1
        BAUD_RATE = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-e':
        argv_idx += 1
        ELFTOOL = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-f':
        argv_idx += 1
        SWEETADA_ELF = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-p':
        argv_idx += 1
        SERIALPORT_DEVICE = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-s':
        argv_idx += 1
        START_SYMBOL = sys.argv[argv_idx]
    else:
        errprintf('%s: *** Error: unknown argument.\n', SCRIPT_FILENAME)
        exit(1)
    argv_idx += 1

if ELFTOOL != None:
    elftool_command = [ELFTOOL, '-c', 'findsymbol=' + START_SYMBOL, SWEETADA_ELF]
    try:
        result = subprocess.run(elftool_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
    except:
        errprintf('%s: *** Error: system failure or ELFTOOL executable not found.\n', SCRIPT_FILENAME)
        exit(1)
    START_ADDRESS = int(result, base=16)
    START_ADDRESS = '0x{:X}'.format(START_ADDRESS)
else:
    START_ADDRESS = START_SYMBOL

serialport_fd = serial.Serial()
serialport_fd.port         = SERIALPORT_DEVICE
serialport_fd.baudrate     = BAUD_RATE
serialport_fd.bytesize     = serial.EIGHTBITS           # 8N1
serialport_fd.parity       = serial.PARITY_NONE         # ''
serialport_fd.stopbits     = serial.STOPBITS_ONE        # ''
serialport_fd.timeout      = 5                          # timeout for read
serialport_fd.xonxoff      = True                       # XON/XOFF flow control
serialport_fd.rtscts       = False                      # hardware (RTS/CTS) flow control
serialport_fd.dsrdtr       = False                      # hardware (DSR/DTR) flow control
serialport_fd.writeTimeout = 0                          # timeout for write

try:
    serialport_fd.open()
except:
    errprintf('%s: *** Error: open().\n', SCRIPT_FILENAME)
    exit(1)
serialport_fd.flushInput()
serialport_fd.flushOutput()

# check for dBUG readiness
serialport_fd.write(str.encode('\n'))
if read_response(serialport_fd, 'dBUG> ').endswith('dBUG> ') == False:
    print('*** Error: no dBUG response.')
    serialport_fd.close()
    exit(1)

# download an ELF executable via TFTP
serialport_fd.write(str.encode('dn ' + os.path.basename(SWEETADA_ELF) + '\n'))
if read_response(serialport_fd, 'dBUG> ').endswith('dBUG> ') == False:
    print('*** Error: no dBUG response.')
    serialport_fd.close()
    exit(1)

# execute
print('Executing "go ' + START_ADDRESS + '"')
serialport_fd.write(str.encode('go ' + START_ADDRESS + '\n'))

serialport_fd.close()

exit(0)

