
//
// startup.S - GEMI startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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

                //
                // Section 8 Bus State Controller (BSC)
                // 8.1.4 Register Configuration
                // Section 15 Pin Function Controller (PFC)
                // 15.2 Register Configuration
                //
                mov.l   BCRA,r1
                mov.w   BCRV,r0
                mov.w   r0,@r1
                mov.l   WCR1A,r1
                mov.w   WCR1V,r0
                mov.w   r0,@r1
                mov.l   WCR3A,r1
                mov.w   WCR3V,r0
                mov.w   r0,@r1
                mov.l   PACR1A,r1
                mov.w   PACR1V,r0
                mov.w   r0,@r1
                mov.l   PACR2A,r1
                mov.w   PACR2V,r0
                mov.w   r0,@r1

                //
                // Setup stack pointer.
                //
                mov.l   REF(SVC_stack),r15

                //
                // Static data relocation.
                //
                mov.l   REF(movdata),r0
                jsr     @r0
                nop

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
VARL(BCRA, 0x05FFFFA0)                                  // BCR
VARW(BCRV, 0x0800)                                      // enable BAS
                .align  4
VARL(WCR1A, 0x05FFFFA2)                                 // WCR1
VARW(WCR1V, 0xFFFF)                                     // default
                .align  4
VARL(WCR3A, 0x05FFFFA6)                                 // WCR3
VARW(WCR3V, 0xF800)                                     // default
                .align  4
VARL(PACR1A, 0x05FFFFC8)                                // PACR1
VARW(PACR1V, 0xFF06)                                    // enable /DREQ0, /DREQ1, /AH
                .align  4
VARL(PACR2A, 0x05FFFFCA)                                // PACR2
VARW(PACR2V, 0xFF95)                                    // default
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
                mov.l   REF(_sdata),r1
                mov.l   REF(_edata),r3
                cmp/eq  r3,r1
                bt      .L3
                mov.l   REF(_etext),r2
.L4:            mov.l   @r2+,r7
                cmp/eq  r3,r1
                mov.l   r7,@r1
                add     #4,r1
                bf      .L4
.L3:            rts
                nop

                .align  4
DEF_EREF(_etext)
DEF_EREF(_sdata)
DEF_EREF(_edata)

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
SVC_stack:

