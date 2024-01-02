#!/usr/bin/env tclsh

#
# Spartan-3A-EK FPGA bitstream download.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -b <FPGA_BITSTREAM>  Xilinx FPGA bitstream filename
# -c <PSOC_COMMDEVICE> PSoC communication channel (e.g., /dev/ttyACM0)
#
# Environment variables:
# OSTYPE
# SWEETADA_PATH
# PLATFORM_DIRECTORY
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

################################################################################
# download_bitstream                                                           #
#                                                                              #
# Download an FPGA bitstream.                                                  #
################################################################################
proc download_bitstream {fd bitstream_filename} {
    set fd_bitstream [open $bitstream_filename r]
    fconfigure $fd_bitstream -encoding binary -translation binary
    while {true} {
        set bitstream_data [read $fd_bitstream 64]
        set data_length [string length $bitstream_data]
        puts -nonewline $fd $bitstream_data
        after 1
        set fd_data [read $fd 256]
        # check if reply string end with "ack" + NUL
        set idx [string last ack\x00 $fd_data [expr [string length $fd_data] - 1]]
        if {$idx < 0} {
            return -1
            break
        }
        #puts -nonewline stderr "."
        if {$data_length ne 64} {
            break
        }
    }
    close $fd_bitstream
    #puts ""
    return 0
}

################################################################################
# do_command                                                                   #
#                                                                              #
# Execute a command.                                                           #
################################################################################
proc do_command {fd command_string} {
    global SCRIPT_FILENAME
    set return_value ""
    puts -nonewline $fd $command_string\x00
    after 100
    set fd_data [read $fd 256]
    # check if reply string end with "ack" + NUL
    set idx [string last ack\x00 $fd_data [expr [string length $fd_data] - 1]]
    if {$idx < 0} {
        puts "$SCRIPT_FILENAME: *** Error: no ack received."
        close $fd
        exit 1
    } else {
        set command [lindex [split $command_string " "] 0]
        if {$command eq "get_ver"} {
            incr idx -1
            puts [string range $fd_data 0 $idx]
        } elseif {$command eq "get_config"} {
            set response [string range $fd_data 0 0]
            if {$response eq "0"} {
                puts "get_config: UART"
            } elseif {$response eq "1"} {
                puts "get_config: SPI"
            } elseif {$response eq "2"} {
                puts "get_config: JTAG"
            } elseif {$response eq "3"} {
                puts "get_config: NONE"
            }
        } elseif {$command eq "load_config"} {
            puts "load_config ok"
        } elseif {$command eq "drive_prog"} {
            puts "drive_prog ok"
        } elseif {$command eq "drive_mode"} {
            puts "drive_mode ok"
        } elseif {$command eq "spi_mode"} {
            puts "spi_mode ok"
        } elseif {$command eq "read_init"} {
            incr idx -1
            set return_value [string range $fd_data $idx $idx]
            puts -nonewline "read_init: "
            if {$return_value eq "\x00"} {
                puts "0"
            } elseif {$return_value eq "\x01"} {
                puts "1"
            }
        } elseif {$command eq "read_done"} {
            incr idx -1
            set return_value [string range $fd_data $idx $idx]
            puts -nonewline "read_done: "
            if {$return_value eq "\x00"} {
                puts "0"
            } elseif {$return_value eq "\x01"} {
                puts "1"
            }
        } elseif {$command eq "ss_program"} {
            puts "ss_program ok"
        } elseif {$command eq "fpga_rst"} {
            puts "fpga_rst ok"
        } else {
            puts "command ok"
        }
    }
    return $return_value
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

set OSTYPE $::env(OSTYPE)
set PLATFORM [platform_get]

set FPGA_BITSTREAM ""
set PSOC_COMMDEVICE ""

set argv_last_idx [llength $argv]
set argv_idx 0
while {$argv_idx < $argv_last_idx} {
    set token [lindex $argv $argv_idx]
    switch $token {
        -b {incr argv_idx ; set FPGA_BITSTREAM [lindex $argv $argv_idx]}
        -c {incr argv_idx ; set PSOC_COMMDEVICE [lindex $argv $argv_idx]}
        default {
            puts stderr "$SCRIPT_FILENAME: *** Error: unknown argument."
            exit 1
        }
    }
    incr argv_idx
}

if {$PLATFORM ne "unix"} {
    puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
    exit 1
}

if {$FPGA_BITSTREAM eq ""} {
    puts "$SCRIPT_FILENAME: *** Error: no FPGA_BITSTREAM."
    exit 1
}

if {$PSOC_COMMDEVICE eq ""} {
    puts "$SCRIPT_FILENAME: *** Error: no PSOC_COMMDEVICE."
    exit 1
}

#
# PSoC SPI-mode programming.
#
# 3.1 Configure FPGA over Slave Serial
#
set fd [open $PSOC_COMMDEVICE "r+"]
fconfigure $fd \
    -blocking 0 \
    -buffering none \
    -eofchar {} \
    -mode 230400,n,8,1 \
    -translation binary
flush $fd
set sp_data [read $fd 256]
puts "start programming ..."
# 1. Load SPI configuration
do_command $fd "load_config 1"
# 2. Drive PROG low
do_command $fd "drive_prog 0"
# 3. Drive M[2:0] to 1:1:1
do_command $fd "drive_mode 7"
# 4. Drive PSOC_SPI_MODE high
do_command $fd "spi_mode 1"
# 5. Drive PROG high
do_command $fd "drive_prog 1"
# 6. Wait for INIT to go high
while {true} {
    set response [do_command $fd "read_init"]
    if {$response eq "\x01"} {
        break
    }
}
# 7. Drive M[2:0] to tri-state
do_command $fd "drive_mode 8"
# 8. Assert the FPGA reset to hold the FPGA application in reset until the
#    PSoC has had time to switch configurations
do_command $fd "fpga_rst 1"
# 9. ss_program <# bytes in the .bit file>
set bitstream_size [file size $FPGA_BITSTREAM]
do_command $fd "ss_program $bitstream_size"
# 10. Send bytes from .bit file
if {[download_bitstream $fd $FPGA_BITSTREAM] < 0} {
    puts "$SCRIPT_FILENAME: *** Error: no successful download."
    close $fd
    exit 1
}
# 11. Check INIT is still high
set response [do_command $fd "read_init"]
if {$response ne "\x01"} {
    puts "$SCRIPT_FILENAME: *** Error: INIT not high after programming."
    close $fd
    exit 1
}
# 12. Check DONE is high
set response [do_command $fd "read_done"]
if {$response ne "\x01"} {
    puts "$SCRIPT_FILENAME: *** Error: DONE not high after programming."
    close $fd
    exit 1
}
# 13. Drive PSOC_SPI_MODE low
do_command $fd "spi_mode 0"
# 14. Load UART configuration
do_command $fd "load_config 0"
# 15. Deassert FPGA reset
do_command $fd "fpga_rst 0"
# done
close $fd

exit 0

