
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
                // Setup stack pointer.
                //
                lis     r1,kernel_stack@highest
                ori     r1,r1,kernel_stack@higher
                sldi    r1,r1,32
                oris    r1,r1,kernel_stack@h
                ori     r1,r1,kernel_stack@l

                //
                // Setup TOC.
                //
                .extern _toc
                lis     r2,_toc@highest
                ori     r2,r2,_toc@higher
                sldi    r2,r2,32
                oris    r2,r2,_toc@h
                ori     r2,r2,_toc@l

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main
                nop

dead:           b       .
                nop

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  3
                .space  4096
kernel_stack:

