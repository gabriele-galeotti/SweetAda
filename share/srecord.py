#!/usr/bin/env python

#
# S-record download.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = KERNEL_SRECFILE
# $2 = SERIALPORT_DEVICE
# $3 = BAUD_RATE
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

SCRIPT_FILENAME = sys.argv[0]

################################################################################
#                                                                              #
################################################################################

import time
import serial

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

kernel_srecfile = sys.argv[1]
serialport_device = sys.argv[2]
baud_rate = sys.argv[3]

serialport_fd = serial.Serial()
serialport_fd.port         = serialport_device
serialport_fd.baudrate     = baud_rate
serialport_fd.bytesize     = serial.EIGHTBITS
serialport_fd.parity       = serial.PARITY_NONE
serialport_fd.stopbits     = serial.STOPBITS_ONE
serialport_fd.timeout      = None
serialport_fd.xonxoff      = False
serialport_fd.rtscts       = False                 # disable hardware (RTS/CTS) flow control
serialport_fd.dsrdtr       = False                 # disable hardware (DSR/DTR) flow control
#serialport_fd.writeTimeout = 0                     # timeout for write

try:
    serialport_fd.open()
except:
    errprintf('%s: *** Error: open().\n', SCRIPT_FILENAME)
    exit(1)
if serialport_fd.isOpen():
    # delay for processing of data on remote side
    if   baud_rate == 115200:
        delay = 10
    elif baud_rate == 38400:
        delay = 30
    else:
        delay = 50
    # flush input buffer, discarding all its contents
    serialport_fd.flushInput()
    # flush output buffer, aborting current output
    serialport_fd.flushOutput()
    kernel_fd = open(kernel_srecfile, 'r')
    srecs = kernel_fd.readlines()
    kernel_fd.close()
    for srec in srecs:
        serialport_fd.write(str.encode(srec).strip())
        serialport_fd.write(str.encode('\r\n'))
        errprintf('.')
        time.sleep(delay / 1000)
        srec_type = srec[0:2]
        if   srec_type == 'S7':
            start_address = srec[4:12]
        elif srec_type == 'S8':
            start_address = srec[4:10]
        elif srec_type == 'S9':
            start_address = srec[4:8]
    serialport_fd.write(str.encode('\r\n'))
    errprintf('\n')
    serialport_fd.close()
else:
    errprintf('%s: *** Error: open().\n', SCRIPT_FILENAME)
    exit(1)

exit(0)

