
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
                //
                // The trapped program counters are saved in local registers 1
                // and 2 of the new window: r[17] ← PC, r[18] ← nPC
                //
                // The window has changed, so save overlapping registers.
                //
                add     %sp,-64,%sp
                st      %g1,[%sp+0x00]
                st      %g2,[%sp+0x04]
                st      %g3,[%sp+0x08]
                st      %g4,[%sp+0x0C]
                st      %g5,[%sp+0x10]
                st      %g6,[%sp+0x14]
                st      %g7,[%sp+0x18]
                st      %i0,[%sp+0x1C]
                st      %i1,[%sp+0x20]
                st      %i2,[%sp+0x24]
                st      %i3,[%sp+0x28]
                st      %i4,[%sp+0x2C]
                st      %i5,[%sp+0x30]
                st      %i6,[%sp+0x34]
                st      %i7,[%sp+0x38]
                add     %sp,-96,%sp
                .extern irq_process
                call    irq_process
                nop
                add     %sp,96,%sp
                ld      [%sp+0x00],%g1
                ld      [%sp+0x04],%g2
                ld      [%sp+0x08],%g3
                ld      [%sp+0x0c],%g4
                ld      [%sp+0x10],%g5
                ld      [%sp+0x14],%g6
                ld      [%sp+0x18],%g7
                ld      [%sp+0x1C],%i0
                ld      [%sp+0x20],%i1
                ld      [%sp+0x24],%i2
                ld      [%sp+0x28],%i3
                ld      [%sp+0x2C],%i4
                ld      [%sp+0x30],%i5
                ld      [%sp+0x34],%i6
                ld      [%sp+0x38],%i7
                add     %sp,64,%sp
                jmpl    %r17,%r0                // old PC
                rett    %r18                    // old nPC

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .global trap_stack
                .align  8
                .space  4096
trap_stack:

