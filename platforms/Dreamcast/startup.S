
//
// startup.S - Dreamcast startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
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
                mov.l   REF(SVC_stack),r15

                //
                // Call "adainit" procedure.
                //
                mov.l   REF(adainit),r0
                jsr     @r0
                nop

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
DEF_LREF(SVC_stack)
DEF_EREF(vector_table)
DEF_EREF(adainit)
DEF_EREF(_ada_main)

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
SVC_stack:

