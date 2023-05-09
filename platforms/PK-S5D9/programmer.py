#!/usr/bin/env python3

#
# OpenOCD code download.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -c <OPENOCD_CFGFILE> OpenOCD configuration filename
# -debug               enable debug mode
# -e <ELFTOOL>         ELFTOOL executable to extract the start symbol
# -f <SWEETADA_ELF>    ELF executable to download via JTAG
# -p <OPENOCD_PREFIX>  OpenOCD installation prefix
# -s <START_SYMBOL>    start symbol ("_start") or start address if -e option not present
# -server              start OpenOCD server
# -shutdown            shutdown OpenOCD server
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

import subprocess
sys.path.append(os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('LIBUTILS_DIRECTORY')))
import library
import libopenocd

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

PLATFORM = library.platform_get()

OPENOCD_PREFIX  = None
OPENOCD_CFGFILE = None
DEBUG_MODE      = 0
SERVER_MODE     = 0
SHUTDOWN_MODE   = 0
SWEETADA_ELF    = None
ELFTOOL         = None
START_SYMBOL    = None

argc = len(sys.argv)
argv_idx = 1
while argv_idx < argc:
    if   sys.argv[argv_idx] == '-c':
        argv_idx += 1
        OPENOCD_CFGFILE = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-debug':
        DEBUG_MODE = 1
    elif sys.argv[argv_idx] == '-e':
        argv_idx += 1
        ELFTOOL = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-f':
        argv_idx += 1
        SWEETADA_ELF = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-p':
        argv_idx += 1
        OPENOCD_PREFIX = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-s':
        argv_idx += 1
        START_SYMBOL = sys.argv[argv_idx]
    elif sys.argv[argv_idx] == '-server':
        SERVER_MODE = 1
    elif sys.argv[argv_idx] == '-shutdown':
        SHUTDOWN_MODE = 1
    else:
        errprintf('%s: *** Error: unknown argument.\n', SCRIPT_FILENAME)
        exit(1)
    argv_idx += 1

if SHUTDOWN_MODE != 0:
    SERVER_MODE = 0

if SERVER_MODE != 0:
    if OPENOCD_PREFIX == None:
        errprintf('%s: *** Error: no OpenOCD prefix specified.\n', SCRIPT_FILENAME)
        exit(1)
    if   PLATFORM == 'windows':
        OPENOCD_EXECUTABLE = os.path.join(OPENOCD_PREFIX, 'bin', 'openocd.exe')
        try:
            os.system('cmd.exe /C START ' + OPENOCD_EXECUTABLE + ' -f ' + OPENOCD_CFGFILE)
        except:
            errprintf('%s: *** Error: system failure or OpenOCD executable not found.\n', SCRIPT_FILENAME)
            exit(1)
    elif PLATFORM == 'unix':
        OPENOCD_EXECUTABLE = os.path.join(OPENOCD_PREFIX, 'bin', 'openocd')
        try:
            os.system('xterm -e "' + OPENOCD_EXECUTABLE + ' -f ' + OPENOCD_CFGFILE + '" &')
        except:
            errprintf('%s: *** Error: system failure or OpenOCD executable not found.\n', SCRIPT_FILENAME)
            exit(1)
    else:
        errprintf('%s: *** Error: platform not recognized.\n', SCRIPT_FILENAME)
        exit(1)
    exit(0)

# local OpenOCD server
libopenocd.openocd_rpc_init('127.0.0.1', 6666)

if SHUTDOWN_MODE != 0:
    libopenocd.openocd_rpc_tx('shutdown')
    libopenocd.openocd_rpc_disconnect()
    exit(0)

if SWEETADA_ELF == None:
    errprintf('%s: *** Error: ELF file not specified.\n', SCRIPT_FILENAME)
    libopenocd.openocd_rpc_disconnect()
    exit(1)

if START_SYMBOL == None:
    errprintf('%s: *** Error: START symbol not specified.\n', SCRIPT_FILENAME)
    libopenocd.openocd_rpc_disconnect()
    exit(1)

if ELFTOOL != None:
    elftool_command = [ELFTOOL, '-c', 'findsymbol=' + START_SYMBOL, SWEETADA_ELF]
    result = subprocess.run(elftool_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
    # ARM Thumb functions have LSB = 1
    START_ADDRESS = '0x{:X}'.format(int(result, base=16) & 0xFFFFFFFE)
else:
    START_ADDRESS = START_SYMBOL
printf('START ADDRESS = %s\n', START_ADDRESS)

libopenocd.openocd_rpc_tx('reset halt')
libopenocd.openocd_rpc_rx('echo')
library.msleep(1000)
libopenocd.openocd_rpc_tx('load_image' + ' ' + SWEETADA_ELF)
libopenocd.openocd_rpc_rx('echo')
libopenocd.openocd_rpc_tx('resume' + ' ' + START_ADDRESS)
libopenocd.openocd_rpc_rx('echo')

libopenocd.openocd_rpc_disconnect()

exit(0)

