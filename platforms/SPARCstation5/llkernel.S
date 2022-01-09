
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .traptable,"ax"

                //
                // TBR should be aligned on a 4096-byte boundary (bits 0..11
                // cleared).
                //

                .global trap_table
trap_table:
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

