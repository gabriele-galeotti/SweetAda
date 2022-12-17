
#
# SweetAda OpenOCD Tcl library.
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
# openocd_rpc_set_socket                                                       #
#                                                                              #
################################################################################
proc openocd_rpc_set_socket {s} {
    global openocd_rpc_socket
    set openocd_rpc_socket $s
}

################################################################################
# openocd_rpc_get_socket                                                       #
#                                                                              #
################################################################################
proc openocd_rpc_get_socket {} {
    global openocd_rpc_socket
    return $openocd_rpc_socket
}

################################################################################
# openocd_rpc_disconnect                                                       #
#                                                                              #
################################################################################
proc openocd_rpc_disconnect {} {
    set s [openocd_rpc_get_socket]
    close $s
}

################################################################################
# openocd_rpc_rx                                                               #
#                                                                              #
# "noecho" disables output of received data messages output.                   #
################################################################################
proc openocd_rpc_rx {{mode ""}} {
    set s [openocd_rpc_get_socket]
    while {true} {
        set data [read $s 4096]
        if {[eof $s]} {
            openocd_rpc_disconnect
            return
        }
        if {[llength $data] > 0} {
            set token [string first \x1A $data]
            if {$token ne -1} {
                # end of response, print and exit
                set outdata [string range $data 0 [expr {$token - 1}]]
                if {$mode ne "noecho"} {
                    puts -nonewline stdout $outdata
                }
                break
            } else {
                # print and continue reading
                set outdata $data
                if {$mode ne "noecho"} {
                    puts -nonewline stdout $outdata
                }
            }
        }
    }
    return $outdata
}

################################################################################
# openocd_rpc_tx                                                               #
#                                                                              #
################################################################################
proc openocd_rpc_tx {command} {
    set s [openocd_rpc_get_socket]
    puts -nonewline $s $command\x1A
}

################################################################################
# openocd_rpc_init                                                             #
#                                                                              #
################################################################################
proc openocd_rpc_init {{server 127.0.0.1} {port 6666}} {
    set s [socket $server $port]
    openocd_rpc_set_socket $s
    fconfigure $s \
        -blocking false \
        -buffering none \
        -encoding binary \
        -eofchar {}
    fconfigure stdout \
        -buffering none
}

