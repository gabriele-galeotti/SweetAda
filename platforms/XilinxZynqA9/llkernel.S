
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

                .sect   .vectors,"ax"

                .global vectors
vectors:

                ldr     pc,V_Reset                      // 0x00 Reset
                ldr     pc,V_UndInstr                   // 0x04 Undefined Instruction
                ldr     pc,V_SWI                        // 0x08 Software Interrupt
                ldr     pc,V_AbortP                     // 0x0C Abort (Prefetch)
                ldr     pc,V_AbortD                     // 0x10 Abort (Data)
                ldr     pc,V_AddrExc                    // 0x14 Address Exception
                ldr     pc,V_IRQ                        // 0x18 IRQ
                ldr     pc,V_FIQ                        // 0x1C FIQ

                .extern _start
V_Reset:        .long   _start
V_UndInstr:     .long   _start
V_SWI:          .long   _start
V_AbortP:       .long   _start
V_AbortD:       .long   _start
V_AddrExc:      .long   _start
V_IRQ:          .long   irq_handler
V_FIQ:          .long   _start

                .sect   .text,"ax"

                .type   irq_handler,%function
                .global irq_handler
irq_handler:
                stmfd   sp!,{r0-r3,r9,r12,lr}
                .extern irq_process
                bl      irq_process
                ldmfd   sp!,{r0-r3,r9,r12,lr}
                subs    pc,lr,#4

