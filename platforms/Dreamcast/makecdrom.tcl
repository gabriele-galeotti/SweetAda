#!/usr/bin/env tclsh

#
# Generate files to create a Dreamcast CD-ROM.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = template filename (IP.TMPL)
# $2 = input filename (IP.TXT)
# $3 = kernel filename
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
# crc16                                                                        #
#                                                                              #
################################################################################
proc crc16 {data offset length} {
    set data_list [split $data ""]
    set crc 0xFFFF
    for {set i $offset} {$i < [expr $offset + $length]} {incr i} {
        set c [lindex $data_list $i]
        set hexvalue 0
        binary scan $c H2 hexvalue
        set crc [expr $crc ^ (0x$hexvalue << 8)]
        for {set n 0} {$n < 8} {incr n} {
            if {[expr $crc & 0x8000] ne 0} {
                set crc [expr ($crc << 1) ^ 0x1021]
            } else {
                set crc [expr $crc << 1]
            }
        }
        set crc [expr $crc & 0xFFFF]
    }
    return $crc
}

################################################################################
# randomize                                                                    #
#                                                                              #
################################################################################
proc randomize {} {
    global seed
    set seed [expr ($seed * 2109 + 9273) & 0x7FFF]
    return [expr ($seed + 0xC000) & 0xFFFF]
}

################################################################################
# save_chunk                                                                   #
#                                                                              #
################################################################################
proc save_chunk {fp data offset size} {
    set size [expr $size / 32]
    set table {}
    for {set i 0} {$i < $size} {incr i} {
        lappend table $i
    }
    for {set i [expr $size - 1]} {$i >= 0} {incr i -1} {
        set x [expr ([randomize] * $i) >> 16]
        # swap
        set tmp [lindex $table $i]
        lset table $i [lindex $table $x]
        lset table $x $tmp
        # write a 32-byte chunk
        set start [expr $offset + 32 * [lindex $table $i]]
        set end [expr $start + 32 - 1]
        puts -nonewline $fp [string range $data $start $end]
    }
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

#
# 1st part: generate IP.BIN suitable to be stored in a CD-ROM.
#
# Input:
# - template filename (IP.TMPL)
# - input filename (IP.TXT)
# Output:
# - IP.BIN
#

if {[llength $argv] < 3} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set fields {}
#               name            pos  len  check processed
lappend fields {"Hardware ID"   0x00 0x10 false false}
lappend fields {"Maker ID"      0x10 0x10 false false}
lappend fields {"Device Info"   0x20 0x10 false false}
lappend fields {"Area Symbols"  0x30 0x08 true  false}
lappend fields {"Peripherals"   0x38 0x08 false false}
lappend fields {"Product No"    0x40 0x0A false false}
lappend fields {"Version"       0x4A 0x06 false false}
lappend fields {"Release Date"  0x50 0x10 false false}
lappend fields {"Boot Filename" 0x60 0x10 false false}
lappend fields {"SW Maker Name" 0x70 0x10 false false}
lappend fields {"Game Title"    0x80 0x80 false false}

set filetmpl [lindex $argv 0]
set filein [lindex $argv 1]
set fileout IP.BIN

# read template file
set fp_tmpl [open $filetmpl r]
fconfigure $fp_tmpl -encoding binary -translation binary
set tmpl_data [read $fp_tmpl 32768]
close $fp_tmpl

# read input file
set fp_filein [open $filein r]
# avoid an extra empty line by trimming
set filein_textlines [split [string trim [read $fp_filein] "\n"] "\n"]
close $fp_filein

# parse tokens, perform processing
foreach textline $filein_textlines {
    incr item
    set tokens [split $textline ":"]
    set token_name [string trim [lindex $tokens 0]]
    set token_value [string trim [lindex $tokens 1]]
    for {set i 0} {$i < [llength $fields]} {incr i} {
        set field [lindex $fields $i]
        set found false
        if {$token_name eq [lindex $field 0]} {
            set found true
            break
        }
    }
    if {$found eq false} {
        puts stderr "$SCRIPT_FILENAME: *** Warning: unknown token: $token_name."
        break
    }
    # now we have the field index in $i
    set position [lindex $field 1]
    set length [lindex $field 2]
    set check [lindex $field 3]
    # replace value
    if {[string length $token_value] > $length} {
        puts stderr "$SCRIPT_FILENAME: *** Warning: extra token length: $token_value."
    }
    # create a maximum length space-padded string and write the value
    # left-justified
    set string_padded [format {%- *s} $length $token_value]
    set tmpl_data [string replace                                           \
                      $tmpl_data                                            \
                      $position                                             \
                      [expr $position + [string length $string_padded] - 1] \
                      $string_padded                                        \
                      ]
    # check memory areas
    if {$check eq true} {
    }
    # flag as processed
    lset field 4 true
    lset fields $i $field
}

# check for some token not processed
for {set i 0} {$i < [llength $fields]} {incr i} {
    set field [lindex $fields $i]
    if {[lindex $field 4] ne true} {
        puts stderr "$SCRIPT_FILENAME: *** Warning: token #$i not processed."
    }
}

# compute CRC
set crc_value [crc16 $tmpl_data 0x40 16]
# sprintf()-like
set crc_value_text [format "%04X" $crc_value]
set crc_value_text_old [string range $tmpl_data 0x20 0x23]
if {[string compare -length 4 $crc_value_text $crc_value_text_old] ne 0} {
    #puts "Setting CRC to 0x$crc_value_text (was 0x$crc_value_text_old)."
    set tmpl_data [string replace $tmpl_data 0x20 4 $crc_value_text]
}

# generate output file
set fp_fileout [open $fileout w]
fconfigure $fp_fileout -encoding binary -translation binary
puts -nonewline $fp_fileout $tmpl_data
close $fp_fileout

#
# 2nd part: "scramble" the kernel file and generate 1ST_READ.BIN.
#
# Input:
# - kernel filename
# Output:
# - 1ST_READ.BIN
#

set MAXCHUNK [expr 2048 * 1024]

set filein [lindex $argv 2]
set fileout 1ST_READ.BIN

# read input file
set fp_filein [open $filein r]
fconfigure $fp_filein -encoding binary -translation binary
set filein_data [read $fp_filein]
close $fp_filein

# file size
set filein_size [string length $filein_data]

# create a seed
set seed [expr $filein_size & 0xFFFF]

# generate output file
set fp_fileout [open $fileout w]
fconfigure $fp_fileout -encoding binary -translation binary
# descramble 2 M blocks for as long as possible, then gradually reduce the
# window down to 32 bytes (1 slice)
set offset 0
for {set chunk_size $MAXCHUNK} {$chunk_size >= 32} {set chunk_size [expr $chunk_size >> 1]} {
    while {$filein_size >= $chunk_size} {
        save_chunk $fp_fileout $filein_data $offset $chunk_size
        set filein_size [expr $filein_size - $chunk_size]
        set offset [expr $offset + $chunk_size]
    }
}
# write incomplete slice
if {$filein_size > 0} {
    set start $offset
    set end [expr $start + $filein_size - 1]
    puts -nonewline $fp_fileout [string range $filein_data $start $end]
}
close $fp_fileout

exit 0

