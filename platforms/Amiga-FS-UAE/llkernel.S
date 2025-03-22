
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

                .sect   .vectors,"ax"

                .extern _start
#define INITIALSP 0x11114EF9 // 1111 = 256k ROM, 4EF9 = jmp

                .global vectors_table
vectors_table:
                                                // #   offset
initialsp:      .long   INITIALSP               // 000 0x0000 -
initialpc:      .long   _start                  // 001 0x0004 -
accessfault:    .long   VH_accessfault          // 002 0x0008 -
addresserr:     .long   VH_addresserr           // 003 0x000C -
illinstr:       .long   VH_illinstr             // 004 0x0010 -
div0:           .long   VH_div0                 // 005 0x0014 -
chkinstr:       .long   VH_chkinstr             // 006 0x0018 -
ftrapcc:        .long   VH_ftrapcc              // 007 0x001C -
privilegev:     .long   VH_privilegev           // 008 0x0020 -
trace:          .long   VH_trace                // 009 0x0024 -
line1010:       .long   VH_line1010             // 010 0x0028 -
line1111:       .long   VH_line1111             // 011 0x002C -
reserved1:      .long   VH_default              // 012 0x0030 -
cpprotocolv:    .long   VH_cpprotocolv          // 013 0x0034 -
formaterr:      .long   VH_formaterr            // 014 0x0038 -
uninitint:      .long   VH_uninitint            // 015 0x003C -
reserved2:      .long   VH_default              // 016 0x0040 -
reserved3:      .long   VH_default              // 017 0x0044 -
reserved4:      .long   VH_default              // 018 0x0048 -
reserved5:      .long   VH_default              // 019 0x004C -
reserved6:      .long   VH_default              // 020 0x0050 -
reserved7:      .long   VH_default              // 021 0x0054 -
reserved8:      .long   VH_default              // 022 0x0058 -
reserved9:      .long   VH_default              // 023 0x005C -
spuriousint:    .long   VH_spuriousint          // 024 0x0060 -
l1autovector:   .long   VH_l1autovector         // 025 0x0064 -
l2autovector:   .long   VH_l2autovector         // 026 0x0068 -
l3autovector:   .long   VH_l3autovector         // 027 0x006C -
l4autovector:   .long   VH_l4autovector         // 028 0x0070 -
l5autovector:   .long   VH_l5autovector         // 029 0x0074 -
l6autovector:   .long   VH_l6autovector         // 030 0x0078 -
l7autovector:   .long   VH_l7autovector         // 031 0x007C -
trap0:          .long   VH_trap0                // 032 0x0080 -
trap1:          .long   VH_trap1                // 033 0x0084 -
trap2:          .long   VH_trap2                // 034 0x0088 -
trap3:          .long   VH_trap3                // 035 0x008C -
trap4:          .long   VH_trap4                // 036 0x0090 -
trap5:          .long   VH_trap5                // 037 0x0094 -
trap6:          .long   VH_trap6                // 038 0x0098 -
trap7:          .long   VH_trap7                // 039 0x009C -
trap8:          .long   VH_trap8                // 040 0x00A0 -
trap9:          .long   VH_trap9                // 041 0x00A4 -
trap10:         .long   VH_trap10               // 042 0x00A8 -
trap11:         .long   VH_trap11               // 043 0x00AC -
trap12:         .long   VH_trap12               // 044 0x00B0 -
trap13:         .long   VH_trap13               // 045 0x00B4 -
trap14:         .long   VH_trap14               // 046 0x00B8 -
trap15:         .long   VH_trap15               // 047 0x00BC -
fpunordcond:    .long   VH_default              // 048 0x00C0 -
fpinexact:      .long   VH_default              // 049 0x00C4 -
fpdiv0:         .long   VH_default              // 050 0x00C8 -
fpundeflow:     .long   VH_default              // 051 0x00CC -
fpoperr:        .long   VH_default              // 052 0x00D0 -
fpoverflow:     .long   VH_default              // 053 0x00D4 -
fpsignan:       .long   VH_default              // 054 0x00D8 -
fpunimpdata:    .long   VH_default              // 055 0x00DC unassigned, reserved for MC68020
mmuconferr:     .long   VH_default              // 056 0x00E0 defined for MC68030 and MC68851, not used by MC68040
mmuilloperr:    .long   VH_default              // 057 0x00E4 defined for MC68851, not used by MC68030/MC68040
mmuacclverr:    .long   VH_default              // 058 0x00E8 defined for MC68851, not used by MC68030/MC68040
reserved10:     .long   VH_default              // 059 0x00EC -
reserved11:     .long   VH_default              // 060 0x00F0 -
reserved12:     .long   VH_default              // 061 0x00F4 -
reserved13:     .long   VH_default              // 062 0x00F8 -
reserved14:     .long   VH_default              // 063 0x00FC -

                // User Defined Vectors (192 vectors)
                .space  192*4

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .align  4
                .global VH_accessfault
VH_accessfault:
                pea     ACCESS_FAULT
                jmp     exception_entry

                .align  4
                .global VH_addresserr
VH_addresserr:
                pea     ADDRESS_ERROR
                jmp     exception_entry

                .align  4
                .global VH_illinstr
VH_illinstr:
                pea     ILLEGAL_INSTRUCTION
                jmp     exception_entry

                .align  4
                .global VH_div0
VH_div0:
                pea     INTEGER_DIVIDE_BY_ZERO
                jmp     exception_entry

                .align  4
                .global VH_chkinstr
VH_chkinstr:
                pea     CHK_CHK2_INSTRUCTION
                jmp     exception_entry

                .align  4
                .global VH_ftrapcc
VH_ftrapcc:
                pea     FTRAPcc_TRAPcc_TRAPV_INSTRUCTIONS
                jmp     exception_entry

                .align  4
                .global VH_privilegev
VH_privilegev:
                pea     PRIVILEGE_VIOLATION
                jmp     exception_entry

                .align  4
                .global VH_trace
VH_trace:
                // for register-to-memory transfers, only control alterable
                // addressing modes or the predecrement addressing mode are
                // allowed
                .extern gdbstub_data_area
                //
                move.w  %sr,sr_save
                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts
                //
                move.l  %a6,%sp@-                       // save temporarily A6
                lea.l   gdbstub_data_area,%a6           // A6 points to gdbstub_data_area[D0]
                add.l   #(4*14),%a6                     // add A6 offset, will be pre-decremented to A5
                movem.l %d0-%d7/%a0-%a5,%a6@-           // save D0-D7,A0-A5, order: A5->A0,D7->D0
                move.l  %sp@+,%d0                       // restore temporarily saved A6 from stack in D0, current A6 still points to gdbstub_data_area[D0]
                move.l  %d0,%a6@(4*14)                  // save A6
                // take SSP (USP if exception in user mode) __FIX__ remember we are in throwaway ISP (2 stack frames)
                move.l  %sp,%d0                         // A7
                addi.l  #TRACE_FRAME_SIZE,%d0           // adjust with frame size
                move.l  %d0,%a6@(4*15)                  // save A7
                //
                clr.l   %d0
                move.w  %sp@(0),%d0                     // get SR from stack
                move.l  %d0,%a6@(4*16)
                move.l  %sp@(2),%d0                     // get PC from stack
                move.l  %d0,%a6@(4*17)
                // high-level processing
                move.l  #TRACE,%d0                      // exception identifier
                move.l  %sp,%d1                         // exception frame address
                move.l  %d1,%sp@-                       // push as 2nd argument
                move.l  %d0,%sp@-                       // push as 1st argument
                .extern exception_process
                jsr     exception_process
                addq.l  #8,%sp                          // discard arguments
                // restore all registers (except SP)
                lea.l   gdbstub_data_area,%a6           // A6 points to gdbstub_data_area[D0]
                move.l  %a6@(4*16),%d0                  // load SR
                move.w  %d0,%sp@(0)                     // insert in exception-saved SR
                move.l  %a6@(4*17),%d0                  // load PC
                move.l  %d0,%sp@(2)                     // insert in exception-saved PC
                move.l  %a6@(4*14),%d0                  // load A6 in D0 and push it in the stack
                move.l  %d0,%sp@-
                movem.l %a6@+,%d0-%d7/%a0-%a5           // restore D0-D7,A0-A5, order: A5->A0,D7->D0
                move.l  %sp@+,%a6                       // restore A6
                //
                move.w  sr_save,%sr
                rte

                .align  4
                .global VH_line1010
VH_line1010:
                pea     LINE_1010_EMULATOR
                jmp     exception_entry

                .align  4
                .global VH_line1111
VH_line1111:
                pea     LINE_1111_EMULATOR
                jmp     exception_entry

                .align  4
                .global VH_cpprotocolv
VH_cpprotocolv:
                pea     COPROCESSOR_PROTOCOL_VIOLATION
                jmp     exception_entry

                .align  4
                .global VH_formaterr
VH_formaterr:
                pea     FORMAT_ERROR
                jmp     exception_entry

                .align  4
                .global VH_uninitint
VH_uninitint:
                pea     UNINITIALIZED_INTERRUPT
                jmp     exception_entry

                .align  4
                .global VH_spuriousint
VH_spuriousint:
                pea     SPURIOUS_INTERRUPT
                jmp     exception_entry

                .align  4
                .global VH_l1autovector
VH_l1autovector:
                pea     LEVEL1_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_l2autovector
VH_l2autovector:
                pea     LEVEL2_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_l3autovector
VH_l3autovector:
                pea     LEVEL3_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_l4autovector
VH_l4autovector:
                pea     LEVEL4_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_l5autovector
VH_l5autovector:
                pea     LEVEL5_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_l6autovector
VH_l6autovector:
                pea     LEVEL6_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_l7autovector
VH_l7autovector:
                pea     LEVEL7_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global VH_trap0
VH_trap0:
                pea     TRAP_0
                jmp     exception_entry

                .align  4
                .global VH_trap1
VH_trap1:
                pea     TRAP_1
                jmp     exception_entry

                .align  4
                .global VH_trap2
VH_trap2:
                pea     TRAP_2
                jmp     exception_entry

                .align  4
                .global VH_trap3
VH_trap3:
                pea     TRAP_3
                jmp     exception_entry

                .align  4
                .global VH_trap4
VH_trap4:
                pea     TRAP_4
                jmp     exception_entry

                .align  4
                .global VH_trap5
VH_trap5:
                pea     TRAP_5
                jmp     exception_entry

                .align  4
                .global VH_trap6
VH_trap6:
                pea     TRAP_6
                jmp     exception_entry

                .align  4
                .global VH_trap7
VH_trap7:
                pea     TRAP_7
                jmp     exception_entry

                .align  4
                .global VH_trap8
VH_trap8:
                pea     TRAP_8
                jmp     exception_entry

                .align  4
                .global VH_trap9
VH_trap9:
                pea     TRAP_9
                jmp     exception_entry

                .align  4
                .global VH_trap10
VH_trap10:
                pea     TRAP_10
                jmp     exception_entry

                .align  4
                .global VH_trap11
VH_trap11:
                pea     TRAP_11
                jmp     exception_entry

                .align  4
                .global VH_trap12
VH_trap12:
                pea     TRAP_12
                jmp     exception_entry

                .align  4
                .global VH_trap13
VH_trap13:
                pea     TRAP_13
                jmp     exception_entry

                .align  4
                .global VH_trap14
VH_trap14:
                pea     TRAP_14
                jmp     exception_entry

                .align  4
                .global VH_trap15
VH_trap15:
                // TRAP for breakpoint handling
                // for register-to-memory transfers, only control alterable
                // addressing modes or the predecrement addressing mode are
                // allowed
                .extern gdbstub_data_area
                //
                move.w  %sr,sr_save
                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts
                //
                move.l  %a6,%sp@-                       // save temporarily A6
                lea.l   gdbstub_data_area,%a6           // A6 points to gdbstub_data_area[D0]
                add.l   #(4*14),%a6                     // add A6 offset, will be pre-decremented to A5
                movem.l %d0-%d7/%a0-%a5,%a6@-           // save D0-D7,A0-A5, order: A5->A0,D7->D0
                move.l  %sp@+,%d0                       // restore temporarily saved A6 from stack in D0, current A6 still points to gdbstub_data_area[D0]
                move.l  %d0,%a6@(4*14)                  // save A6
                // take SSP (USP if exception in user mode) __FIX__ remember we are in throwaway ISP (2 stack frames)
                move.l  %sp,%d0                         // A7
                addi.l  #TRAP_FRAME_SIZE,%d0            // adjust with frame size
                move.l  %d0,%a6@(4*15)                  // save A7
                //
                clr.l   %d0
                move.w  %sp@(0),%d0                     // get SR from stack
                move.l  %d0,%a6@(4*16)
                move.l  %sp@(2),%d0                     // get PC from stack
                move.l  %d0,%a6@(4*17)
                // high-level processing
                move.l  #TRAP_15,%d0                    // exception identifier
                move.l  %sp,%d1                         // exception frame address
                move.l  %d1,%sp@-                       // push as 2nd argument
                move.l  %d0,%sp@-                       // push as 1st argument
                .extern exception_process
                jsr     exception_process
                addq.l  #8,%sp                          // discard arguments
                // restore all registers (except SP)
                lea.l   gdbstub_data_area,%a6           // A6 points to gdbstub_data_area[D0]
                move.l  %a6@(4*16),%d0                  // load SR
                move.w  %d0,%sp@(0)                     // insert in exception-saved SR
                move.l  %a6@(4*17),%d0                  // load PC
                move.l  %d0,%sp@(2)                     // insert in exception-saved PC
                move.l  %a6@(4*14),%d0                  // load A6 in D0 and push it in the stack
                move.l  %d0,%sp@-
                movem.l %a6@+,%d0-%d7/%a0-%a5           // restore D0-D7,A0-A5, order: A5->A0,D7->D0
                move.l  %sp@+,%a6                       // restore A6
                //
                move.w  sr_save,%sr
                rte

exception_entry:
                //
                // HI   DATA
                //      F+V     +10 2 |
                //      PCL     +8  2 | FORMAT X
                //      PCH     +6  2 | FRAME
                //      SR      +4  2 |
                // LO   ID      +0  4
                //
                .extern exception_process
                SAVE_REGISTERS
                move.l  %sp@(16),%d0                    // get exception identifier
                move.l  %sp,%d1                         // get exception frame address
                move.l  %d1,%sp@-                       // push as 2nd argument
                move.l  %d0,%sp@-                       // push as 1st argument
                jsr     exception_process
                addq.l  #8,%sp                          // discard arguments
                RESTORE_REGISTERS
                addq.l  #4,%sp                          // discard exception identifier pushed by pea
                rte

irq_entry:
                //
                // HI   F+V     +10 2 |
                //      PCL     +8  2 | FORMAT 0
                //      PCH     +6  2 | FRAME
                //      SR      +4  2 |
                // LO   ID      +0  4
                //
                .extern irq_process
                //
                move.w  %sr,sr_save
                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts
                //
                SAVE_REGISTERS
                move.l  %sp@(16),%d0                    // get irq identifier
                move.l  %sp,%d1                         // get exception frame address
                move.l  %d1,%sp@-                       // push as 2nd argument
                move.l  %d0,%sp@-                       // push as 1st argument
                jsr     irq_process
                addq.l  #8,%sp                          // discard arguments
                RESTORE_REGISTERS
                addq.l  #4,%sp                          // discard irq identifier pushed by pea
                //
                move.w  sr_save,%sr
                rte

                .global VH_default
VH_default:
                jmp     .

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

sr_save:        .word   0

