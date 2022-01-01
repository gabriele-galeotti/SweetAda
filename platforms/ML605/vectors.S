
//
// vectors.S - MicroBlaze ML605 vectors (QEMU emulator).
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .org    0x00

                // interrupt vector
                .org    0x10
                .extern timerirq
                brid    timerirq
                nop

                // coming from "brki r14,0x60"
                .org    0x60
                .extern exception_process
                brid    exception_process
                nop

