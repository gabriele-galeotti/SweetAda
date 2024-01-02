
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointers (ISP and/or MSP).
                //
                // The active supervisor stack pointer out of reset is ISP.
                // Load ISP, then select and load MSP.
                //
                lea.l   isp_stack,%sp                   // load Interrupt SSP
//#if !defined(__mc68060__)
//                ori.w   #MBIT,%sr                       // select MSP
//                lea.l   msp_stack,%sp                   // load Master SSP
//#endif

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jsr     _ada_main

dead:           jmp     .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
isp_stack:

