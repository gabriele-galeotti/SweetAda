
#
# SweetAda Python library.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# none
#
# Environment variables:
# none
#

################################################################################
#                                                                              #
################################################################################

import sys
# avoid generation of *.pyc
sys.dont_write_bytecode = True
import os
import time

################################################################################
# platform_get()                                                               #
#                                                                              #
################################################################################
def platform_get():
    name = os.name
    if   name == 'posix':
        return 'unix'
    elif name == 'nt':
        return 'windows'
    else:
        return ''

################################################################################
# platform_bigendian                                                           #
#                                                                              #
################################################################################
def platform_bigendian():
    if sys.byteorder == 'big':
        return True
    return False

################################################################################
# platform_littleendian                                                        #
#                                                                              #
################################################################################
def platform_littleendian():
    if sys.byteorder == 'little':
        return True
    return False

################################################################################
# msleep                                                                       #
#                                                                              #
# Sleep for ms milliseconds.                                                   #
################################################################################
def msleep(ms):
    time.sleep(ms / 1000)

################################################################################
# uXX_to_XXbytes()                                                             #
#                                                                              #
# Split a 16/32-bit number in a list of bytes.                                 #
################################################################################

def u16_to_bebytes(n):
    byte0 = (n // 0x100) % 0x100
    byte1 = n % 0x100
    return [byte0, byte1]

def u16_to_lebytes(n):
    byte0 = n % 0x100
    byte1 = (n // 0x100) % 0x100
    return [byte0, byte1]

def u32_to_bebytes(n):
    byte0 = (n // 0x1000000) % 0x100
    byte1 = (n // 0x10000) % 0x100
    byte2 = (n // 0x100) % 0x100
    byte3 = n % 0x100
    return [byte0, byte1, byte2, byte3]

def u32_to_lebytes(n):
    byte0 = n % 0x100
    byte1 = (n // 0x100) % 0x100
    byte2 = (n // 0x10000) % 0x100
    byte3 = (n // 0x1000000) % 0x100
    return [byte0, byte1, byte2, byte3]

