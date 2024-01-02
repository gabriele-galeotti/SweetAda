
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

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                addik   r1,r0,kernel_stack

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                addik   r3,r0,_sbss
                addik   r4,r0,_ebss
                brai    2f
1:              sbi     r0,r3,0
                addi    r3,r3,1
2:              cmpu    r18,r3,r4
                bnei    r18,1b

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bralid  r15,_ada_main
                nop

dead:           braid   .
                nop

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  256
kernel_stack:

