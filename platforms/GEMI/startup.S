
//
// startup.S - GEMI startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sh.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

POR_reset:      .long   _start
POR_sp:         .long   0
reset:          .long   _start
sp:             .long   0

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                nop

                // Section 8 Bus State Controller (BSC)
                // 8.1.4 Register Configuration

                //
                // Setup stack pointer.
                //
                mov.l   REF(SVC_stack),r15

                // perform static data relocation
                //mov.l   REF(movdata),r0
                //jsr     @r0
                //nop

                //
                // Call "adainit" procedure.
                //
                //mov.l   REF(adainit),r0
                //jsr     @r0
                //nop

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
DEF_LREF(movdata)
DEF_EREF(adainit)
DEF_EREF(_ada_main)

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// Perform high-level language data relocation.                               //
////////////////////////////////////////////////////////////////////////////////

                .align  2
movdata:
                mov.l   REF(_sdata),r1                  // .L8
                mov.l   REF(_edata),r3                  // .L9
                cmp/eq  r3,r1
                bt      .L3
                cmp/hs  r3,r1
                bt      .L3
                sett
                mov.l   REF(_data_start),r2             // .L10
                subc    r1,r3
                mov     #-4,r7
                and     r7,r3
                add     #4,r3
                add     r2,r3
                .align  2
.L4:            mov.l   @r2+,r7
                cmp/eq  r3,r2
                mov.l   r7,@r1
                add     #4,r1
                bf      .L4
.L3:            rts
                nop

                .align  4
DEF_EREF(_data_start)
DEF_EREF(_sdata)
DEF_EREF(_edata)

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
SVC_stack:

