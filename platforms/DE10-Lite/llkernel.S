
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

                .set    noat

                .global vectors
vectors:

reset:
                .extern _start
                movhi   r2,%hi(_start)
                ori     r2,r2,%lo(_start)
                jmp     r2

