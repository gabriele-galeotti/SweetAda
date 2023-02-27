
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
                // .data section relocation.
                //
                bl      movdata

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
// movdata                                                                    //
//                                                                            //
// Perform .data section relocation.                                          //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movdata:
                // registers used: r0-r4
                .extern _etext
                .extern _sdata
                .extern _edata
                ldr     r1,=_etext
                ldr     r2,=_sdata
                ldr     r3,=_edata
                cmp     r2,r3
                beq     2f
                sub     r3,r3,r2
                mov     r4,#0
1:              ldr     r0,[r1,r4]
                str     r0,[r2,r4]
                add     r4,#4
                cmp     r4,r3
                blt     1b
2:              bx      lr

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
stack:

