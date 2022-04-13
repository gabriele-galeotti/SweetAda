
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

                .sect   .text,"ax"

                .global vectors
vectors:

initial_SP:     .long   0
RESET:          .long   0
NMI:            .long   0
Hard_Fault:     .long   0
MemManage_Fault:.long   0
Bus_Fault:      .long   0
Usage_Fault:    .long   0
Reserved_7:     .long   0
Reserved_8:     .long   0
Reserved_9:     .long   0
Reserved_A:     .long   0
SVI_Call:       .long   0
Debug_Monitor:  .long   0
Reserved_D:     .long   0
Pending_SV:     .long   0
SysTick:        .long   0

