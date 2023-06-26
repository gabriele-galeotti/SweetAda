
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <m68k.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

#define INITIALSP 0

                .extern _start
#define INITIALPC _start

                .global vectors
vectors:

initialsp:      .long   INITIALSP               // 000 0x0000 -
initialpc:      .long   INITIALPC               // 001 0x0004 -
buserr:         .long   buserr_handler          // 002 0x0008 -
addrerr:        .long   addrerr_handler         // 003 0x000C -
illinstr:       .long   illinstr_handler        // 004 0x0010 -
div0:           .long   div0_handler            // 005 0x0014 -
chkinstr:       .long   chkinstr_handler        // 006 0x0018 -
trapc:          .long   trapc_handler           // 007 0x001C -
privilegev:     .long   privilegev_handler      // 008 0x0020 -
trace:          .long   trace_handler           // 009 0x0024 -
line1010:       .long   line1010_handler        // 010 0x0028 -
line1111:       .long   line1111_handler        // 011 0x002C -
reserved1:      .long   0                       // 012 0x0030 -
cprotocolv:     .long   cprotocolv_handler      // 013 0x0034 -
formaterr:      .long   formaterr_handler       // 014 0x0038 -
uninitint:      .long   uninitint_handler       // 015 0x003C -
reserved2:      .long   0                       // 016 0x0040 -
reserved3:      .long   0                       // 017 0x0044 -
reserved4:      .long   0                       // 018 0x0048 -
reserved5:      .long   0                       // 019 0x004C -
reserved6:      .long   0                       // 020 0x0050 -
reserved7:      .long   0                       // 021 0x0054 -
reserved8:      .long   0                       // 022 0x0058 -
reserved9:      .long   0                       // 023 0x005C -
spurious:       .long   spurious_handler        // 024 0x0060 -
l1autovector:   .long   l1autovector_handler    // 025 0x0064 -
l2autovector:   .long   l2autovector_handler    // 026 0x0068 -
l3autovector:   .long   l3autovector_handler    // 027 0x006C -
l4autovector:   .long   l4autovector_handler    // 028 0x0070 -
l5autovector:   .long   l5autovector_handler    // 029 0x0074 -
l6autovector:   .long   l6autovector_handler    // 030 0x0078 -
l7autovector:   .long   l7autovector_handler    // 031 0x007C -
trap0:          .long   trap0_handler           // 032 0x0080 -
trap1:          .long   trap1_handler           // 033 0x0084 -
trap2:          .long   trap2_handler           // 034 0x0088 -
trap3:          .long   trap3_handler           // 035 0x008C -
trap4:          .long   trap4_handler           // 036 0x0090 -
trap5:          .long   trap5_handler           // 037 0x0094 -
trap6:          .long   trap6_handler           // 038 0x0098 -
trap7:          .long   trap7_handler           // 039 0x009C -
trap8:          .long   trap8_handler           // 040 0x00A0 -
trap9:          .long   trap9_handler           // 041 0x00A4 -
trap10:         .long   trap10_handler          // 042 0x00A8 -
trap11:         .long   trap11_handler          // 043 0x00AC -
trap12:         .long   trap12_handler          // 044 0x00B0 -
trap13:         .long   trap13_handler          // 045 0x00B4 -
trap14:         .long   trap14_handler          // 046 0x00B8 -
trap15:         .long   trap15_handler          // 047 0x00BC -
fpunordcond:    .long   0                       // 048 0x00C0 -
fpinexact:      .long   0                       // 049 0x00C4 -
fpdiv0:         .long   0                       // 050 0x00C8 -
fpundeflow:     .long   0                       // 051 0x00CC -
fpoperror:      .long   0                       // 052 0x00D0 -
fpoverflow:     .long   0                       // 053 0x00D4 -
fpsignan:       .long   0                       // 054 0x00D8 -
fpunimpdata:    .long   0                       // 055 0x00DC unassigned, reserved for MC68020
mmuconferror:   .long   0                       // 056 0x00E0 defined for MC68030 and MC68851, not used by MC68040
mmuilloperror:  .long   0                       // 057 0x00E4 defined for MC68851, not used by MC68030/MC68040
mmuacclevviol:  .long   0                       // 058 0x00E8 defined for MC68851, not used by MC68030/MC68040
reserved10:     .long   0                       // 059 0x00EC -
reserved11:     .long   0                       // 060 0x00F0 -
reserved12:     .long   0                       // 061 0x00F4 -
reserved13:     .long   0                       // 062 0x00F8 -
reserved14:     .long   0                       // 063 0x00FC -

                // User Defined Vectors (192)
                .space  192*4

////////////////////////////////////////////////////////////////////////////////

#define SAVE_REGS    movem.l %d0-%d1/%a0-%a1,%sp@-
#define RESTORE_REGS movem.l %sp@+,%d0-%d1/%a0-%a1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text."ax"

                .align  4

//
// Exception handlers.
//

                .global buserr_handler
                .global addrerr_handler
                .global illinstr_handler
                .global div0_handler
                .global chkinstr_handler
                .global trapc_handler
                .global privilegev_handler
                .global trace_handler
                .global line1010_handler
                .global line1111_handler
                .global cprotocolv_handler
                .global formaterr_handler
                .global uninitint_handler
                .global spurious_handler
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

buserr_handler:
                pea     BUS_ERROR
                jmp     exception_entry

addrerr_handler:
                pea     ADDRESS_ERROR
                jmp     exception_entry

illinstr_handler:
                pea     ILLEGAL_INSTRUCTION
                jmp     exception_entry

div0_handler:
                //pea     DIVISION_BY_ZERO
                jmp     exception_entry

chkinstr_handler:
                //pea     CHECK_INSTRUCTION
                jmp     exception_entry

trapc_handler:
                //pea     TRAP_CONDITION
                jmp     exception_entry

privilegev_handler:
                pea     PRIVILEGE_VIOLATION
                jmp     exception_entry

trace_handler:
                //pea     TRACE_EXCEPTION
                jmp     exception_entry

line1010_handler:
                //pea     ALINE_EXCEPTION
                jmp     exception_entry

line1111_handler:
                //pea     FLINE_EXCEPTION
                jmp     exception_entry

cprotocolv_handler:
                //pea     CP_PROTOCOL
                jmp     exception_entry

formaterr_handler:
                //pea
                jmp     exception_entry

uninitint_handler:
                //pea
                jmp     exception_entry

spurious_handler:
                //pea
                jmp     exception_entry

//
// Trap instruction handler.
//
// stack layout:
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
// stack layout:
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

