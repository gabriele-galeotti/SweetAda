
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

#define SAVE_REGISTERS                   \
                stw     r1,  0(sp)      ;\
                stw     r2,  4(sp)      ;\
                stw     r3,  8(sp)      ;\
                stw     r4, 12(sp)      ;\
                stw     r5, 16(sp)      ;\
                stw     r6, 20(sp)      ;\
                stw     r7, 24(sp)      ;\
                stw     r8, 28(sp)      ;\
                stw     r9, 32(sp)      ;\
                stw     r10,36(sp)      ;\
                stw     r11,40(sp)      ;\
                stw     r12,44(sp)      ;\
                stw     r13,48(sp)      ;\
                stw     r14,52(sp)      ;\
                stw     r15,56(sp)      ;\
                stw     r26,60(sp)      ;\
                stw     r28,64(sp)      ;\
                stw     r31,68(sp)

#define RESTORE_REGISTERS                \
                ldw     r1,  0(sp)      ;\
                ldw     r2,  4(sp)      ;\
                ldw     r3,  8(sp)      ;\
                ldw     r4, 12(sp)      ;\
                ldw     r5, 16(sp)      ;\
                ldw     r6, 20(sp)      ;\
                ldw     r7, 24(sp)      ;\
                ldw     r8, 28(sp)      ;\
                ldw     r9, 32(sp)      ;\
                ldw     r10,36(sp)      ;\
                ldw     r11,40(sp)      ;\
                ldw     r12,44(sp)      ;\
                ldw     r13,48(sp)      ;\
                ldw     r14,52(sp)      ;\
                ldw     r15,56(sp)      ;\
                ldw     r26,60(sp)      ;\
                ldw     r28,64(sp)      ;\
                ldw     r31,68(sp)

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .set    noat

                //
                // If the entry point is exactly @ 0xC0000000, QEMU seems to
                // think this is a Linux kernel and applies a sort of address
                // translation (see boot.c:nios2_load_kernel()), so to avoid
                // any kind of problems displace the entry point with a nop
                // instruction in order to avoid that.
                //
                .extern _start
                br      _start

                .space  0x120-4

                .global irq_entry
irq_entry:
                addi    sp,sp,-72
                SAVE_REGISTERS
                .extern irq_process
                call    irq_process
                RESTORE_REGISTERS
                addi    sp,sp,72
                subi    ea,ea,4
                eret

