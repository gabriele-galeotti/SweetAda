#!/usr/bin/env python

#
# Intel(R) Quartus design file parser.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = QSYS design full qualified filename path
# $2 = Ada package name
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
import xml.etree.ElementTree as ET

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

qsys_filename = sys.argv[1]
package_name = sys.argv[2]
end_list = []
for el in sys.argv[3:]:
    end_list.append(el + '.s1')

ads_filename = package_name.lower() + '.ads'

fdout = open(ads_filename, 'wb')
sys.stdout = fdout

print('package {} is').format(package_name)
print('   pragma Pure;')

tree = ET.parse(qsys_filename)
root = tree.getroot()
for connection in root.findall('connection'):
    end = connection.get('end')
    if end in end_list:
        end = end.replace('.s1', '_s1')
        for parameter in connection.findall('parameter'):
            name = parameter.get('name')
            if name == 'baseAddress':
                address = parameter.get('value').replace('0x', '')
                address = address[:4] + '_' + address[4:]
                print('   {}_ADDRESS : constant := 16#{}#;'.format(end, address))
                break

print('end {};').format(package_name)

fdout.close()

exit(0)

