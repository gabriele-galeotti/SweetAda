
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

                //
                // If the entry point is exactly @ 0xC0000000, QEMU seems to
                // think this is a Linux kernel and applies a sort of address
                // translation (see boot.c:nios2_load_kernel()), so to avoid
                // any kind of problems displace the entry point with a nop
                // instruction in order to avoid that.
                //
                nop

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
                // Call "adainit" procedure.
                //
                .extern adainit
                movhi   r1,%hiadj(adainit)
                addi    r1,r1,%lo(adainit)
                callr   r1

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                movhi   r1,%hiadj(_ada_main)
                addi    r1,r1,%lo(_ada_main)
                callr   r1

dead:           br      .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

