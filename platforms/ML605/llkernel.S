
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

#define SAVE_REGS                        \
                swi     r3, r1, 0       ;\
                swi     r4, r1, 4       ;\
                swi     r5, r1, 8       ;\
                swi     r6, r1,12       ;\
                swi     r7, r1,16       ;\
                swi     r8, r1,20       ;\
                swi     r9, r1,24       ;\
                swi     r10,r1,28       ;\
                swi     r11,r1,32       ;\
                swi     r12,r1,36       ;\
                swi     r15,r1,40

#define RESTORE_REGS                     \
                lwi     r3, r1, 0       ;\
                lwi     r4, r1, 4       ;\
                lwi     r5, r1, 8       ;\
                lwi     r6, r1,12       ;\
                lwi     r7, r1,16       ;\
                lwi     r8, r1,20       ;\
                lwi     r9, r1,24       ;\
                lwi     r10,r1,28       ;\
                lwi     r11,r1,32       ;\
                lwi     r12,r1,36       ;\
                lwi     r15,r1,40

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global vectors
vectors:

                // Reset
                .org    0x00
                .extern _start
                brai    _start

                // User Vector (Exception)
                .org    0x08
                brai    0

                // Interrupt
                .org    0x10
                brai    timerirq

                // Break
                .org    0x18
                brai    0

                // Hardware Exception
                .org    0x20
                brai    0

                // Reserved for future use
                .org    0x28
                .space  0x28

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global timerirq
timerirq:
                addi    r1,r1,-11*4
                SAVE_REGS
                .extern exception_process
                bralid  r15,exception_process
                nop
                RESTORE_REGS
                addi    r1,r1,11*4
                rtid    r14,0
                nop

