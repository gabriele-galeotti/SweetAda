
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .macro EXCEPTION handler,number
                .type   \handler,%function
                .global \handler
\handler:       mov     r0,#\number
                mov     r1,lr
                bl      exception_process
                .endm

////////////////////////////////////////////////////////////////////////////////

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
V_UndInstr:     .long   UndInstr_handler
V_SVC:          .long   SVC_handler
V_PAbort:       .long   PAbort_handler
V_DAbort:       .long   DAbort_handler
V_Notused:      .long   Notused_handler
V_IRQ:          .long   IRQ_handler
V_FIQ:          .long   FIQ_handler

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .extern exception_process
                .extern irq_process

                EXCEPTION UndInstr_handler,0x04
                EXCEPTION SVC_handler,0x08
                EXCEPTION PAbort_handler,0x0C
                EXCEPTION DAbort_handler,0x10
                EXCEPTION Notused_handler,0x14

                .type   FIQ_handler,%function
                .global FIQ_handler
FIQ_handler:
                // not supported
                subs    pc,lr,#4

                .type   IRQ_handler,%function
                .global IRQ_handler
IRQ_handler:
                stmfd   sp!,{r0-r3,r9,r12,lr}
                .extern irq_process
                bl      irq_process
                ldmfd   sp!,{r0-r3,r9,r12,lr}
                subs    pc,lr,#4

