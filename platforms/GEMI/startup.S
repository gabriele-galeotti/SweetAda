
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

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .align  1

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
                bra     1f
                nop
VARL(BCRA, 0x05FFFFA0)                                  // BCR
VARW(BCRV, 0x0800)                                      // enable BAS
VARL(WCR1A, 0x05FFFFA2)                                 // WCR1
VARW(WCR1V, 0x00FD)                                     // disable /WAIT sampling
VARL(WCR3A, 0x05FFFFA6)                                 // WCR3
VARW(WCR3V, 0xF800)                                     // default
VARL(PACR1A, 0x05FFFFC8)                                // PACR1
VARW(PACR1V, 0xFF06)                                    // enable /DREQ1, /DACK1, /DREQ0, /DACK0, PA11, PA10, /AH, PA8
VARL(PACR2A, 0x05FFFFCA)                                // PACR2
VARW(PACR2V, 0xFF95)                                    // enable /BACK, /RD, /LBS, /WR, /WAIT, /CS6, /CS5, /CS4
1:

                //
                // Setup stack pointer.
                //
                mov.l   REF(kernel_stack),r15

                //
                // Static data relocation.
                //
                mov.l   REF(_sdata),r1
                mov.l   REF(_edata),r2
                mov.l   REF(_etext),r3
1:              cmp/ge  r2,r1
                bt      2f
                nop
                mov.l   @r3+,r0
                mov.l   r0,@r1
                add     #4,r1
                bra     1b
                nop
2:

                //
                // Initialize .bss section.
                //
                mov.l   REF(_sbss),r1
                mov.l   REF(_ebss),r2
                xor     r0,r0
1:              cmp/ge  r2,r1
                bt      2f
                nop
                mov.l   r0,@r1
                add     #4,r1
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

DEF_LREFL(kernel_stack)
DEF_EREFL(_etext)
DEF_EREFL(_sdata)
DEF_EREFL(_edata)
DEF_EREFL(_sbss)
DEF_EREFL(_ebss)
DEF_EREFL(_ada_main)

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

