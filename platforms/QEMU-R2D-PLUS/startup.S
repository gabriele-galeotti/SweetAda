
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sh.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

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

                .align  4
DEF_LREFL(kernel_stack)
DEF_EREFL(vector_table)
DEF_EREFL(_sbss)
DEF_EREFL(_ebss)
DEF_EREFL(_ada_main)

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

