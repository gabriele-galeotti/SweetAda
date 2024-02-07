
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
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

                .org    0x0F00
                .space  0x1000

