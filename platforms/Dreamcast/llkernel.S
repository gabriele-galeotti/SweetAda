
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sh.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"
                //.sect   .text,"ax"

                .align  16
                .global vector_table
vector_table:

                // TRAPA
                . = 0x0100

                mov.l   r0,@-r15
                mov.l   r1,@-r15
                mov.l   r2,@-r15
                mov.l   r3,@-r15
                mov.l   r4,@-r15
                mov.l   r5,@-r15
                mov.l   r6,@-r15
                mov.l   r7,@-r15
                mov.l   r8,@-r15
                mov.l   r9,@-r15
                mov.l   r10,@-r15
                mov.l   r11,@-r15
                sts     pr,r0
                mov.l   r0,@-r15

                mov.l   REF(exception_process),r0
                jsr     @r0
                nop

                mov.l   @r15+,r0
                lds     r0,pr
                mov.l   @r15+,r11
                mov.l   @r15+,r10
                mov.l   @r15+,r9
                mov.l   @r15+,r8
                mov.l   @r15+,r7
                mov.l   @r15+,r6
                mov.l   @r15+,r5
                mov.l   @r15+,r4
                mov.l   @r15+,r3
                mov.l   @r15+,r2
                mov.l   @r15+,r1
                mov.l   @r15+,r0

                rte
                nop

DEF_EREFL(exception_process)

