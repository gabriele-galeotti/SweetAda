
//
// startup.S - DE10-Lite startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .set    noat
                movhi   r2,%hi(_start)
                ori     r2,r2,%lo(_start)
                jmp     r2

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                movia   sp,kernel_stack
                mov     fp,sp

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                movia   r2,adainit
                callr   r2

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                movia   r2,_ada_main
                callr   r2

dead:           br      .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

