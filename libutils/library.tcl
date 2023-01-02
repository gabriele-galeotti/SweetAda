
#
# SweetAda Tcl library.
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
# none
#

################################################################################
# platform_get                                                                 #
#                                                                              #
# Return the current OS platform.                                              #
################################################################################
proc platform_get {} {
    global tcl_platform
    return $tcl_platform(platform)
}

################################################################################
# platform_bigendian                                                           #
#                                                                              #
################################################################################
proc platform_bigendian {} {
    global tcl_platform
    if {$tcl_platform(byteOrder) eq bigEndian} {
        return true
    }
    return false
}

################################################################################
# platform_littleendian                                                        #
#                                                                              #
################################################################################
proc platform_littleendian {} {
    global tcl_platform
    if {$tcl_platform(byteOrder) eq littleEndian} {
        return true
    }
    return false
}

################################################################################
# msleep                                                                       #
#                                                                              #
# Sleep for ms milliseconds.                                                   #
################################################################################
proc msleep {ms} {
    after [expr {int($ms)}]
}

################################################################################
# u16_to_bebytes                                                               #
#                                                                              #
# 16-bit value to BE byte-array list.                                          #
################################################################################
proc u16_to_bebytes {n} {
    set belist {}
    lappend belist [expr ($n / 0x100) % 0x100]
    lappend belist [expr $n % 0x100]
    return $belist
}

################################################################################
# u32_to_bebytes                                                               #
#                                                                              #
# 32-bit value to BE byte-array list.                                          #
################################################################################
proc u32_to_bebytes {n} {
    set belist {}
    lappend belist [expr ($n / 0x1000000) % 0x100]
    lappend belist [expr ($n / 0x10000) % 0x100]
    lappend belist [expr ($n / 0x100) % 0x100]
    lappend belist [expr $n % 0x100]
    return $belist
}

################################################################################
# u16_to_lebytes                                                               #
#                                                                              #
# 16-bit value to LE byte-array list.                                          #
################################################################################
proc u16_to_lebytes {n} {
    return [lreverse [u16_to_bebytes $n]]
}

################################################################################
# u32_to_lebytes                                                               #
#                                                                              #
# 32-bit value to LE byte-array list.                                          #
################################################################################
proc u32_to_lebytes {n} {
    return [lreverse [u32_to_bebytes $n]]
}

