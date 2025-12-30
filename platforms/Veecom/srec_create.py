#!/usr/bin/env python3

#
# Logisim S-record creation.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = input filename
# $2 = optional output filename
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
# Main loop.                                                                   #
#                                                                              #
################################################################################

input_filename = None
output_filename = None

# process arguments
argc = len(sys.argv)
argv_idx = 1
while argv_idx < argc:
    if   input_filename == None:
        input_filename = sys.argv[argv_idx]
    elif output_filename == None:
        output_filename = sys.argv[argv_idx]
    else:
        break
    argv_idx += 1

# check parameters
if input_filename == None:
    errprintf('%s: *** Error: no input filename supplied.\n', SCRIPT_FILENAME)
    exit(1)
if output_filename == None:
    output_filename = input_filename + '.srec'

# read the input binary object
fd_input = open(input_filename, 'rb')
data = fd_input.read(-1)
fd_input.close()

datalength = len(data)

# create the output object
fd_output = open(output_filename, 'wb')
fd_output.write(b'v2.0 raw\n')
count = 0
for i in range(0, datalength):
    if count == 0:
        fd_output.write(b'\n')
    else:
        fd_output.write(b' ')
    fd_output.write('{:02X}'.format(data[i]).encode('UTF-8'))
    count += 1
    if count == 32:
       count = 0
fd_output.write(b'\n')
fd_output.close()

exit(0)

