
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global vectors
vectors:

                .extern _start
V_Reset:        .long   _start                  // 0x00 Reset
V_UndInstr:     .long   _start                  // 0x04 Undefined Instruction
V_SWI:          .long   _start                  // 0x08 Software Interrupt
V_AbortP:       .long   _start                  // 0x0C Abort (Prefetch)
V_AbortD:       .long   _start                  // 0x10 Abort (Data)
V_AddrExc:      .long   _start                  // 0x14 Address Exception
V_IRQ:          .long   _start                  // 0x18 IRQ
V_FIQ:          .long   _start                  // 0x1C FIQ

