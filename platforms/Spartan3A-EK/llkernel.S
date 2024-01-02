
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

                // Reset
                .org    0
                .extern _start
                brai    _start

                // User Vector (Exception)
                .org    0x8
                brai    0

                // Interrupt
                .org    0x10
                brai    0

                // Break
                .org    0x18
                brai    0

                // Hardware Exception
                .org    0x20
                brai    0

                // Reserved for future use
                .org    0x28
                .space  0x28

