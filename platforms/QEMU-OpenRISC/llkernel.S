
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

                .sect   .vectors,"ax"

                .global vectors
vectors:

                // 0x0100: Reset
                .org    0x0100
Reset:
                .extern _start
                l.movhi r13,hi(_start)
                l.ori   r13,r13,lo(_start)
                l.jr    r13
                l.nop

                // 0x0200: Bus Error
                .org    0x0200
Bus_Error:

                // 0x0300: Data Page Fault
                .org    0x0300
Data_Page_Fault:

                // 0x0400: Instruction Page Fault
                .org    0x0400
Instruction_Page_Fault:

                // 0x0500: Tick Timer
                .org    0x0500
Tick_Timer:
                .extern irq_process
                l.addi  r1,r1,-4
                l.sw    0(r1),r9
                l.jal   timer_handler
                l.nop
                l.lwz   r9,0(r1)
                l.addi  r1,r1,4
                l.rfe

                // 0x0600: Alignment
                .org    0x0600
Alignment:

                // 0x0700: Illegal Instruction
                .org    0x0700
Illegal_Instruction:

                // 0x0800: External Interrupt
                .org    0x0800
External_Interrupt:

                // 0x0900: D-TLB Miss
                .org    0x0900
DTLB_Miss:

                // 0x0A00: I-TLB Miss
                .org    0x0A00
ITLB_Miss:

                // 0x0B00: Range
                .org    0x0B00
Range:

                // 0x0C00: System Call
                .org    0x0C00
System_Call:

                // 0x0D00: Floating Point
                .org    0x0D00
Floating_Point:

                // 0x0E00: Trap
                .org    0x0E00
Trap:

                // Reserved for future use.
                // Reserved for implementation-specific exceptions.
                // Reserved for custom exceptions.
                .org    0x0F00
                .space  0x1000

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

timer_handler:
                l.addi  r1,r1,-76
                l.sw     0(r1),r3
                l.sw     4(r1),r4
                l.sw     8(r1),r5
                l.sw    12(r1),r6
                l.sw    16(r1),r7
                l.sw    20(r1),r8
                l.sw    24(r1),lr
                l.sw    28(r1),r11
                l.sw    32(r1),r12
                l.sw    36(r1),r13
                l.sw    40(r1),r15
                l.sw    44(r1),r17
                l.sw    48(r1),r19
                l.sw    52(r1),r21
                l.sw    56(r1),r23
                l.sw    60(r1),r25
                l.sw    64(r1),r27
                l.sw    68(r1),r29
                l.sw    72(r1),r31
                l.jal   irq_process
                l.nop
                l.lwz   r3,  0(r1)
                l.lwz   r4,  4(r1)
                l.lwz   r5,  8(r1)
                l.lwz   r6, 12(r1)
                l.lwz   r7, 16(r1)
                l.lwz   r8, 20(r1)
                l.lwz   lr, 24(r1)
                l.lwz   r11,28(r1)
                l.lwz   r12,32(r1)
                l.lwz   r13,36(r1)
                l.lwz   r15,40(r1)
                l.lwz   r17,44(r1)
                l.lwz   r19,48(r1)
                l.lwz   r21,52(r1)
                l.lwz   r23,56(r1)
                l.lwz   r25,60(r1)
                l.lwz   r27,64(r1)
                l.lwz   r29,68(r1)
                l.lwz   r31,72(r1)
                l.addi  r1,r1,76
                l.jr    lr
                l.nop

