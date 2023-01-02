
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <x86-64.h>

////////////////////////////////////////////////////////////////////////////////

#define SAVE_REGISTERS        \
                pushq   %rax; \
                pushq   %rcx; \
                pushq   %rdx; \
                pushq   %rsi; \
                pushq   %rdi;

#define RESTORE_REGISTERS     \
                popq    %rdi; \
                popq    %rsi; \
                popq    %rdx; \
                popq    %rcx; \
                popq    %rax;

////////////////////////////////////////////////////////////////////////////////

                .code64

                .sect   .text,"ax"

                .align  4
                .global div_by_0_handler
div_by_0_handler:
                // number: 0
                // type  : FAULT
                pushq   $DIVISION_BY_0
                jmp     exception_handler

                .align  4
                .global debug_exception_handler
debug_exception_handler:
                // number: 1
                // type  : FAULT/TRAP
                pushq   $DEBUG_EXCEPTION
                jmp     exception_handler

                .align  4
                .global nmi_interrupt_handler
nmi_interrupt_handler:
                // number: 2
                // type  : TRAP
                pushq   $NMI_INTERRUPT
                jmp     exception_handler

                .align  4
                .global one_byte_int_handler
one_byte_int_handler:
                // number: 3
                // type  : TRAP
                pushq   $ONE_BYTE_INTERRUPT
                jmp     exception_handler

                .align  4
                .global int_on_overflow_handler
int_on_overflow_handler:
                // number: 4
                // type  : TRAP
                pushq   $INT_ON_OVERFLOW
                jmp     exception_handler

                .align  4
                .global array_bounds_handler
array_bounds_handler:
                // number: 5
                // type  : FAULT
                pushq   $ARRAY_BOUNDS
                jmp     exception_handler

                .align  4
                .global invalid_opcode_handler
invalid_opcode_handler:
                // number: 6
                // type  : FAULT
                pushq   $INVALID_OPCODE
                jmp     exception_handler

                .align  4
                .global device_not_avl_handler
device_not_avl_handler:
                // number: 7
                // type  : FAULT
                pushq   $DEVICE_NOT_AVAILABLE
                jmp     exception_handler

                .align  4
                .global double_fault_handler
double_fault_handler:
                // number: 8
                // type  : ABORT
                pushq   $DOUBLE_FAULT
                jmp     exception_handler

                .align  4
                .global cp_seg_ovr_handler
cp_seg_ovr_handler:
                // number: 9
                // type  : ABORT
                pushq   $CP_SEGMENT_OVERRUN
                jmp     exception_handler

                .align  4
                .global invalid_tss_handler
invalid_tss_handler:
                // number: 10
                // type  : FAULT
                pushq   $INVALID_TSS
                jmp     exception_handler

                .align  4
                .global seg_not_prsnt_handler
seg_not_prsnt_handler:
                // number: 11
                // type  : FAULT
                pushq   $SEGMENT_NOT_PRESENT
                jmp     exception_handler

                .align  4
                .global stack_fault_handler
stack_fault_handler:
                // number: 12
                // type  : FAULT
                pushq   $STACK_FAULT
                jmp     exception_handler

                .align  4
                .global gen_prot_fault_handler
gen_prot_fault_handler:
                // number: 13
                // type  : FAULT/TRAP
                pushq   $GENERAL_PROTECTION
                jmp     exception_handler

                .align  4
                .global page_fault_handler
page_fault_handler:
                // number: 14
                // type  : FAULT
                pushq   $PAGE_FAULT
                jmp     exception_handler

                .align  4
                .global coproc_error_handler
coproc_error_handler:
                // number: 16
                // typr  : FAULT
                pushq   $COPROCESSOR_ERROR
                jmp     exception_handler

                //
                // Exception common handler.
                //
                .align  4
exception_handler:
                movq    (%rsp),%rdi             // get exception code
                .extern exception_process
                call    exception_process
                addq    $8,%rsp                 // unstack exception code
                iretq

                .align  4
                .global irq0_handler
irq0_handler:
                pushq   $IRQ0
                jmp     irq_handler

                .align  4
                .global irq8_handler
irq8_handler:
                pushq   $IRQ8
                jmp     irq_handler

                //
                // IRQ common handler.
                //
                .align  4
irq_handler:
                SAVE_REGISTERS
                movq    40(%rsp),%rdi           // get irq code
                .extern irq_process
                call    irq_process
                RESTORE_REGISTERS
                addq    $8,%rsp                 // unstack irq code
                iretq

