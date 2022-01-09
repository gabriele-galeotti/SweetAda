
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
                                                        // Table 7-1
                                                        // TRAP#        PRIORITY        DESCRIPTION
                b       trap_table                      // 0x00         -               ???
                nop
                .align  16
                b       trap_table                      // 0x01         5               instruction_access_exception
                nop
                .align  16
                b       trap_table                      // 0x02         7               illegal_instruction
                nop
                .align  16
                b       trap_table                      // 0x03         6               privileged_instruction
                nop
                .align  16
                b       trap_table                      // 0x04         8               fp_disabled
                nop
                .align  16
                b       trap_table                      // 0x05         9               window_overflow
                nop
                .align  16
                b       trap_table                      // 0x06         9               window_underflow
                nop
                .align  16
                b       trap_table                      // 0x07         10              mem_address_not_aligned
                nop

