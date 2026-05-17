
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2026 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sh.h>
#define CCR_P4 0xFF00001C

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .align  1

                .type   _start,@function
                .global _start
_start:

                //
                // Disable interrupts.
                //
                mov.l   sr_init,r0
                ldc     r0,sr

                //
                // Run in the P2 area.
                //
                mov.l   REF(setup_cache),r0
                mov.l   p2_mask,r1
                or      r1,r0
                jmp     @r0
                nop
DEF_LREFL(setup_cache)
setup_cache:
                mov.w   ccr_data,r1
                mov.l   REF(CCR_P4),r0
                mov.l   r1,@r0


                //
                // After changing CCR, 8 instructions must be executed before
                // entering a cached area such as P1.
                //
                nop                             // 1
                nop                             // 2
                nop                             // 3
                nop                             // 4
                nop                             // 5 (d-cache is safe)
                nop                             // 6
                mov.l   REF(init),r0            // 7
                mov     #0,r1                   // 8
                jmp     @r0
                mov     r1,r0
                nop
DEF_LREFL(init)
init:

                //
                // Set VBR.
                //
                mov.l   REF(vector_table),r0
                ldc     r0,vbr

                //
                // Setup stack pointer.
                //
                mov.l   REF(kernel_stack),r15

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                mov.l   REF(_sbss),r2
                mov.l   REF(_ebss),r3
                xor     r1,r1
1:              cmp/eq  r3,r2
                bt      2f
                nop
                mov.l   @r2+,r1
                bra     1b
                nop
2:

                //
                // Jump to high-level code.
                //
                mov.l   REF(_ada_main),r0
                jsr     @r0
                nop

dead:           bra     .
                nop

                .size   _start,.-_start

                .align  2
sr_init:        .long   0x500000F0
p2_mask:        .long   0xA0000000

DEF_LREFL(CCR_P4)
ccr_data:       .word   0x090D

DEF_EREFL(vector_table)
DEF_EREFL(_sbss)
DEF_EREFL(_ebss)
DEF_EREFL(adainit)
DEF_EREFL(_ada_main)
DEF_LREFL(kernel_stack)

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

