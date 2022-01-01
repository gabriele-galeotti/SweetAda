
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global reset

                // 0x18 is the distance from the instruction and the vector minus 0x8
reset:          ldr     pc,[pc,#0x18]                   // 0x00 Reset
                ldr     pc,[pc,#0x18]                   // 0x04 Undefined Instruction
                ldr     pc,[pc,#0x18]                   // 0x08 Software Interrupt
                ldr     pc,[pc,#0x18]                   // 0x0C Prefetch Abort
                ldr     pc,[pc,#0x18]                   // 0x10 Data Abort
                ldr     pc,[pc,#0x18]                   // 0x14 Reserved
                ldr     pc,[pc,#0x18]                   // 0x18 IRQ
                ldr     pc,[pc,#0x18]                   // 0x1C FIQ
                .extern _start
                .long   _start                          // 0x20 Reset                 Address of Reset handler
                .long   0                               // 0x24 Undefined Instruction Address of UNDEF handler
                .long   0                               // 0x28 Software Interrupt    Address of SWI handler
                .long   0                               // 0x2C Prefetch Abort        Address of prefetch abort handler
                .long   0                               // 0x30 Data Abort            Address of data abort handler
                .long   0                               // 0x34 Reserved
                .long   0                               // 0x38 IRQ                   Address of IRQ handler
                .long   0                               // 0x3C FIQ                   Address of FIQ handler

