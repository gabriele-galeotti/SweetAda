#!/usr/bin/env tclsh

#
# Xilinx EDK - SweetAda integration.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
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
# PLATFORM_DIRECTORY
# KERNEL_BASENAME
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
        msleep 2
        set fd_data [read $fd 256]
        # check if reply string end with "ack" + NUL
        set idx [string last ack\x00 $fd_data [expr [string length $fd_data] - 1]]
        if {$idx < 0} {
            return -1
            break
        }
        puts -nonewline stderr "."
        if {$data_length ne 64} {
            break
        }
    }
    close $fd_bitstream
    puts ""
    return 0
}

################################################################################
# do_command                                                                   #
#                                                                              #
# Execute a command.                                                           #
################################################################################
proc do_command {fd command_string} {
    set return_value ""
    puts -nonewline $fd $command_string\x00
    msleep 300
    set fd_data [read $fd 256]
    # check if reply string end with "ack" + NUL
    set idx [string last ack\x00 $fd_data [expr [string length $fd_data] - 1]]
    if {$idx < 0} {
        puts "*** Error: no ack received."
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

if {[platform_get] ne "unix"} {
    puts stderr "$SCRIPT_FILENAME: *** Error: platform not recognized."
    exit 1
}

set XILINX_PATH       /opt/Xilinx/14.7/ISE_DS
# top-level directory of the project
set PROJECT_PATH      /root/project/hardware/Xilinx_Spartan3A/Spartan_3A_Eval_Test_Source_v92
set BOOTLOOP_ELF_FILE [file join $XILINX_PATH EDK/sw/lib/microblaze/mb_bootloop.elf]
set SWEETADA_ELF_FILE [file join $::env(SWEETADA_PATH) $::env(KERNEL_BASENAME).elf]
set DEVICE            xc3s400aft256-4
set PSOC_DEVICE       /dev/ttyACM0

#
# Build download.bit.
#
# hardware-only bitstream is $PROJECT_PATH/implementation/system.bit
# final bitstream is $PROJECT_PATH/implementation/download.bit
#
# NOTE: bitinit does not seem to return an exit error code, so check if
# download.bit is correctly generated (with backup)
#
set DOWNLOAD_BIT [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) download.bit]
set BITINIT_LOG [file join $::env(SWEETADA_PATH) $::env(PLATFORM_DIRECTORY) bitinit.log]
if {[file exists $DOWNLOAD_BIT]} {
    file rename -force $DOWNLOAD_BIT $DOWNLOAD_BIT.tmp
}
exec -ignorestderr >@stdout 2>@stderr sh -c "\
source $XILINX_PATH/settings64.sh ;              \
bitinit                                          \
  $PROJECT_PATH/system.mhs                       \
  -bm $PROJECT_PATH/implementation/system_bd.bmm \
  -bt $PROJECT_PATH/implementation/system.bit    \
  -o $DOWNLOAD_BIT                               \
  -pe microblaze_0 $SWEETADA_ELF_FILE            \
  -lp $PROJECT_PATH/..                           \
  -log $BITINIT_LOG                              \
  -p $DEVICE                                     \
"
if {[file exists $DOWNLOAD_BIT]} {
    file delete -force $DOWNLOAD_BIT.tmp
} else {
    # bitinit failed
    if {[file exists $DOWNLOAD_BIT.tmp]} {
        file rename -force $DOWNLOAD_BIT.tmp $DOWNLOAD_BIT
    }
    exit 1
}

#
# PSoC SPI-mode programming.
#
# 3.1 Configure FPGA over Slave Serial
#
set fd [open $PSOC_DEVICE "r+"]
fconfigure $fd \
    -blocking 0 \
    -buffering none \
    -eofchar {} \
    -mode 115200,n,8,1 \
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
set bitstream_size [file size $DOWNLOAD_BIT]
do_command $fd "ss_program $bitstream_size"
# 10. Send bytes from .bit file
if {[download_bitstream $fd $DOWNLOAD_BIT] < 0} {
    puts "*** Error: no successful download."
    close $fd
    exit 1
}
# 11. Check INIT is still high
set response [do_command $fd "read_init"]
if {$response ne "\x01"} {
    puts "*** Error: INIT not high after programming."
    close $fd
    exit 1
}
# 12. Check DONE is high
set response [do_command $fd "read_done"]
if {$response ne "\x01"} {
    puts "*** Error: DONE not high after programming."
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

