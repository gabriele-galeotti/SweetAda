
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                movhi   sp,%hiadj(kernel_stack)
                addi    sp,sp,%lo(kernel_stack)
                mov     fp,sp

                //
                // Setup global pointer.
                //
                .extern _gp
                movhi   gp,%hiadj(_gp)
                addi    gp,gp,%lo(_gp)

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                movhi   r2,%hiadj(_ada_main)
                addi    r2,r2,%lo(_ada_main)
                callr   r2

dead:           br      .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
kernel_stack:

