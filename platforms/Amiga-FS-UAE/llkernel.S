
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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

                .sect   .text,"ax"

                //
                // Exception & interrupt error handlers.
                //

                .align  4
                .global buserr_handler
buserr_handler:
                pea     BUS_ERROR
                jmp     exception_entry

                .align  4
                .global addrerr_handler
addrerr_handler:
                pea     ADDRESS_ERROR
                jmp     exception_entry

                .align  4
                .global illinstr_handler
illinstr_handler:
                pea     ILLEGAL_INSTRUCTION
                jmp     exception_entry

                .align  4
                .global div0_handler
div0_handler:
                pea     ZERO_DIVIDE
                jmp     exception_entry

                .align  4
                .global chkinstr_handler
chkinstr_handler:
                pea     CHK_CHK2_INSTRUCTION
                jmp     exception_entry

                .align  4
                .global trapc_handler
trapc_handler:
                pea     CPTRAPCC_TRAPCC_TRAPV_INSTRUCTIONS
                jmp     exception_entry

                .align  4
                .global privilegev_handler
privilegev_handler:
                pea     PRIVILEGE_VIOLATION
                jmp     exception_entry

                .align  4
                .global trace_handler
trace_handler:
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
                .global line1010_handler
line1010_handler:
                pea     LINE_1010_EMULATOR
                jmp     exception_entry

                .align  4
                .global line1111_handler
line1111_handler:
                pea     LINE_1111_EMULATOR
                jmp     exception_entry

                .align  4
                .global cprotocolv_handler
cprotocolv_handler:
                pea     COPROCESSOR_PROTOCOL_VIOLATION
                jmp     exception_entry

                .align  4
                .global formaterr_handler
formaterr_handler:
                pea     FORMAT_ERROR
                jmp     exception_entry

                .align  4
                .global uninitint_handler
uninitint_handler:
                pea     UNINITIALIZED_INTERRUPT
                jmp     exception_entry

                .align  4
                .global spurious_handler
spurious_handler:
                pea     SPURIOUS_INTERRUPT
                jmp     exception_entry

                .align  4
                .global l1autovector_handler
l1autovector_handler:
                pea     LEVEL1_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global l2autovector_handler
l2autovector_handler:
                pea     LEVEL2_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global l3autovector_handler
l3autovector_handler:
                pea     LEVEL3_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global l4autovector_handler
l4autovector_handler:
                pea     LEVEL4_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global l5autovector_handler
l5autovector_handler:
                pea     LEVEL5_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global l6autovector_handler
l6autovector_handler:
                pea     LEVEL6_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global l7autovector_handler
l7autovector_handler:
                pea     LEVEL7_INTERRUPT_AUTOVECTOR
                jmp     irq_entry

                .align  4
                .global trap0_handler
trap0_handler:
                pea     TRAP_0
                jmp     exception_entry

                .align  4
                .global trap1_handler
trap1_handler:
                pea     TRAP_1
                jmp     exception_entry

                .align  4
                .global trap2_handler
trap2_handler:
                pea     TRAP_2
                jmp     exception_entry

                .align  4
                .global trap3_handler
trap3_handler:
                pea     TRAP_3
                jmp     exception_entry

                .align  4
                .global trap4_handler
trap4_handler:
                pea     TRAP_4
                jmp     exception_entry

                .align  4
                .global trap5_handler
trap5_handler:
                pea     TRAP_5
                jmp     exception_entry

                .align  4
                .global trap6_handler
trap6_handler:
                pea     TRAP_6
                jmp     exception_entry

                .align  4
                .global trap7_handler
trap7_handler:
                pea     TRAP_7
                jmp     exception_entry

                .align  4
                .global trap8_handler
trap8_handler:
                pea     TRAP_8
                jmp     exception_entry

                .align  4
                .global trap9_handler
trap9_handler:
                pea     TRAP_9
                jmp     exception_entry

                .align  4
                .global trap10_handler
trap10_handler:
                pea     TRAP_10
                jmp     exception_entry

                .align  4
                .global trap11_handler
trap11_handler:
                pea     TRAP_11
                jmp     exception_entry

                .align  4
                .global trap12_handler
trap12_handler:
                pea     TRAP_12
                jmp     exception_entry

                .align  4
                .global trap13_handler
trap13_handler:
                pea     TRAP_13
                jmp     exception_entry

                .align  4
                .global trap14_handler
trap14_handler:
                pea     TRAP_14
                jmp     exception_entry

                .align  4
                .global trap15_handler
trap15_handler:
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

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

sr_save:        .word   0

