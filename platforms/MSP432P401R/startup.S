
//
// startup.S - MSP432P401R startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                ldr     r0,=stack
                mov     sp,r0

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                bl      adainit

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
stack:

