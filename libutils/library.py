
#
# SweetAda Python library.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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

################################################################################
# is_python3()                                                                 #
#                                                                              #
################################################################################
def is_python3():
    if sys.version_info > (3, 0):
        return True
    return False

################################################################################
# uXX_to_XXbytes()                                                             #
#                                                                              #
# Split a 16/32-bit number in a list of bytes.                                 #
################################################################################

def u16_to_bebytes(n):
    byte0 = (n / 0x100) % 0x100
    byte1 = n % 0x100
    return [byte0, byte1]

def u16_to_lebytes(n):
    byte0 = n % 0x100
    byte1 = (n / 0x100) % 0x100
    return [byte0, byte1]

def u32_to_bebytes(n):
    byte0 = (n / 0x1000000) % 0x100
    byte1 = (n / 0x10000) % 0x100
    byte2 = (n / 0x100) % 0x100
    byte3 = n % 0x100
    return [byte0, byte1, byte2, byte3]

def u32_to_lebytes(n):
    byte0 = n % 0x100
    byte1 = (n / 0x100) % 0x100
    byte2 = (n / 0x10000) % 0x100
    byte3 = (n / 0x1000000) % 0x100
    return [byte0, byte1, byte2, byte3]

