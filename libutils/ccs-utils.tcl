
#
# CCS utilities.
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
# sleep for ms milliseconds                                                    #
################################################################################

proc sleep ms {
    after [expr {int($ms)}]
    return
}

################################################################################
# load a binary file                                                           #
# http://tmml.sourceforge.net/doc/tcl/scan.html                                #
# http://wiki.tcl.tk/1599                                                      #
################################################################################

proc loadbinaryfile {fname {channel stdout}} {
    if {![file exists $fname]} {
       puts stderr "*** Error: $fname not found."
       return
    }
    # open the file, and set up to process it in binary mode
    set f [open $fname r]
    fconfigure $f \
        -buffering full \
        -buffersize 16384 \
        -encoding binary \
        -translation binary
    while {true} {
        # record the seek address
        set offset [tell $f]
        # read 4 bytes from the file
        set s [read $f 4]
        # stop if we have reached end of file
        if {[string length $s] == 0} {
            break
        }
        # convert data to hex
        binary scan $s H* hex
        # convert to a value
        set value [scan $hex %x]
        # put hex data to the channel
        #puts $channel [format %08X $value] ;# disabled
        ccs::write_mem 0 $offset 4 0 $value
    }
    # when we are done, close the file
    close $f
    return
}

################################################################################
#                                                                              #
################################################################################

#for {set i 0} {$i < 10} {incr i} {
#    puts "writing"
#    ccs::write_mem 0 [expr $i * 4] 4 0 $i
#}

#for {set i 0} {$i < 10} {incr i} {
#    puts "reading"
#    ccs::display_mem 0 [expr $i * 4] 4 0 1
#}

################################################################################
#                                                                              #
################################################################################

set NetServerPort 41476

proc NetServer {port} {
    puts "NetServer port = $port."
    set s [socket -server NetServerAccept $port]
}

proc NetServerAccept {s address port} {
    global NetServerRecord
    # record client information
    puts "Accept $s from $address port $port."
    set NetServerRecord(address,$s) [list $address $port]
    # ensure that each "puts" by the server results in a network transmission
    fconfigure $s -buffering line
    # set up a callback for when the client sends data
    fileevent $s readable [list NetServerExec $s]
}

proc NetServerExec {s} {
    global NetServerRecord
    # execute command and check end of file or abnormal connection drop
    if {[eof $s] || [catch {gets $s line}]} {
        close $s
        #puts "Close $NetServerRecord(address,$s)."
        unset NetServerRecord(address,$s)
    } else {
        eval $line
    }
}

if {[info exists ::env(CCS_NETSERVER_PORT)]} {
    NetServer $::env(CCS_NETSERVER_PORT)
} else {
    NetServer $NetServerPort
}

