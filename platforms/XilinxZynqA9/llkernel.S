
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

                .sect   .vectors,"ax"

                .global vectors
vectors:

                ldr     pc,V_Reset                      // 0x00 Reset
                ldr     pc,V_UndInstr                   // 0x04 Undefined Instruction
                ldr     pc,V_SVC                        // 0x08 Supervisor Call
                ldr     pc,V_PAbort                     // 0x0C Prefetch Abort
                ldr     pc,V_DAbort                     // 0x10 Data Abort
                ldr     pc,V_Notused                    // 0x14 Not used
                ldr     pc,V_IRQ                        // 0x18 IRQ interrupt
                ldr     pc,V_FIQ                        // 0x1C FIQ interrupt

                .extern _start
V_Reset:        .long   _start
V_UndInstr:     .long   _start
V_SVC:          .long   _start
V_PAbort:       .long   _start
V_DAbort:       .long   _start
V_Notused:      .long   _start
V_IRQ:          .long   irq_handler
V_FIQ:          .long   fiq_handler

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   fiq_handler,%function
                .global fiq_handler
fiq_handler:
                subs    pc,lr,#4

                .type   irq_handler,%function
                .global irq_handler
irq_handler:
                stmfd   sp!,{r0-r3,r9,r12,lr}
                .extern irq_process
                bl      irq_process
                ldmfd   sp!,{r0-r3,r9,r12,lr}
                subs    pc,lr,#4

