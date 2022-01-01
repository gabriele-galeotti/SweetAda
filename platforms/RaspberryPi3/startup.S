
//
// startup.S - RaspberryPI3 startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .arch   armv8-a

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                b       startcode

startcode:
                // allow only master core to prosecute
                mrs     x0,mpidr_el1
                mov     x1,#0xC1000000
                bic     x0,x0,x1
                cbz     x0,bootcore
hold:           b       hold

                //mrc     p15,0,x0,c0,c0,5
                // x0 & 0x3 contains core ID

bootcore:

                // setup stack
                ldr     w0,=SVC_stack
                mov     wsp,w0

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                bl      adainit

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
SVC_stack:

