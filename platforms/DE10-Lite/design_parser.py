#!/usr/bin/env python3

#
# Intel(R) Quartus design file parser.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = QSYS design fully qualified file name
# $2 = Ada package name
# $3 = module name
# $4 = module name
# ...
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

if len(sys.argv) < 4:
    errprintf('%s: *** Error: wrong number of arguments.\n', SCRIPT_FILENAME)
    exit(1)

qsys_filename = sys.argv[1]
package_name = sys.argv[2]
end_list = []
for el in sys.argv[3:]:
    end_list.append(el)

ads_filename = package_name.lower() + '.ads'

fdout = open(ads_filename, 'w')
sys.stdout = fdout

indent = '   '

print('')
print('package {0:s}'.format(package_name))
print(indent + 'with Pure => True')
print(indent + 'is')
print('')

items = []
max_name_length = 0
tree = ET.parse(qsys_filename)
root = tree.getroot()
for connection in root.findall('connection'):
    end = connection.get('end')
    if end in end_list:
        end = end.replace('.', '_')
        for parameter in connection.findall('parameter'):
            name = parameter.get('name')
            if name == 'baseAddress':
                address = parameter.get('value').replace('0x', '')
                address = '{0:s}_{1:s}'.format(address[:4], address[4:])
                items.append({
                   'name'    : end,
                   'address' : address
                   })
                l = len(end)
                if l > max_name_length:
                    max_name_length = l
                break
for i in items:
    padstring = ' ' * (max_name_length - len(i['name']))
    print(indent + '{0:s}_ADDRESS {1:s}: constant := 16#{2:s}#;'.format(i['name'], padstring, i['address']))
if len(items) > 0:
    print('')

print('end {0:s};'.format(package_name))

fdout.close()

exit(0)

