
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .sect   .text,"ax"

                .global vectors
vectors:

SP_Main:        .long   0
                .extern _start
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

