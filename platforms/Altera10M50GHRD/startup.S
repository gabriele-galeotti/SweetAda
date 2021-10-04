
//
// startup.S - Altera 10M50 GHRD startup (QEMU emulator).
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

                .type   _start,@function
                .global _start
_start:
                //
                // Disable interrupts.
                //
                wrctl   status,r0
                wrctl   ienable,r0

                //
                // Setup stack pointer.
                //
                movhi   sp,%hiadj(kernel_stack)
                addi    sp,sp,%lo(kernel_stack)
                mov     fp,sp

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                movhi   r2,%hiadj(adainit)
                addi    r2,r2,%lo(adainit)
                callr   r2

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
                .space  4096
kernel_stack:

