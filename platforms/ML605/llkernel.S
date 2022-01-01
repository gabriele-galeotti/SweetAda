
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global timerirq
timerirq:
                addi    r1,r1,-40
                swi     r3,r1,0
                swi     r4,r1,4
                swi     r5,r1,8
                swi     r6,r1,12
                swi     r7,r1,16
                swi     r8,r1,20
                swi     r9,r1,24
                swi     r10,r1,28
                swi     r11,r1,32
                swi     r12,r1,36
                .extern exception_process
                brlid   r15,exception_process
                nop
                lwi     r3,r1,0
                lwi     r4,r1,4
                lwi     r5,r1,8
                lwi     r6,r1,12
                lwi     r7,r1,16
                lwi     r8,r1,20
                lwi     r9,r1,24
                lwi     r10,r1,28
                lwi     r11,r1,32
                lwi     r12,r1,36
                addi    r1,r1,40
                rtid    r14,8
                nop

