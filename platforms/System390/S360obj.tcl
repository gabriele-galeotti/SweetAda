#!/usr/bin/env tclsh

#
# Create a minimal S/360 object file suitable to be IPLed.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# [-a hex_address] [-l loader] [-p] <input_filename> <output_filename>
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

#
# ASCII (IBM® PC 437) -> EBCDIC 037
#
set ASCII2EBCDIC {}
# 00                  NUL  SOH  STX  ETX  EOT  ENQ  ACK  BEL
lappend ASCII2EBCDIC 0x00 0x01 0x02 0x03 0x37 0x2D 0x2E 0x2F
# 08                   BS   HT   LF   VT   FF   CR   SO   SI
lappend ASCII2EBCDIC 0x16 0x05 0x15 0x0B 0x0C 0x0D 0x0E 0x0F
# 10                  DLE  DC1  DC2  DC3  DC4  NAK  SYN  ETB
lappend ASCII2EBCDIC 0x10 0x11 0x12 0x13 0x3C 0x3D 0x32 0x26
# 18                  CAN   EM  SUB  ESC   FS   GS   RS   US
lappend ASCII2EBCDIC 0x18 0x19 0x3F 0x27 0x22 0x1D 0x1E 0x1F
# 20                   SP    !    "    #    $    %    &    '
lappend ASCII2EBCDIC 0x40 0x5A 0x7F 0x7B 0x5B 0x6C 0x50 0x7D
# 28                    (    )    *    +    ,    -   .     /
lappend ASCII2EBCDIC 0x4D 0x5D 0x5C 0x4E 0x6B 0x60 0x4B 0x61
# 30                    0    1    2    3    4    5    6    7
lappend ASCII2EBCDIC 0xF0 0xF1 0xF2 0xF3 0xF4 0xF5 0xF6 0xF7
# 38                    8    9    :    ;    <    =    >    ?
lappend ASCII2EBCDIC 0xF8 0xF9 0x7A 0x5E 0x4C 0x7E 0x6E 0x6F
# 40                    @    A    B    C    D    E    F    G
lappend ASCII2EBCDIC 0x7C 0xC1 0xC2 0xC3 0xC4 0xC5 0xC6 0xC7
# 48                    H    I    J    K    L    M    N    O
lappend ASCII2EBCDIC 0xC8 0xC9 0xD1 0xD2 0xD3 0xD4 0xD5 0xD6
# 50                    P    Q    R    S    T    U    V    W
lappend ASCII2EBCDIC 0xD7 0xD8 0xD9 0xE2 0xE3 0xE4 0xE5 0xE6
# 58                    X    Y    Z    [    \    ]    ^    _
lappend ASCII2EBCDIC 0xE7 0xE8 0xE9 0xBA 0xE0 0xBB 0xB0 0x6D
# 60                    `    a    b    c    d    e    f    g
lappend ASCII2EBCDIC 0x79 0x81 0x82 0x83 0x84 0x85 0x86 0x87
# 68                    h    i    j    k    l    m    n    o
lappend ASCII2EBCDIC 0x88 0x89 0x91 0x92 0x93 0x94 0x95 0x96
# 70                    p    q    r    s    t    u    v    w
lappend ASCII2EBCDIC 0x97 0x98 0x99 0xA2 0xA3 0xA4 0xA5 0xA6
# 78                    x    y    z    {    |    }    ~  DEL
lappend ASCII2EBCDIC 0xA7 0xA8 0xA9 0xC0 0x4F 0xD0 0xA1 0x07
# 80
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# 88
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# 90
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# 98
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# A0
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# A8
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# B0
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# B8
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# C0
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# C8
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# D0
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# D8
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# E0
lappend ASCII2EBCDIC 0x3F 0x59 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# E8
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# F0
lappend ASCII2EBCDIC 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F 0x3F
# F8
lappend ASCII2EBCDIC 0x90 0x3F 0x3F 0x3F 0x3F 0xEA 0x3F 0xFF

set EBCDIC_SPACE 0x40

################################################################################
# a2e                                                                          #
#                                                                              #
# ASCII character --> EBCDIC character value                                   #
################################################################################
proc a2e {c} {
    global ASCII2EBCDIC
    return [lindex $ASCII2EBCDIC [scan $c %c]]
}

################################################################################
# s2e                                                                          #
#                                                                              #
# ASCII string --> list of EBCDIC character values                             #
################################################################################
proc s2e {s} {
    set splits [split $s ""]
    set es {}
    foreach c $splits {
        lappend es [a2e $c]
    }
    return $es
}

################################################################################
# write_esd_record                                                             #
#                                                                              #
################################################################################
proc write_esd_record {fd sequence address length} {
    global EBCDIC_SPACE
    set address_bytes [u32_to_bebytes $address]
    set nmodules 1
    set size_bytes [u16_to_bebytes [expr $nmodules * 16]]
    puts -nonewline $fd [binary format c1 0x02]                         ;# 01 constant
    puts -nonewline $fd [binary format c1 [a2e "E"]]                    ;# 02 EBCDIC "E"
    puts -nonewline $fd [binary format c1 [a2e "S"]]                    ;# 03 EBCDIC "S"
    puts -nonewline $fd [binary format c1 [a2e "D"]]                    ;# 04 EBCDIC "D"
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 05 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 06 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 07 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 08 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 09 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 10 unused
    puts -nonewline $fd [binary format c1 [lindex $size_bytes 0]]       ;# 11 # of bytes, H
    puts -nonewline $fd [binary format c1 [lindex $size_bytes 1]]       ;# 12 # of bytes, L
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 13 flag bits
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 14 flag bits
    puts -nonewline $fd [binary format c1 0x00]                         ;# 15 ESDID = 1
    puts -nonewline $fd [binary format c1 0x01]                         ;# 16 ESDID = 1
    # 1st module, 16 bytes
    for {set p 0} {$p < 8} {incr p} {                                   ;# 1..8 name
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    puts -nonewline $fd [binary format c1 0x04]                         ;# 9    type = PC
    puts -nonewline $fd [binary format c1 [lindex $address_bytes 1]]    ;# 10   module starting address, byte N
    puts -nonewline $fd [binary format c1 [lindex $address_bytes 2]]    ;# 11   module starting address, byte M
    puts -nonewline $fd [binary format c1 [lindex $address_bytes 3]]    ;# 12   module starting address, byte L
    puts -nonewline $fd [binary format c1 0x00]                         ;# 13   flag
    set length_bytes [u32_to_bebytes $length]
    puts -nonewline $fd [binary format c1 [lindex $length_bytes 1]]     ;# 14   binary length (PC), byte N
    puts -nonewline $fd [binary format c1 [lindex $length_bytes 2]]     ;# 15   binary length (PC), byte M
    puts -nonewline $fd [binary format c1 [lindex $length_bytes 3]]     ;# 16   binary length (PC), byte L
    # 2nd module, 16 bytes, none
    for {set p 0} {$p < 16} {incr p} {
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    # 3rd module, 16 bytes, none
    for {set p 0} {$p < 16} {incr p} {
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    for {set p 0} {$p < 8} {incr p} {                                   ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    set seqc [format "%08d" $sequence]                                  ;# 73 deck ID or sequence number
    foreach c [s2e $seqc] {
        puts -nonewline $fd [binary format c1 $c]
    }
}

################################################################################
# write_txt_record                                                             #
#                                                                              #
################################################################################
proc write_txt_record {fd sequence address data} {
    global EBCDIC_SPACE
    set address_bytes [u32_to_bebytes $address]
    set size_bytes [u16_to_bebytes [llength $data]]
    puts -nonewline $fd [binary format c1 0x02]                         ;# 01 constant
    puts -nonewline $fd [binary format c1 [a2e "T"]]                    ;# 02 EBCDIC "T"
    puts -nonewline $fd [binary format c1 [a2e "X"]]                    ;# 03 EBCDIC "X"
    puts -nonewline $fd [binary format c1 [a2e "T"]]                    ;# 04 EBCDIC "T"
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 05 unused
    puts -nonewline $fd [binary format c1 [lindex $address_bytes 1]]    ;# 06 address of 1st byte, byte N
    puts -nonewline $fd [binary format c1 [lindex $address_bytes 2]]    ;# 07 address of 1st byte, byte M
    puts -nonewline $fd [binary format c1 [lindex $address_bytes 3]]    ;# 08 address of 1st byte, byte L
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 09 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 10 unused
    puts -nonewline $fd [binary format c1 [lindex $size_bytes 0]]       ;# 11 # of bytes, H
    puts -nonewline $fd [binary format c1 [lindex $size_bytes 1]]       ;# 12 # of bytes, L
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 13 unused
    puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]                ;# 14 unused
    puts -nonewline $fd [binary format c1 0x00]                         ;# 15 ESDID = 1
    puts -nonewline $fd [binary format c1 0x01]                         ;# 16 ESDID = 1
    foreach byte $data {                                                ;# 17 56 bytes of data
        puts -nonewline $fd [binary format c1 $byte]
    }
    for {set p [llength $data]} {$p < 56} {incr p} {                    ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    set seqc [format "%08d" $sequence]                                  ;# 73 deck ID or sequence number
    foreach c [s2e $seqc] {
        puts -nonewline $fd [binary format c1 $c]
    }
}

################################################################################
# write_rld_record                                                             #
#                                                                              #
################################################################################
proc write_rld_record {fd sequence} {
    global EBCDIC_SPACE
    puts -nonewline $fd [binary format c1 0x02]                         ;# 01 constant
    puts -nonewline $fd [binary format c1 [a2e "R"]]                    ;# 02 EBCDIC "R"
    puts -nonewline $fd [binary format c1 [a2e "L"]]                    ;# 03 EBCDIC "L"
    puts -nonewline $fd [binary format c1 [a2e "D"]]                    ;# 04 EBCDIC "D"
    for {set p 4} {$p < 72} {incr p} {                                  ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    set seqc [format "%08d" $sequence]                                  ;# 73 deck ID or sequence number
    foreach c [s2e $seqc] {
        puts -nonewline $fd [binary format c1 $c]
    }
}

################################################################################
# write_sym_record                                                             #
#                                                                              #
################################################################################
proc write_rld_record {fd sequence} {
    global EBCDIC_SPACE
    puts -nonewline $fd [binary format c1 0x02]                         ;# 01 constant
    puts -nonewline $fd [binary format c1 [a2e "S"]]                    ;# 02 EBCDIC "S"
    puts -nonewline $fd [binary format c1 [a2e "Y"]]                    ;# 03 EBCDIC "Y"
    puts -nonewline $fd [binary format c1 [a2e "M"]]                    ;# 04 EBCDIC "M"
    for {set p 4} {$p < 72} {incr p} {                                  ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    set seqc [format "%08d" $sequence]                                  ;# 73 deck ID or sequence number
    foreach c [s2e $seqc] {
        puts -nonewline $fd [binary format c1 $c]
    }
}

################################################################################
# write_xsd_record                                                             #
#                                                                              #
################################################################################
proc write_xsd_record {fd sequence} {
    global EBCDIC_SPACE
    puts -nonewline $fd [binary format c1 0x02]                         ;# 01 constant
    puts -nonewline $fd [binary format c1 [a2e "X"]]                    ;# 02 EBCDIC "X"
    puts -nonewline $fd [binary format c1 [a2e "S"]]                    ;# 03 EBCDIC "S"
    puts -nonewline $fd [binary format c1 [a2e "D"]]                    ;# 04 EBCDIC "D"
    for {set p 4} {$p < 72} {incr p} {                                  ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    set seqc [format "%08d" $sequence]                                  ;# 73 deck ID or sequence number
    foreach c [s2e $seqc] {
        puts -nonewline $fd [binary format c1 $c]
    }
}

################################################################################
# write_end_record                                                             #
#                                                                              #
################################################################################
proc write_end_record {fd sequence} {
    global EBCDIC_SPACE
    puts -nonewline $fd [binary format c1 0x02]                         ;# 01 constant
    puts -nonewline $fd [binary format c1 [a2e "E"]]                    ;# 02 EBCDIC "E"
    puts -nonewline $fd [binary format c1 [a2e "N"]]                    ;# 03 EBCDIC "N"
    puts -nonewline $fd [binary format c1 [a2e "D"]]                    ;# 04 EBCDIC "D"
    for {set p 4} {$p < 16} {incr p} {                                  ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    puts -nonewline $fd [binary format c1 [a2e "S"]]                    ;# 17 EBCDIC "S"
    puts -nonewline $fd [binary format c1 [a2e "w"]]                    ;# 18 EBCDIC "w"
    puts -nonewline $fd [binary format c1 [a2e "e"]]                    ;# 19 EBCDIC "e"
    puts -nonewline $fd [binary format c1 [a2e "e"]]                    ;# 20 EBCDIC "e"
    puts -nonewline $fd [binary format c1 [a2e "t"]]                    ;# 21 EBCDIC "t"
    puts -nonewline $fd [binary format c1 [a2e "A"]]                    ;# 22 EBCDIC "A"
    puts -nonewline $fd [binary format c1 [a2e "d"]]                    ;# 23 EBCDIC "d"
    puts -nonewline $fd [binary format c1 [a2e "a"]]                    ;# 24 EBCDIC "a"
    for {set p 24} {$p < 32} {incr p} {                                 ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    puts -nonewline $fd [binary format c1 [a2e "2"]]                    ;# 33 EBCDIC "2"
    for {set p 33} {$p < 72} {incr p} {                                 ;# pad with blanks
        puts -nonewline $fd [binary format c1 $EBCDIC_SPACE]
    }
    set seqc [format "%08d" $sequence]                                  ;# 73 deck ID or sequence number
    foreach c [s2e $seqc] {
        puts -nonewline $fd [binary format c1 $c]
    }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

set address 0x18
set write_psw false
set loader_filename ""
set input_filename ""
set output_filename ""

# process argv
set argc_counter [llength $argv]
set argc_index 0
while {true} {
    if {$argc_index eq $argc_counter} {
        break
    }
    set arg [lindex $argv $argc_index]
    if {$arg eq "-a"} {
        incr argc_index
        set address [lindex $argv $argc_index]
    } elseif {$arg eq "-l"} {
        incr argc_index
        set loader_filename [lindex $argv $argc_index]
    } elseif {$arg eq "-p"} {
        set write_psw true
    } else {
        if {$input_filename eq ""} {
            set input_filename [lindex $argv $argc_index]
        } elseif {$output_filename eq ""} {
            set output_filename [lindex $argv $argc_index]
        }
    }
    incr argc_index
}

if {($input_filename eq "") || ($output_filename eq "")} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set fd_output [open $output_filename w]
fconfigure $fd_output -encoding binary -translation binary

# prepend the loader
if {$loader_filename ne ""} {
    set fd_loader [open $loader_filename r]
    fconfigure $fd_loader -encoding binary -translation binary
    while {true} {
        set loader_data [read $fd_loader 256]
        set data_length [string length $loader_data]
        puts -nonewline $fd_output $loader_data
        if {$data_length ne 256} {
            break
        }
    }
    close $fd_loader
}

set fd_input [open $input_filename r]
fconfigure $fd_input -encoding binary -translation binary

# initialize sequence number
set sequence 1

# 1) create an ESD record
write_esd_record $fd_output $sequence $address [file size $input_filename]
incr sequence

# 2)
# create TXT record which contains PSW @ 0
# create S/390 31-bit PSW
if {$write_psw} {
    set address_bytes [u32_to_bebytes [expr $address | 0x80000000]]
    set psw {}
    lappend psw 0x00 0x0C 0x00 0x00
    lappend psw [lindex $address_bytes 0] \
                [lindex $address_bytes 1] \
                [lindex $address_bytes 2] \
                [lindex $address_bytes 3]
    # create TXT record @ address 0
    write_txt_record $fd_output $sequence 0 $psw
    incr sequence
}

# 3)
# create TXT data records from data
while {true} {
    set data [read $fd_input 56]
    set data_length [string length $data]
    if {$data_length > 0} {
        set splitdata [split $data ""]
        set hexdata {}
        foreach byte $splitdata {
            lappend hexdata [scan $byte %c]
        }
        write_txt_record $fd_output $sequence $address $hexdata
        set address [expr $address + $data_length]
        incr sequence
    }
    if {$data_length < 56} {
        break
    }
}

# 4)
# create END record
write_end_record $fd_output $sequence
# write out number of records written
puts stdout "$SCRIPT_FILENAME: number of records written: $sequence"
incr sequence

close $fd_input
close $fd_output

exit 0

