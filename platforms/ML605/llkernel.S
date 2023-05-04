
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

                .sect   .vectors,"ax"

                .global _reset
_reset:

                // Reset
                //.org    0x00
                .extern _start
                brid    _start
                nop

                // User Vector (Exception)
                //.org    0x08
                nop
                nop

                // Interrupt
                //.org    0x10
                brid    timerirq
                nop

                // Break
                //.org    0x18
                nop
                nop

                // Hardware Exception
                //.org    0x20
                nop
                nop

                //
                // Reserved for future use
                //
                .space  0x28

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global timerirq
timerirq:
                addi    r1,r1,-120
                swi     r2,r1,0
                swi     r3,r1,4
                swi     r4,r1,8
                swi     r5,r1,12
                swi     r6,r1,16
                swi     r7,r1,20
                swi     r8,r1,24
                swi     r9,r1,28
                swi     r10,r1,32
                swi     r11,r1,36
                swi     r12,r1,40
                swi     r13,r1,44
                swi     r14,r1,48
                swi     r15,r1,52
                swi     r16,r1,56
                swi     r17,r1,60
                swi     r18,r1,64
                addi    r1,r1,-32
                .extern exception_process
                brlid   r15,exception_process
                nop
                addi    r1,r1,32
                lwi     r2,r1,0
                lwi     r3,r1,4
                lwi     r4,r1,8
                lwi     r5,r1,12
                lwi     r6,r1,16
                lwi     r7,r1,20
                lwi     r8,r1,24
                lwi     r9,r1,28
                lwi     r10,r1,32
                lwi     r11,r1,36
                lwi     r12,r1,40
                lwi     r13,r1,44
                lwi     r14,r1,48
                lwi     r15,r1,52
                lwi     r16,r1,56
                lwi     r17,r1,60
                lwi     r18,r1,64
                addi    r1,r1,120
                rtid    r14,0
                nop

