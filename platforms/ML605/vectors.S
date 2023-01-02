
//
// vectors.S - MicroBlaze ML605 vectors (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                // Reset
                //.org    0x00
                .extern _start
                brid    _start
                nop

                // User Vector (Exception)
                //.org    0x08
                nop
                nop

                // Interrupt
                //.org    0x10
                .extern timerirq
                brid    timerirq
                nop

                // Break
                //.org    0x18
                nop
                nop

                // Hardware Exception
                //.org    0x20
                nop
                nop

                //
                // Reserved for future use
                //
                .space  0x28

