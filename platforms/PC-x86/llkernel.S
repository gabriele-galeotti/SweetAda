
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <i386.h>
#include <selectors.h>

////////////////////////////////////////////////////////////////////////////////

#define SAVE_REGISTERS        \
                pushl   %eax; \
                pushl   %ecx; \
                pushl   %edx;

#define RESTORE_REGISTERS     \
                popl    %edx; \
                popl    %ecx; \
                popl    %eax;

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                //
                // Exceptions handlers.
                // Every handler pushes the exception identifier on the stack
                // as 1st argument for the subsequent call.
                //
                // FAULTS: CS:EIP points to the faulting instruction
                // TRAPS : CS:EIP points to the following instruction
                // ABORTS: CS:EIP N/A
                //
                // NOTE:
                // the code must be pulled from the stack before perform iret
                // NOTE:
                // push/pop <segment> in 32-bit mode will move 4 bytes to/from
                // stack, discarding upper 2 bytes
                //

                .balign 4
                .global div_by_0_handler
div_by_0_handler:
                // number: 0
                // type  : FAULT
                pushl   $DIVISION_BY_0
                jmp     exception_handler

                .balign 4
                .global debug_exception_handler
debug_exception_handler:
                // number: 1
                // type  : FAULT/TRAP
                pushl   $DEBUG_EXCEPTION
                jmp     exception_handler

                .balign 4
                .global nmi_interrupt_handler
nmi_interrupt_handler:
                // number: 2
                // type  : TRAP
                pushl   $NMI_INTERRUPT
                jmp     exception_handler

                .balign 4
                .global one_byte_int_handler
one_byte_int_handler:
                // number: 3
                // type  : TRAP
                pushl   $ONE_BYTE_INTERRUPT
                jmp     exception_handler

                .balign 4
                .global int_on_overflow_handler
int_on_overflow_handler:
                // number: 4
                // type  : TRAP
                pushl   $INT_ON_OVERFLOW
                jmp     exception_handler

                .balign 4
                .global array_bounds_handler
array_bounds_handler:
                // number: 5
                // type  : FAULT
                pushl   $ARRAY_BOUNDS
                jmp     exception_handler

                .balign 4
                .global invalid_opcode_handler
invalid_opcode_handler:
                // number: 6
                // type  : FAULT
                pushl   $INVALID_OPCODE
                jmp     exception_handler

                .balign 4
                .global device_not_avl_handler
device_not_avl_handler:
                // number: 7
                // type  : FAULT
                pushl   $DEVICE_NOT_AVAILABLE
                jmp     exception_handler

                .balign 4
                .global double_fault_handler
double_fault_handler:
                // number: 8
                // type  : ABORT
                pushl   $DOUBLE_FAULT
                jmp     exception_handler

                .balign 4
                .global cp_seg_ovr_handler
cp_seg_ovr_handler:
                // number: 9
                // type  : ABORT
                pushl   $CP_SEGMENT_OVERRUN
                jmp     exception_handler

                .balign 4
                .global invalid_tss_handler
invalid_tss_handler:
                // number: 10
                // type  : FAULT
                pushl   $INVALID_TSS
                jmp     exception_handler

                .balign 4
                .global seg_not_prsnt_handler
seg_not_prsnt_handler:
                // number: 11
                // type  : FAULT
                pushl   $SEGMENT_NOT_PRESENT
                jmp     exception_handler

                .balign 4
                .global stack_fault_handler
stack_fault_handler:
                // number: 12
                // type  : FAULT
                pushl   $STACK_FAULT
                jmp     exception_handler

                .balign 4
                .global gen_prot_fault_handler
gen_prot_fault_handler:
                // number: 13
                // type  : FAULT/TRAP
                pushl   $GENERAL_PROTECTION
                jmp     exception_handler

                .balign 4
                .global page_fault_handler
page_fault_handler:
                // number: 14
                // type  : FAULT
                pushl   $PAGE_FAULT
                jmp     exception_handler

                .balign 4
                .global coproc_error_handler
coproc_error_handler:
                // number: 16
                // typr  : FAULT
                pushl   $COPROCESSOR_ERROR
                jmp     exception_handler

                //
                // Exception common handler.
                //
                .balign 4
exception_handler:
                .extern exception_process
                SAVE_REGISTERS
                lea     20(%esp),%ebx
                movl    12(%esp),%eax           // get exception code
                pushl   %ebx                    // push as 2nd argument
                pushl   %eax                    // push as 1st argument
                call    exception_process
                addl    $8,%esp                 // unstack arguments
                RESTORE_REGISTERS
                addl    $4,%esp                 // unstack exception code
                iret

                //
                // irqX handlers.
                // IF is cleared, so hardware interrupts are disabled.
                // Every handler pushes the irq code on the stack as 1st
                // argument for the subsequent call.
                //

                .balign 4
                .global irq0_handler
irq0_handler:
                pushl   $IRQ0
                jmp     irq_handler

                .balign 4
                .global irq1_handler
irq1_handler:
                pushl   $IRQ1
                jmp     irq_handler

// IRQ2 rerouted to IRQ9
//                .balign 4
//                .global irq2_handler
//irq2_handler:
//                pushl   $IRQ2
//                jmp     irq_handler

                .balign 4
                .global irq3_handler
irq3_handler:
                pushl   $IRQ3
                jmp     irq_handler

                .balign 4
                .global irq4_handler
irq4_handler:
                pushl   $IRQ4
                jmp     irq_handler

                .balign 4
                .global irq5_handler
irq5_handler:
                pushl   $IRQ5
                jmp     irq_handler

                .balign 4
                .global irq6_handler
irq6_handler:
                pushl   $IRQ6
                jmp     irq_handler

                .balign 4
                .global irq7_handler
irq7_handler:
                pushl   $IRQ7
                jmp     irq_handler

                .balign 4
                .global irq8_handler
irq8_handler:
                pushl   $IRQ8
                jmp     irq_handler

                .balign 4
                .global irq9_handler
irq9_handler:
                pushl   $IRQ9
                jmp     irq_handler

                .balign 4
                .global irq10_handler
irq10_handler:
                pushl   $IRQ10
                jmp     irq_handler

                .balign 4
                .global irq11_handler
irq11_handler:
                pushl   $IRQ11
                jmp     irq_handler

                .balign 4
                .global irq12_handler
irq12_handler:
                pushl   $IRQ12
                jmp     irq_handler

                .balign 4
                .global irq13_handler
irq13_handler:
                pushl   $IRQ13
                jmp     irq_handler

                .balign 4
                .global irq14_handler
irq14_handler:
                pushl   $IRQ14
                jmp     irq_handler

                .balign 4
                .global irq15_handler
irq15_handler:
                pushl   $IRQ15
                jmp     irq_handler

                //
                // IRQ common handler.
                //
                .balign 4
irq_handler:
                .extern irq_process
                SAVE_REGISTERS
                movl    12(%esp),%eax           // get irq code
                pushl   %eax                    // push as 1st argument
                call    irq_process
                addl    $4,%esp                 // unstack arguments
                RESTORE_REGISTERS
                addl    $4,%esp                 // unstack irq code
                iret

