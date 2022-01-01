
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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

                //
                // Interrupts:
                // - waits for current instruction to complete
                // - save MSR[EE] to SRR1, clears MSR[EE]
                // - save PC to SRR0
                // - transfer control to n+0x100, etc
                //

                //
                // Interrupt vector table.
                // __REF__ PPC405EP Embedded Processor User’s Manual
                // 10.10 Critical and Noncritical Interrupts
                // __REF__
                // The Programming Environments For 32-Bit Microprocessors
                //

                .align  16
                .global ivtable
ivtable:

                //////////////////////////////////////////////////////////////

                // System Reset Exception
                // asynchronous/nonmaskable
                . = 0x0100
                li      r1,10
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Machine Check Exception
                // asynchronous/nonmaskable
                . = 0x0200
                li      r0,11
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // DSI (data storage) Exception
                . = 0x0300
                li      r0,12
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // ISI (instruction storage) Exception
                . = 0x0400
                li      r0,13
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // External interrupt
                // asynchronous/maskable
                . = 0x0500
                b       EXTINT_handler

                //////////////////////////////////////////////////////////////

                // Alignment Exception
                . = 0x0600
                li      r0,14
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Program Exception
                // synchronous/precise
                // happens with trap instructions
                . = 0x0700
                //SAVE_REGISTERS
                //li      r3,0x0700
                //b       irq_entry
                rfi

                //////////////////////////////////////////////////////////////

                // Floating-Point Unavailable Exception
                . = 0x0800
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Decrementer Exception
                // asynchronous/maskable
                . = 0x0900
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // System Call Exception
                . = 0x0C00
                li      r0,16
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Trace Exception (optional)
                . = 0x0D00
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Floating-Point Assist Exception (optional)
                . = 0x0E00
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // PIT interrupt
                . = 0x1000
                b       PIT_handler

                //////////////////////////////////////////////////////////////

                // FIT interrupt
                . = 0x1010
                b       FIT_handler

                //////////////////////////////////////////////////////////////

                // Data TLB miss
                . = 0x1100
                li      r0,17
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Instruction TLB miss
                . = 0x1200
                li      r0,18
                b       irq_entry

                //////////////////////////////////////////////////////////////

                // Debug offset
                . = 0x2000
                li      r0,19
                b       irq_entry

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

