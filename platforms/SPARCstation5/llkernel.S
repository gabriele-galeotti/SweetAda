
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sparcv8.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .traptable,"ax"

                //
                // TBR should be aligned on a 4096-byte boundary (bits 0..11
                // cleared).
                //

                .align  16

                .global trap_table
trap_table:

                // trap 0x00
                set     0x00,%o0
                b       trap_error
                nop

                // instruction_access_exception 5 0x01
                .align  16
                set     0x01,%o0
                b       trap_error
                nop

                // illegal_instruction 7 0x02
                .align  16
                set     0x02,%o0
                b       trap_error
                nop

                // privileged_instruction 6 0x03
                .align  16
                set     0x03,%o0
                b       trap_error
                nop

                // fp_disabled 8 0x04
                .align  16
                set     0x04,%o0
                b       trap_error
                nop

                // window_overflow 9 0x05
                .align  16
                set     0x05,%o0
                b       trap_error
                nop

                // window_underflow 9 0x06
                .align  16
                set     0x06,%o0
                b       trap_error
                nop

                // mem_address_not_aligned 10 0x07
                .align  16
                set     0x07,%o0
                b       trap_error
                nop

                // fp_exception 11 0x08
                .align  16
                set     0x08,%o0
                b       trap_error
                nop

                // data_access_exception 13 0x09
                .align  16
                set     0x09,%o0
                b       trap_error
                nop

                // tag_overflow 14 0x0A
                .align  16
                set     0x0A,%o0
                b       trap_error
                nop

                // watchpoint_detected 8 0x0B
                .align  16
                set     0x0B,%o0
                b       trap_error
                nop

                // trap 0x0C
                .align  16
                set     0x0C,%o0
                b       trap_error
                nop

                // trap 0x0D
                .align  16
                set     0x0D,%o0
                b       trap_error
                nop

                // trap 0x0E
                .align  16
                set     0x0E,%o0
                b       trap_error
                nop

                // trap 0x0F
                .align  16
                set     0x0F,%o0
                b       trap_error
                nop

                // trap 0x10
                .align  16
                set     0x10,%o0
                b       trap_error
                nop

                // interrupt_level_1 31 0x11
                .align  16
                set     0x11,%o0
                b       irq_not_handled
                nop

                // interrupt_level_2 30 0x12
                .align  16
                set     0x12,%o0
                b       irq_not_handled
                nop

                // interrupt_level_3 29 0x13
                .align  16
                set     0x13,%o0
                b       irq_not_handled
                nop

                // interrupt_level_4 28 0x14
                .align  16
                set     0x14,%o0
                b       irq_not_handled
                nop

                // interrupt_level_5 27 0x15
                .align  16
                set     0x15,%o0
                b       irq_not_handled
                nop

                // interrupt_level_6 26 0x16
                .align  16
                set     0x16,%o0
                b       irq_not_handled
                nop

                // interrupt_level_7 25 0x17
                .align  16
                set     0x17,%o0
                b       irq_not_handled
                nop

                // interrupt_level_8 24 0x18
                .align  16
                set     0x18,%o0
                b       irq_not_handled
                nop

                // interrupt_level_9 23 0x19
                .align  16
                set     0x19,%o0
                b       irq_not_handled
                nop

                // interrupt_level_10 22 0x1A (timer)
                .align  16
                set     0x1A,%o0
                b       irq_entry
                nop

                // interrupt_level_11 21 0x1B
                .align  16
                set     0x1B,%o0
                b       irq_not_handled
                nop

                // interrupt_level_12 20 0x1C (SCC)
                .align  16
                set     0x1C,%o0
                b       irq_entry
                nop

                // interrupt_level_13 19 0x1D
                .align  16
                set     0x1D,%o0
                b       irq_not_handled
                nop

                // interrupt_level_14 18 0x1E
                .align  16
                set     0x1E,%o0
                b       irq_not_handled
                nop

                // interrupt_level_15 17 0x1F
                .align  16
                set     0x1F,%o0
                b       irq_not_handled
                nop

trap_error:
                mov     %l1,%o1
                .extern exception_process
                call    exception_process
                nop

irq_not_handled:
                b       .
                nop

irq_entry:
                //
                // The trapped program counters are saved in local registers 1
                // and 2 of the new window: r[17]=l[0]=PC, r[18]=l[1]=nPC
                //
                // The window has changed, so save overlapping registers.
                //
                add     %sp,-72,%sp
                std     %g0,[%sp+ 0]
                std     %g2,[%sp+ 8]
                std     %g4,[%sp+16]
                std     %g6,[%sp+24]
                std     %i0,[%sp+32]
                std     %i2,[%sp+40]
                std     %i4,[%sp+48]
                std     %i6,[%sp+56]
                mov     %psr,%g1
                st      %g1,[%sp+64]
                add     %sp,-96,%sp
                .extern irq_process
                call    irq_process
                nop
                add     %sp,96,%sp
                ld      [%sp+64],%g1
                mov     %g1,%psr
                NOP3
                ldd     [%sp+ 0],%g0
                ldd     [%sp+ 8],%g2
                ldd     [%sp+16],%g4
                ldd     [%sp+24],%g6
                ldd     [%sp+32],%i0
                ldd     [%sp+40],%i2
                ldd     [%sp+48],%i4
                ldd     [%sp+56],%i6
                add     %sp,72,%sp
                jmpl    %l1,%g0
                rett    %l2

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .global trap_stack
                .align  8
                .space  1024
trap_stack:

