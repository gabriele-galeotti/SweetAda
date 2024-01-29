
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
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

// non-core vectors

Interrupt0:     .long   0                       // 16
Interrupt1:     .long   0                       // 17
Interrupt2:     .long   0                       // 18
Interrupt3:     .long   0                       // 19
Interrupt4:     .long   0                       // 20
Interrupt5:     .long   0                       // 21
Interrupt6:     .long   0                       // 22
Interrupt7:     .long   0                       // 23
Interrupt8:     .long   0                       // 24
Interrupt9:     .long   0                       // 25
Interrupt10:    .long   0                       // 26
Interrupt11:    .long   0                       // 27
Interrupt12:    .long   0                       // 28
Interrupt13:    .long   0                       // 29
Interrupt14:    .long   0                       // 30
Interrupt15:    .long   0                       // 31
Interrupt16:    .long   0                       // 32
Interrupt17:    .long   0                       // 33
Interrupt18:    .long   0                       // 34
Interrupt19:    .long   0                       // 35
Interrupt20:    .long   0                       // 36
Interrupt21:    .long   0                       // 37
Interrupt22:    .long   0                       // 38
Interrupt23:    .long   0                       // 39
Interrupt24:    .long   0                       // 40
Interrupt25:    .long   0                       // 41
Interrupt26:    .long   0                       // 42
Interrupt27:    .long   0                       // 43
Interrupt28:    .long   0                       // 44
Interrupt29:    .long   0                       // 45
Interrupt30:    .long   0                       // 46
Interrupt31:    .long   0                       // 47

