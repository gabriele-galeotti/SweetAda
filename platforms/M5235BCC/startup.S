
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>
#include <coldfire.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   _start,@function
                .global _start
_start:

                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts

                //
                // IPSBAR initialization.
                //
                move.l  #(IPSBAR+1),%d0                 // bit0 = 1 --> mark as valid
                move.l  %d0,IPSBAR_DEFAULT              // store in IPSBAR power-on configuration register

                //
                // RAMBAR initialization.
                //
                move.l  #(SRAM_DEFAULT+0x21),%d0        // C/I | V
                movec.l %d0,%rambar

                //
                // Disable the ACRs and cache.
                //
                moveq.l #0,%d0
                movec.l %d0,%acr0
                movec.l %d0,%acr1
                movec.l %d0,%cacr
                jmp     1f
1:

                //
                // Disable watchdog and test logic safeguard (9.3.2).
                //
                clr.w   SCM_CWCR
                clr.l   CCM_TEST

                //
                // Setup stack pointer.
                //
                lea.l   kernel_stack,%sp

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                move.l  #_sbss,%a0
                move.l  #_ebss,%a1
1:              cmp.l   %a0,%a1
                beq.s   2f
                clr.b   (%a0)+
                bra.s   1b
2:

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jsr     _ada_main

dead:           jmp     .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

