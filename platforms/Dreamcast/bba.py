#!/usr/bin/env python3

#
# Download and run a SweetAda executable through a Dreamcast BBA adapter.
#
# Copyright (C) 2020-2025 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# ELFTOOL
# KERNEL_OUTFILE
# KERNEL_ROMFILE
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
sys.path.append(os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('LIBUTILS_DIRECTORY')))
import library
import socket

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

################################################################################
# send_command                                                                 #
#                                                                              #
################################################################################
def send_command(s, command, address, size, data):
    buffer = bytearray(command.encode('utf-8'))
    for b in library.u32_to_bebytes(address):
        buffer.append(b)
    for b in library.u32_to_bebytes(size):
        buffer.append(b)
    for b in data:
        buffer.append(b)
    #printf("sending %d bytes\n", len(buffer))
    s.send(buffer)

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

ELFTOOL              = os.getenv('ELFTOOL')
KERNEL_OUTFILE       = os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('KERNEL_OUTFILE'))
KERNEL_ROMFILE       = os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('KERNEL_ROMFILE'))
START_SYMBOL         = '_start'
HOST_IP_ADDRESS      = '192.168.2.1'
DREAMCAST_IP_ADDRESS = '192.168.2.2'
DREAMCAST_UDP_PORT   = 31313
BBA_MAC_ADDRESS      = '00:d0:f1:02:bc:5d'

CMD_EXECUTE  = 'EXEC' # execute
CMD_LOADBIN  = 'LBIN' # begin receiving binary
CMD_PARTBIN  = 'PBIN' # part of a binary
CMD_DONEBIN  = 'DBIN' # end receiving binary
CMD_SENDBIN  = 'SBIN' # send a binary
CMD_SENDBINQ = 'SBIQ' # send a binary, quiet
CMD_VERSION  = 'VERS' # send version info
CMD_RETVAL   = 'RETV' # return value
CMD_REBOOT   = 'RBOT' # reboot

# load address
elftool_command = [ELFTOOL, '-c', 'sectionvaddr=.text', KERNEL_OUTFILE]
try:
    result = subprocess.run(elftool_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
    LOAD_ADDRESS = int(result, base=16)
except:
    errprintf('%s: *** Error: no "' + KERNEL_OUTFILE + '" file available or no section ".text".\n', SCRIPT_FILENAME)
    exit(1)

# start address
elftool_command = [ELFTOOL, '-c', 'findsymbol=' + START_SYMBOL, KERNEL_OUTFILE]
try:
    result = subprocess.run(elftool_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
    START_ADDRESS = int(result, base=16)
except:
    errprintf('%s: *** Error: no "' + KERNEL_OUTFILE + '" file available or no symbol "' + START_SYMBOL + '".\n', SCRIPT_FILENAME)
    exit(1)

# setup network connection
ifconfig_command = ['ifconfig', '-v', 'eth0', HOST_IP_ADDRESS]
try:
    result = subprocess.run(ifconfig_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
except:
    errprintf('%s: *** Error: ifconfig failed.\n', SCRIPT_FILENAME)
    exit(1)
arp_command = ['arp', '-s', DREAMCAST_IP_ADDRESS, BBA_MAC_ADDRESS]
try:
    result = subprocess.run(arp_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
except:
    errprintf('%s: *** Error: arp failed.\n', SCRIPT_FILENAME)
    exit(1)

# create UDP socket
s = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
s.connect((DREAMCAST_IP_ADDRESS, DREAMCAST_UDP_PORT))

# open files
fd = open(KERNEL_ROMFILE, 'rb')

# upload a binary file
send_command(s, CMD_LOADBIN, LOAD_ADDRESS, os.stat(KERNEL_ROMFILE).st_size, [])
recv_data, address = s.recvfrom(4096)
if len(recv_data) == 0:
    errprintf('%s: *** Error: CMD_LOADBIN error.\n', SCRIPT_FILENAME)
    s.close()
    exit(1)
if recv_data[0:3] == bytearray(CMD_LOADBIN.encode('utf-8'))[0:3]:
    printf('CMD_LOADBIN @%x OK.\n', LOAD_ADDRESS)
else:
    errprintf('%s: *** Error: CMD_LOADBIN error.\n', SCRIPT_FILENAME)
    s.close()
    exit(1)

# send the binary file in chunks with size 1kB
chunk_length = 1024
sequence = 1
printf('sending ')
sys.stdout.flush()
while True:
    data = fd.read(chunk_length)
    data_length = len(data)
    if data_length < 1:
        break
    send_command(s, CMD_PARTBIN, LOAD_ADDRESS, data_length, data)
    printf('.')
    sys.stdout.flush()
    if data_length < chunk_length:
        break
    LOAD_ADDRESS = LOAD_ADDRESS + data_length
    sequence += 1
    library.msleep(30)
printf('\n')

# close the binary file
fd.close()

# upload done
send_command(s, CMD_DONEBIN, 0, 0, [])
recv_data, address = s.recvfrom(4096)
if len(recv_data) == 0:
    errprintf('%s: *** Error: CMD_DONEBIN error.\n', SCRIPT_FILENAME)
    s.close()
    exit(1)
if recv_data[0:3] == bytearray(CMD_DONEBIN.encode('utf-8'))[0:3]:
    printf('CMD_DONEBIN OK.\n')
else:
    errprintf('%s: *** Error: CMD_DONEBIN error.\n', SCRIPT_FILENAME)
    s.close()
    exit(1)

# execute
send_command(s, CMD_EXECUTE, START_ADDRESS, 0, [])
recv_data, address = s.recvfrom(4096)
if len(recv_data) == 0:
    errprintf('%s: *** Error: CMD_EXECUTE error.\n', SCRIPT_FILENAME)
    s.close()
    exit(1)
if recv_data[0:3] == bytearray(CMD_EXECUTE.encode('utf-8'))[0:3]:
    printf('CMD_EXECUTE @%x OK.\n', START_ADDRESS)
else:
    errprintf('%s: *** Error: CMD_EXECUTE error.\n', SCRIPT_FILENAME)
    s.close()
    exit(1)

# close UDP socket
s.close()

exit(0)

