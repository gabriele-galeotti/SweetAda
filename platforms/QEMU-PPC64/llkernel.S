
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

                .org    0

                .org    0x10
                .global reset
                .extern _start
reset:          b       _start

                .org    0x100
                b       reset

                .org    0x200
                b       .
                .org    0x300
                b       .
                .org    0x400
                b       .
                .org    0x500
                b       .
                .org    0x600
                b       .
                .org    0x700
                b       .
                .org    0x800
                b       .
                .org    0x900
                b       .
                .org    0xA00
                b       .
                .org    0xB00
                b       .
                .org    0xC00
                b       .
                .org    0xD00
                b       .
                .org    0xE00
                b       .

