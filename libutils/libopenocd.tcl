
#
# SweetAda OpenOCD library.
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
# none
#

################################################################################
# version_numeric                                                              #
#                                                                              #
# "Open On-Chip Debugger 0.11.0-rc1+dev-00010-gc69b4de"                        #
################################################################################
proc version_numeric {} {
    # note the trailing ".", so that we correctly process every digit
    # (otherwise the foreach will exit, leaving the last part of the version
    # still hanging)
    set versionstring [split [lindex [split [version] " "] 3] ""].
    set versionnumber 0
    set level ""
    foreach c $versionstring {
        if {[string is digit $c]} {
            set level $level$c
        } else {
            set level [format %02s $level]
            set versionnumber [expr $versionnumber * 100 + $level]
            if {$c eq "."} {
                set level ""
            } else {
                break
            }
        }
    }
    return $versionnumber
}

