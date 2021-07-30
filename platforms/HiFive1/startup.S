
//
// startup.S - HiFive1 startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
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

                // disable all interrupts (the default program, which runs
                // with interrupts enabled, will be stopped due to halt
                // command in OpenOCD)
                li      t0,0xb
                csrrc   t1,mstatus,t0

                // setup stack
                la      sp,kernel_stack

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
                .space  1024
kernel_stack:

