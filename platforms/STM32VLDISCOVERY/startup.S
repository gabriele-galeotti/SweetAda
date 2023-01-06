
//
// startup.S - STM32F405 startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global vectors
vectors:

SP_Main:        .long   0
Reset:          .long   _start
NMI:            .long   0
HardFault:      .long   0
ReservedExc4:   .long   0
ReservedExc5:   .long   0
ReservedExc6:   .long   0
ReservedExc7:   .long   0
ReservedExc8:   .long   0
ReservedExc9:   .long   0
ReservedExcA:   .long   0
SVCall:         .long   0
ReservedExcC:   .long   0
ReservedExcD:   .long   0
PendSV:         .long   0
SysTick:        .long   0

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                ldr     r0,=stack
                mov     sp,r0

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
stack:

