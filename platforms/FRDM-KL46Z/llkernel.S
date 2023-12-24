
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
Reset:          .long   _start                  //  1
NMI:            .long   0                       //  2
HardFault:      .long   0                       //  3
ReservedExc4:   .long   0                       //  4
ReservedExc5:   .long   0                       //  5
ReservedExc6:   .long   0                       //  6
ReservedExc7:   .long   0                       //  7
ReservedExc8:   .long   0                       //  8
ReservedExc9:   .long   0                       //  9
ReservedExcA:   .long   0                       // 10
SVCall:         .long   0                       // 11
ReservedExcC:   .long   0                       // 12
ReservedExcD:   .long   0                       // 13
PendSV:         .long   0                       // 14
SysTick:        .long   0                       // 15

