#!/usr/bin/env tclsh

#
# SweetAda OpenOCD code download.
#
# Copyright (C) 2020, 2021 Gabriele Galeotti
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
# KERNEL_OUTFILE
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

set KERNEL_OUTFILE [file join $::env(SWEETADA_PATH) $::env(KERNEL_OUTFILE)]

# local OpenOCD server
openocd_rpc_init 127.0.0.1 6666

if {[lindex $argv 0] eq "-shutdown"} {
    openocd_rpc_tx "shutdown"
    exit 0
}

openocd_rpc_tx "reset halt"
openocd_rpc_rx
sleep 1000
openocd_rpc_tx "load_image $KERNEL_OUTFILE"
openocd_rpc_rx
openocd_rpc_tx "resume 0x01000000"
openocd_rpc_rx
sleep 1000

openocd_rpc_disconnect

exit 0

