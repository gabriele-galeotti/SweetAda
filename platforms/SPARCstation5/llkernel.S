
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global trap_table
trap_table:
                .align  4096                            // bits 0..11 cleared
                b       trap_table                      // trap 0x00
                nop
                .align  16
                b       trap_table                      // trap 0x01
                nop
                .align  16
                b       trap_table                      // trap 0x02
                nop
                .align  16
                b       trap_table                      // trap 0x03
                nop
                .align  16
                b       trap_table                      // trap 0x04
                nop
                .align  16
                b       trap_table                      // trap 0x05
                nop
                .align  16
                b       trap_table                      // trap 0x06
                nop
                .align  16
                b       trap_table                      // trap 0x07
                nop

