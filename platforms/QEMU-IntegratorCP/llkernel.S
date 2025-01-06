
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <armv4.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global V_Reset

                ldr     pc,V_Reset                      // 0x00 Reset
                ldr     pc,V_UndInstr                   // 0x04 Undefined Instruction
                ldr     pc,V_SWI                        // 0x08 Software Interrupt
                ldr     pc,V_AbortP                     // 0x0C Abort (Prefetch)
                ldr     pc,V_AbortD                     // 0x10 Abort (Data)
                ldr     pc,V_AddrExc                    // 0x14 Address Exception -- reserved
                ldr     pc,V_IRQ                        // 0x18 IRQ
                ldr     pc,V_FIQ                        // 0x1C FIQ

                .extern _start
V_Reset:        .long   _start
V_UndInstr:     .long   und_handler
V_SWI:          .long   swi_handler
V_AbortP:       .long   abortp_handler
V_AbortD:       .long   abortd_handler
V_AddrExc:      .long   addrexc_handler
V_IRQ:          .long   irq_handler
V_FIQ:          .long   fiq_handler

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

und_handler:
                mov     r0,#UNDEFINSTR_CODE
                b       exc_handler
swi_handler:
                mov     r0,#SWI_CODE
                b       exc_handler
abortp_handler:
                mov     r0,#ABORT_PREFETCH_CODE
                b       exc_handler
abortd_handler:
                mov     r0,#ABORT_DATA_CODE
                b       exc_handler
addrexc_handler:
                mov     r0,#ADDRESS_EXCEPTION_CODE
                b       exc_handler

                .type   exc_handler,%function
                .global exc_handler
exc_handler:
                mov     r1,lr
                mov     r13,#IR|Mode_SVC
                msr     spsr_c,r13
                .extern exception_process
                ldr     lr,=exception_process
                movs    pc,lr
                .size   exc_handler,.-exc_handler

                .type   irq_handler,%function
                .global irq_handler
irq_handler:
                stmfd   sp!,{r0-r3,r9,r12,lr}
                .extern irq_process
                bl      irq_process
                ldmfd   sp!,{r0-r3,r9,r12,lr}
                subs    pc,lr,#4
                .size   irq_handler,.-irq_handler

                .type   fiq_handler,%function
                .global fiq_handler
fiq_handler:
                subs    pc,lr,#4
                .size   fiq_handler,.-fiq_handler

