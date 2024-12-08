
#
# SweetAda OpenOCD Python library.
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
import socket
import library

################################################################################
# openocd_rpc_set_socket                                                       #
#                                                                              #
################################################################################
def openocd_rpc_set_socket(s):
    global openocd_rpc_socket
    openocd_rpc_socket = s

################################################################################
# openocd_rpc_get_socket                                                       #
#                                                                              #
################################################################################
def openocd_rpc_get_socket():
    return openocd_rpc_socket

################################################################################
# openocd_rpc_disconnect                                                       #
#                                                                              #
################################################################################
def openocd_rpc_disconnect():
    s = openocd_rpc_get_socket()
    s.close()

################################################################################
# openocd_rpc_rx                                                               #
#                                                                              #
# "noecho" disables output of received data messages output.                   #
################################################################################
def openocd_rpc_rx(mode='noecho'):
    s = openocd_rpc_get_socket()
    while True:
        data = s.recv(4096)
        if len(data) > 0:
            c = 0x1A
            if data[-1] == c:
                # end of response, exit
                if mode == 'echo':
                    sys.stdout.write(data[:-1].decode('utf-8'))
                break
            else:
                # continue reading
                if mode == 'echo':
                    sys.stdout.write(data.decode('utf-8'))
    return data

################################################################################
# openocd_rpc_tx                                                               #
#                                                                              #
################################################################################
def openocd_rpc_tx(command):
    s = openocd_rpc_get_socket()
    s.sendall(command.encode('utf-8'))
    s.sendall(b'\x1A')

################################################################################
# openocd_rpc_init                                                             #
#                                                                              #
################################################################################
def openocd_rpc_init(server='127.0.0.1', port=6666):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    openocd_rpc_set_socket(s)
    s.connect((server, port))

