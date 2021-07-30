
//
// startup.S - MicroBlaze startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

reset:          brai    _start

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                addik   r1,r0,kernel_stack

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                brlid   r15,adainit
                nop

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                brlid   r15,_ada_main
                nop

dead:           brid    .
                nop

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

