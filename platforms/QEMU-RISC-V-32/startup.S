
//
// startup.S - RISC-V startup (QEMU emulator).
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
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
                // Setup stack.
                //
                la      sp,kernel_stack

                .extern vector
                la      t1,vector
                ori     t1,t1,1
                csrrw   x0,mtvec,t1

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                call    adainit

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                call    _ada_main

dead:           j       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

