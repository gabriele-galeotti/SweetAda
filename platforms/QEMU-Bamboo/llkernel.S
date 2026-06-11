
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2026 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <ppc440ep.h>

////////////////////////////////////////////////////////////////////////////////

#define DEC_IRQ_ID 0x0B00
#define FIT_IRQ_ID 0x0C00

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
                // IVOR0
                EXCEPTION(0x0100, E_CriticalInputInterrupt)
                li      r1,0x100
                b       exception_fatal

                // Machine check
                // IVOR1
                EXCEPTION(0x0200, E_MachineCheck)
                li      r0,0x200
                b       exception_fatal

                // Data storage interrupt
                // IVOR2
                EXCEPTION(0x0300, E_DataStorageInterrupt)
                li      r0,0x300
                b       exception_fatal

                // Instruction storage interrupt
                // IVOR3
                EXCEPTION(0x0400, E_InstructionStorageInterrupt)
                li      r0,0x400
                b       exception_fatal

                // External input
                // IVOR4
                EXCEPTION(0x0500, E_ExternalInput)
                li      r0,0x500
                b       exception_fatal

                // Alignment
                // IVOR5
                EXCEPTION(0x0600, E_Alignment)
                li      r0,0x600
                b       exception_fatal

                // Program
                // IVOR6
                EXCEPTION(0x0700, E_Program)
                li      r0,0x700
                b       exception_fatal

                // FPU Unavailable
                // IVOR7
                EXCEPTION(0x0800, E_FPUUnavailable)
                li      r0,0x800
                b       exception_fatal

                // System Call
                // IVOR8
                EXCEPTION(0x0900, E_SystemCall)
                li      r0,0x900
                b       exception_fatal

                // AP Unavailable
                // IVOR9
                EXCEPTION(0x0A00, E_APUnavailable)
                li      r0,0xA00
                b       exception_fatal

                // Decrementer
                // IVOR10
                EXCEPTION(0x0B00, E_Decrementer)
                b       DEC_handler

                // Fixed Interval Timer
                // IVOR11
                EXCEPTION(0x0C00, E_FixedIntervalTimer)
                li      r0,0xC00
                b       exception_fatal

                // Watchdog timer
                // IVOR12
                EXCEPTION(0x0D00, E_WatchdogTimer)
                li      r0,0xD00
                b       exception_fatal

                // Data TLB Error
                // IVOR13
                EXCEPTION(0x0E00, E_DataTLBError)
                li      r0,0xE00
                b       exception_fatal

                // Instruction TLB Error
                // IVOR14
                EXCEPTION(0x0F00, E_InstructionTLBError)
                li      r0,0xF00
                b       exception_fatal

                // Debug
                // IVOR15
                EXCEPTION(0x1000, E_Debug)
                li      r0,0x1000
                b       exception_fatal

                //////////////////////////////////////////////////////////////
                //
                // Decrementer handler.
                //
                //////////////////////////////////////////////////////////////
DEC_handler:
                EXCEPTION_ENTRY
                li      r3,DEC_IRQ_ID
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

