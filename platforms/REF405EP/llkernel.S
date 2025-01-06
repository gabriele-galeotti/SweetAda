
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <ppc405ep.h>

////////////////////////////////////////////////////////////////////////////////

#define UART0_IRQ_ID 0x0500
#define GPT0_IRQ_ID  0x0501
#define PIT_IRQ_ID   0x1000
#define FIT_IRQ_ID   0x1010

#define UART0_BASE 0xEF600300
#define UART0_RHR  (UART0_BASE + 0)

#define EXCEPTION(x, name) \
                . = x    ; \
name:

//
// - use SPRG1 as a scratch register for r1
// - exception stack in SPRG0
// - push exception frame
// - save r0
// - save r1
// - ...
// - save lr, cr, ctr, xer
// - call conventions uses 0(r1) and 4(r1)
//
#define EXCEPTION_ENTRY \
                mtsprg1 r1         ; \
                mfsprg0 r1         ; \
                addi    r1,r1,-80  ; \
                stw     r0,0(r1)   ; \
                mfsprg1 r0         ; \
                stw     r0,4(r1)   ; \
                stw     r2,8(r1)   ; \
                stw     r3,12(r1)  ; \
                stw     r4,16(r1)  ; \
                stw     r5,20(r1)  ; \
                stw     r6,24(r1)  ; \
                stw     r7,28(r1)  ; \
                stw     r8,32(r1)  ; \
                stw     r9,36(r1)  ; \
                stw     r10,40(r1) ; \
                stw     r11,44(r1) ; \
                stw     r12,48(r1) ; \
                mflr    r0         ; \
                stw     r0,52(r1)  ; \
                mfcr    r0         ; \
                stw     r0,56(r1)  ; \
                mfctr   r0         ; \
                stw     r0,60(r1)  ; \
                mfxer   r0         ; \
                stw     r0,64(r1)  ; \
                addi    r1,r1,-16

//
// - pop ABI frame
// - restore lr, cr, ctr, xer
// - restore r0
// - restore r2
// - ...
// - restore r1
//
#define EXCEPTION_EXIT \
                addi    r1,r1,16   ; \
                lwz     r0,52(r1)  ; \
                mtlr    r0         ; \
                lwz     r0,56(r1)  ; \
                mtcr    r0         ; \
                lwz     r0,60(r1)  ; \
                mtctr   r0         ; \
                lwz     r0,64(r1)  ; \
                mtxer   r0         ; \
                lwz     r0,0(r1)   ; \
                lwz     r2,8(r1)   ; \
                lwz     r3,12(r1)  ; \
                lwz     r4,16(r1)  ; \
                lwz     r5,20(r1)  ; \
                lwz     r6,24(r1)  ; \
                lwz     r7,28(r1)  ; \
                lwz     r8,32(r1)  ; \
                lwz     r9,36(r1)  ; \
                lwz     r10,40(r1) ; \
                lwz     r11,44(r1) ; \
                lwz     r12,48(r1) ; \
                lwz     r1,4(r1)

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .align  16
                .global ivtable
                .extern exception_fatal
ivtable:

                // Critical input interrupt
                EXCEPTION(0x0100, E_CriticalInputInterrupt)
                li      r1,10
                b       exception_fatal

                // Machine check
                EXCEPTION(0x0200, E_MachineCheck)
                li      r0,11
                b       exception_fatal

                // Data storage interrupt
                EXCEPTION(0x0300, E_DataStorageInterrupt)
                li      r0,12
                b       exception_fatal

                // Instruction storage interrupt
                EXCEPTION(0x0400, E_InstructionStorageInterrupt)
                li      r0,13
                b       exception_fatal

                // External interrupt
                EXCEPTION(0x0500, E_ExternalInterrupt)
                b       EXTINT_handler

                // Alignment
                EXCEPTION(0x0600, E_Alignment)
                li      r0,16
                b       exception_fatal

                // Program
                EXCEPTION(0x0700, E_Program)
                li      r0,16
                b       exception_fatal

                // FPU Unavailable
                EXCEPTION(0x0800, E_FPUUnavailable)
                li      r0,16
                b       exception_fatal

                // System Call
                EXCEPTION(0x0C00, E_SystemCall)
                li      r0,16
                b       irq_entry

                // PIT
                EXCEPTION(0x1000, E_PIT)
                b       PIT_handler

                // FIT
                EXCEPTION(0x1010, E_FIT)
                b       FIT_handler

                // Watchdog timer
                EXCEPTION(0x1020, E_WatchdogTimer)
                b       FIT_handler

                // Data TLB miss
                EXCEPTION(0x1100, E_DTLBMiss)
                li      r0,17
                b       exception_fatal

                // Instruction TLB miss
                EXCEPTION(0x1200, E_ITLBMiss)
                li      r0,18
                b       exception_fatal

                // Debug
                EXCEPTION(0x2000, E_Debug)
                li      r0,19
                b       exception_fatal

                //////////////////////////////////////////////////////////////
                //
                // EXINT handler.
                //
                //////////////////////////////////////////////////////////////
EXTINT_handler:
                EXCEPTION_ENTRY
                // __FIX__ check if general purpose timer?
                // read incoming character
                lis     r5,UART0_RHR@ha
                ori     r5,r5,UART0_RHR@l
                lbz     r0,0(r5)
                // clear interrupt flag in UIC0_SR
                // 10.5.1 UIC Status Register (UIC0_SR)
                lis     r3,U0IS@ha
                ori     r3,r3,U0IS@l
                mtdcr   UIC0_SR,r3
                // set irq identifier
                li      r3,UART0_IRQ_ID
                b       irq_entry

                //////////////////////////////////////////////////////////////
                //
                // PIT handler.
                //
                //////////////////////////////////////////////////////////////
PIT_handler:
                EXCEPTION_ENTRY
                // clear TSR PIS flag __FIX__ is it necessary?
                // 11.2 Programmable Interval Timer (PIT)
                lis     r3,PIS@ha
                ori     r3,r3,PIS@l
                mtspr   TSR,r3 // __FIX__ test PIS timer
                // set irq identifier
                li      r3,PIT_IRQ_ID
                b       irq_entry

                //////////////////////////////////////////////////////////////
                //
                // FIT handler.
                //
                //////////////////////////////////////////////////////////////
FIT_handler:
                EXCEPTION_ENTRY
                // clear TSR PIS flag __FIX__ is it necessary?
                // 11.2 Programmable Interval Timer (PIT)
                lis     r3,FIS@ha
                ori     r3,r3,FIS@l
                mtspr   TSR,r3
                // set irq identifier
                li      r3,FIT_IRQ_ID
                b       irq_entry

                //////////////////////////////////////////////////////////////
                //
                // Common entry routine.
                //
                //////////////////////////////////////////////////////////////
irq_entry:
                .extern exception_process
                bl      exception_process
                EXCEPTION_EXIT
                rfi

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .global exception_stack
                .align  3                               // EABI requires 8-byte (2^3) aligned stack
                .space  1024
exception_stack:

