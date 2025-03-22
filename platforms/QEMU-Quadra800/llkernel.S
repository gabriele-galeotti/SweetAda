
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <m68k.h>

////////////////////////////////////////////////////////////////////////////////

#define SAVE_REGISTERS    movem.l %d0-%d1/%a0-%a1,%sp@-
#define RESTORE_REGISTERS movem.l %sp@+,%d0-%d1/%a0-%a1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text."ax"

                .align  4

                .global accfault_handler
                .global addrerr_handler
                .global illinstr_handler
                .global div0_handler
                .global chkinstr_handler
                .global ftrapcc_handler
                .global privilegev_handler
                .global trace_handler
                .global line1010_handler
                .global line1111_handler
                .global cprotocolv_handler
                .global formaterr_handler
                .global uninitint_handler
                .global spuriousint_handler
                .global l1autovector_handler
                .global l2autovector_handler
                .global l3autovector_handler
                .global l4autovector_handler
                .global l5autovector_handler
                .global l6autovector_handler
                .global l7autovector_handler
                .global trap0_handler
                .global trap1_handler
                .global trap2_handler
                .global trap3_handler
                .global trap4_handler
                .global trap5_handler
                .global trap6_handler
                .global trap7_handler
                .global trap8_handler
                .global trap9_handler
                .global trap10_handler
                .global trap11_handler
                .global trap12_handler
                .global trap13_handler
                .global trap14_handler
                .global trap15_handler

//
// Error handlers.
//

accfault_handler:
                pea     ACCESS_FAULT
                jmp     exception_entry

addrerr_handler:
                pea     ADDRESS_ERROR
                jmp     exception_entry

illinstr_handler:
                pea     ILLEGAL_INSTRUCTION
                jmp     exception_entry

div0_handler:
                //pea     INTEGER_DIVIDE_BY_ZERO
                jmp     exception_entry

chkinstr_handler:
                //pea     CHK_CHK2_INSTRUCTION
                jmp     exception_entry

ftrapcc_handler:
                //pea     FTRAPcc_TRAPcc_TRAPV_INSTRUCTIONS
                jmp     exception_entry

privilegev_handler:
                pea     PRIVILEGE_VIOLATION
                jmp     exception_entry

trace_handler:
                //pea     TRACE_EXCEPTION
                jmp     exception_entry

line1010_handler:
                //pea     LINE_1010_EMULATOR
                jmp     exception_entry

line1111_handler:
                //pea     LINE_1111_EMULATOR
                jmp     exception_entry

cprotocolv_handler:
                //pea     COPROCESSOR_PROTOCOL_VIOLATION
                jmp     exception_entry

formaterr_handler:
                //pea
                jmp     exception_entry

uninitint_handler:
                //pea
                jmp     exception_entry

spuriousint_handler:
                //pea
                jmp     exception_entry

//
// Trap instruction handler.
//
// Stack layout:
//
// sp@(0)  d0                     (4)
// sp@(4)  d1                     (4)
// sp@(8)  a0                     (4)
// sp@(12) a1                     (4)
// sp@(16) status register        (2)
// sp@(18) program counter        (4)
// sp@(22) format + vector offset (2)
//

syscalls_table:
                .long   0

trapinstr_handler:
                rte

//
// External-interrupt handlers.
//

l1autovector_handler:
                //pea     LEVEL1_AUTOVECTOR
                jmp     irq_entry
l2autovector_handler:
                //pea     LEVEL2_AUTOVECTOR
                jmp     irq_entry
l3autovector_handler:
                //pea     LEVEL3_AUTOVECTOR
                jmp     irq_entry
l4autovector_handler:
                //pea     LEVEL4_AUTOVECTOR
                jmp     irq_entry
l5autovector_handler:
                //pea     LEVEL5_AUTOVECTOR
                jmp     irq_entry
l6autovector_handler:
                //pea     LEVEL6_AUTOVECTOR
                jmp     irq_entry
l7autovector_handler:
                //pea     LEVEL7_AUTOVECTOR
                jmp     irq_entry

trap0_handler:
trap1_handler:
trap2_handler:
trap3_handler:
trap4_handler:
trap5_handler:
trap6_handler:
trap7_handler:
trap8_handler:
trap9_handler:
trap10_handler:
trap11_handler:
trap12_handler:
trap13_handler:
trap14_handler:
trap15_handler:

//
// User interrupt handlers.
//

userirq0_handler:
                //pea     USERIRQ0
                jmp     irq_entry
userirq1_handler:
                //pea     USERIRQ1
                jmp     irq_entry
userirq2_handler:
                //pea     USERIRQ2
                jmp     irq_entry
userirq3_handler:
                //pea     USERIRQ3
                jmp     irq_entry
userirq4_handler:
                //pea     USERIRQ4
                jmp     irq_entry
userirq5_handler:
                //pea     USERIRQ5
                jmp     irq_entry
userirq6_handler:
                //pea     USERIRQ6
                jmp     irq_entry
userirq7_handler:
                //pea     USERIRQ7
                jmp     irq_entry
userirq8_handler:
                //pea     USERIRQ8
                jmp     irq_entry
userirq9_handler:
                //pea     USERIRQ9
                jmp     irq_entry
userirq10_handler:
                //pea     USERIRQ10
                jmp     irq_entry
userirq11_handler:
                //pea     USERIRQ11
                jmp     irq_entry
userirq12_handler:
                //pea     USERIRQ12
                jmp     irq_entry
userirq13_handler:
                //pea     USERIRQ13
                jmp     irq_entry
userirq14_handler:
                //pea     USERIRQ14
                jmp     irq_entry
userirq15_handler:
                //pea     USERIRQ15
                jmp     irq_entry
userirq16_handler:
                //pea     USERIRQ16
                jmp     irq_entry
userirq17_handler:
                //pea     USERIRQ17
                jmp     irq_entry
userirq18_handler:
                //pea     USERIRQ18
                jmp     irq_entry
userirq19_handler:
                //pea     USERIRQ19
                jmp     irq_entry
userirq20_handler:
                //pea     USERIRQ20
                jmp     irq_entry
userirq21_handler:
                //pea     USERIRQ21
                jmp     irq_entry
userirq22_handler:
                //pea     USERIRQ22
                jmp     irq_entry
userirq23_handler:
                //pea     USERIRQ23
                jmp     irq_entry
userirq24_handler:
                //pea     USERIRQ24
                jmp     irq_entry
userirq25_handler:
                //pea     USERIRQ25
                jmp     irq_entry
userirq26_handler:
                //pea     USERIRQ26
                jmp     irq_entry
userirq27_handler:
                //pea     USERIRQ27
                jmp     irq_entry
userirq28_handler:
                //pea     USERIRQ28
                jmp     irq_entry
userirq29_handler:
                //pea     USERIRQ29
                jmp     irq_entry
userirq30_handler:
                //pea     USERIRQ30
                jmp     irq_entry
userirq31_handler:
                //pea     USERIRQ31
                jmp     irq_entry

//
// Stack layout:
//
// sp@(0)  d0                     (4)
// sp@(4)  d1                     (4)
// sp@(8)  a0                     (4)
// sp@(12) a1                     (4)
// sp@(16) exception #            (4)
// sp@(20) status register        (2)
// sp@(22) program counter        (4)
// sp@(26) format + vector offset (2)
//

                .extern exception_process
exception_entry:
                rte

                .extern irq_dispatcher
irq_entry:
                rte

