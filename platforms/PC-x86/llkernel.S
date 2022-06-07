
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
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
                // __REF__ acroread /a "page=161" "INTEL 80386 PROGRAMMERS REFERENCE MANUAL 1986.pdf"
                //
                // NOTE:
                // the code must be pulled from the stack before perform iret
                // NOTE:
                // push/pop <segment> in 32-bit mode will move 4 bytes to/from
                // stack, discarding upper 2 bytes
                //

                .align  4
                .global div_by_0_handler
div_by_0_handler:
                // number: 0
                // type  : FAULT
                // CS:EIP: points to the faulting instruction
                // code  : N
                // notes : interrupts enabled
                pushl   $DIVISION_BY_0
                xchgl   %eax,(%esp)             // save EAX and make new EAX = error code
                pushl   %ecx
                pushl   %edx
                pushl   %ebx
                pushl   $0                      // fake ESP
                pushl   %ebp
                pushl   %esi
                pushl   %edi
                push    %ds
                push    %es
                push    %fs
                push    %gs
                //
                lea     48(%esp),%ebx           // EBX = pointer to exception frame
                pushl   %ebx                    // 2nd argument = exception frame pointer
                pushl   %eax                    // 1st argument = error code
                //
                movl    $SELECTOR_KDATA,%eax
                movl    %eax,%ds
                movl    %eax,%es
                //
                call    exception_process
                addl    $8,%esp                 // unstack arguments
                //
                pop     %gs
                pop     %fs
                pop     %es
                pop     %ds
                popl    %edi
                popl    %esi
                popl    %ebp
                addl    $4,%esp                 // fake ESP
                popl    %ebx
                popl    %edx
                popl    %ecx
                popl    %eax
                iret

                .align  4
                .global debug_exception_handler
debug_exception_handler:
                // number: 1
                // type  : FAULT/TRAP
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled; check DR6 register
                //pushl   $DEBUG_EXCEPTION
                //jmp     exception_handler
                jmp     one_byte_int_handler

                .align  4
                .global nmi_interrupt_handler
nmi_interrupt_handler:
                // number: 2
                // type  : TRAP
                // CS:EIP: points to the following instruction
                // code  : ? (N)
                // notes : interrupts enabled
                // "While an NMI handler is executing, the processor ignores"
                // "further interrupt signals at the NMI pin until the next"
                // "IRET instruction is executed."
                pushl   $NMI_INTERRUPT
                jmp     exception_handler

                .align  4
                .global one_byte_int_handler
one_byte_int_handler:
                // number: 3
                // type  : TRAP
                // CS:EIP: points to the following instruction
                // code  : N
                // notes : interrupts enabled
                // __REF__ acroread /a "page=230" "i486_Processor_Programmers_Reference_Manual_1990.pdf"
                // __REF__ kate -l 197 "/usr/local/src/rtems-4.10.2/c/src/lib/libbsp/i386/shared/comm/i386-stub.c"
                // __FIX__ switch DS/ES/etc to kernel context
                .extern gdbstub_data_area
                movl    %eax,gdbstub_data_area+0
                movl    %ecx,gdbstub_data_area+4
                movl    %edx,gdbstub_data_area+8
                movl    %ebx,gdbstub_data_area+12
                // ESP (gdbstub_data_area+16) saved later
                movl    %ebp,gdbstub_data_area+20
                movl    %esi,gdbstub_data_area+24
                movl    %edi,gdbstub_data_area+28
                xorw    %ax,%ax                         // clear AX
                movw    %ds,gdbstub_data_area+48        // DS
                movw    %ax,gdbstub_data_area+50        // extend (clear) to 32-bit
                movw    %es,gdbstub_data_area+52        // ES
                movw    %ax,gdbstub_data_area+54        // extend (clear) to 32-bit
                movw    %fs,gdbstub_data_area+56        // FS
                movw    %ax,gdbstub_data_area+58        // extend (clear) to 32-bit
                movw    %gs,gdbstub_data_area+60        // GS
                movw    %ax,gdbstub_data_area+62        // extend (clear) to 32-bit
                // unstack the exception frame; use EBX the preserve EAX (it contains filling zeros)
                popl    %ebx                            // pull EIP
                movl    %ebx,gdbstub_data_area+32
                popl    %ebx                            // pull CS
                movl    %ebx,gdbstub_data_area+40
                movw    %ax,gdbstub_data_area+42        // extend (clear) to 32-bit
                popl    %ebx                            // pull EFLAGS
                movl    %ebx,gdbstub_data_area+36
                // now the stack pointer is in the state before exception occurred
                movw    %ss,gdbstub_data_area+44        // SS
                movw    %ax,gdbstub_data_area+46        // extend (clear) to 32-bit
                movl    %esp,gdbstub_data_area+16       // ESP
                //
                pushl   $ONE_BYTE_INTERRUPT
                call    exception_process
                addl    $4,%esp                         // unstack exception code
                //
                movw    gdbstub_data_area+44,%ss        // select lower 16-bit
                movl    gdbstub_data_area+16,%esp
                movl    gdbstub_data_area+4,%ecx
                movl    gdbstub_data_area+8,%edx
                movl    gdbstub_data_area+12,%ebx
                movl    gdbstub_data_area+20,%ebp
                movl    gdbstub_data_area+24,%esi
                movl    gdbstub_data_area+28,%edi
                movw    gdbstub_data_area+48,%ds        // select lower 16-bit
                movw    gdbstub_data_area+52,%es        // select lower 16-bit
                movw    gdbstub_data_area+56,%fs        // select lower 16-bit
                movw    gdbstub_data_area+60,%gs        // select lower 16-bit
                // use iret to restore pc and flags together so that trace flag works right
                movl    gdbstub_data_area+36,%eax
                pushl   %eax                            // EFLAGS
                movl    gdbstub_data_area+40,%eax
                pushl   %eax                            // CS
                movl    gdbstub_data_area+32,%eax
                pushl   %eax                            // EIP
                // restore EAX
                movl    gdbstub_data_area+0,%eax
                iret

                .align  4
                .global int_on_overflow_handler
int_on_overflow_handler:
                // number: 4
                // type  : TRAP
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled
                pushl   $INT_ON_OVERFLOW
                jmp     exception_handler

                .align  4
                .global array_bounds_handler
array_bounds_handler:
                // number: 5
                // type  : FAULT
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled
                pushl   $ARRAY_BOUNDS
                jmp     exception_handler

                .align  4
                .global invalid_opcode_handler
invalid_opcode_handler:
                // number: 6
                // type  : FAULT
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled
                pushl   $INVALID_OPCODE
                jmp     exception_handler

                .align  4
                .global device_not_avl_handler
device_not_avl_handler:
                // number: 7
                // type  : FAULT
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled
                pushl   $DEVICE_NOT_AVAILABLE
                jmp     exception_handler

                .align  4
                .global double_fault_handler
double_fault_handler:
                // number: 8
                // type  : ABORT
                // CS:EIP: ?
                // code  : Y
                // notes : interrupts enabled
                pushl   $DOUBLE_FAULT
                jmp     exception_handler

                .align  4
                .global cp_seg_ovr_handler
cp_seg_ovr_handler:
                // number: 9
                // type  : ABORT
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled
                // __REF__ acroread /a "page=233" "i486_Processor_Programmers_Reference_Manual_1990.pdf"
                pushl   $CP_SEGMENT_OVERRUN
                jmp     exception_handler

                .align  4
                .global invalid_tss_handler
invalid_tss_handler:
                // number: 10
                // type  : FAULT
                // CS:EIP: ?
                // code  : Y
                // notes : interrupts enabled
                pushl   $INVALID_TSS
                jmp     exception_handler

                .align  4
                .global seg_not_prsnt_handler
seg_not_prsnt_handler:
                // number: 11
                // type  : FAULT
                // CS:EIP: ?
                // code  : Y
                // notes : interrupts enabled
                pushl   $SEGMENT_NOT_PRESENT
                jmp     exception_handler

                .align  4
                .global stack_fault_handler
stack_fault_handler:
                // number: 12
                // type  : FAULT
                // CS:EIP: ?
                // code  : Y
                // notes : interrupts enabled
                pushl   $STACK_FAULT
                jmp     exception_handler

                .align  4
                .global gen_prot_fault_handler
gen_prot_fault_handler:
                // number: 13
                // type  : FAULT/TRAP
                // CS:EIP: ?
                // code  : Y
                // notes : interrupts enabled
                pushl   $GENERAL_PROTECTION
                jmp     exception_handler

                .align  4
                .global page_fault_handler
page_fault_handler:
                // number: 14
                // type  : FAULT
                // CS:EIP: ?
                // code  : Y
                // notes : interrupts enabled; code format is different
                pushl   $PAGE_FAULT
                jmp     exception_handler

                .align  4
                .global coproc_error_handler
coproc_error_handler:
                // number: 16
                // typr  : FAULT
                // CS:EIP: ?
                // code  : N
                // notes : interrupts enabled
                pushl   $COPROCESSOR_ERROR
                jmp     exception_handler

                //
                // Exception common handler.
                //
                .align  4
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

                .align  4
                .global irq0_handler
irq0_handler:
                pushl   $IRQ0
                jmp     irq_handler

                .align  4
                .global irq1_handler
irq1_handler:
                pushl   $IRQ1
                jmp     irq_handler

// IRQ2 rerouted to IRQ9
//                .align  4
//                .global irq2_handler
//irq2_handler:
//                pushl   $IRQ2
//                jmp     irq_handler

                .align  4
                .global irq3_handler
irq3_handler:
                pushl   $IRQ3
                jmp     irq_handler

                .align  4
                .global irq4_handler
irq4_handler:
                pushl   $IRQ4
                jmp     irq_handler

                .align  4
                .global irq5_handler
irq5_handler:
                pushl   $IRQ5
                jmp     irq_handler

                .align  4
                .global irq6_handler
irq6_handler:
                pushl   $IRQ6
                jmp     irq_handler

                .align  4
                .global irq7_handler
irq7_handler:
                pushl   $IRQ7
                jmp     irq_handler

                .align  4
                .global irq8_handler
irq8_handler:
                pushl   $IRQ8
                jmp     irq_handler

                .align  4
                .global irq9_handler
irq9_handler:
                pushl   $IRQ9
                jmp     irq_handler

                .align  4
                .global irq10_handler
irq10_handler:
                pushl   $IRQ10
                jmp     irq_handler

                .align  4
                .global irq11_handler
irq11_handler:
                pushl   $IRQ11
                jmp     irq_handler

                .align  4
                .global irq12_handler
irq12_handler:
                pushl   $IRQ12
                jmp     irq_handler

                .align  4
                .global irq13_handler
irq13_handler:
                pushl   $IRQ13
                jmp     irq_handler

                .align  4
                .global irq14_handler
irq14_handler:
                pushl   $IRQ14
                jmp     irq_handler

                .align  4
                .global irq15_handler
irq15_handler:
                pushl   $IRQ15
                jmp     irq_handler

                //
                // IRQ common handler.
                //
                .align  4
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

