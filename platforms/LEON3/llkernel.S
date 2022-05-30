
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

                //
                // trap 0x00
                //
                b       trap_entry
                nop
                //
                // instruction_access_exception 5 0x01
                //
                .align  16
                b       trap_table
                nop
                //
                // illegal_instruction 7 0x02
                //
                .align  16
                b       trap_table
                nop
                //
                // privileged_instruction 6 0x03
                //
                .align  16
                b       trap_table
                nop
                //
                // fp_disabled 8 0x04
                //
                .align  16
                b       trap_table
                nop
                //
                // window_overflow 9 0x05
                //
                .align  16
                b       trap_table
                nop
                //
                // window_underflow 9 0x06
                //
                .align  16
                b       trap_table
                nop
                //
                // mem_address_not_aligned 10 0x07
                //
                .align  16
                b       trap_table
                nop
                //
                // fp_exception 11 0x08
                //
                .align  16
                b       trap_table
                nop
                //
                // data_access_exception 13 0x09
                //
                .align  16
                b       trap_table
                nop
                //
                // tag_overflow 14 0x0A
                //
                .align  16
                b       trap_table
                nop
                //
                // watchpoint_detected 8 0x0B
                //
                .align  16
                b       trap_table
                nop
                //
                // trap 0x0C
                //
                .align  16
                b       trap_table
                nop
                //
                // trap 0x0D
                //
                .align  16
                b       trap_table
                nop
                //
                // trap 0x0E
                //
                .align  16
                b       trap_table
                nop
                //
                // trap 0x0F
                //
                .align  16
                b       trap_table
                nop
                //
                // trap 0x10
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_1 31 0x11
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_2 30 0x12
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_3 29 0x13
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_4 28 0x14
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_5 27 0x15
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_6 26 0x16
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_7 25 0x17
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_8 24 0x18
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_9 23 0x19
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_10 22 0x1A
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_11 21 0x1B
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_12 20 0x1C
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_13 19 0x1D
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_14 18 0x1E
                //
                .align  16
                b       trap_table
                nop
                //
                // interrupt_level_15 17 0x1F
                //
                .align  16
                b       trap_table
                nop

trap_entry:
                b       .
                nop

