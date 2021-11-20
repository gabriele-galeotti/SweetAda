
//
// startup.S - ESA/390 startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Extract entry point from PSW @ 0 (24-bit).
                //
                sr      %r11,%r11
                sr      %r12,%r12
                icm     %r12,0b111,5(%r11)

                // setup the literal pool
                bras    %r13,1f
.Lstart:
.Lkernel_stack: .long   kernel_stack
                .extern adainit
.Ladainit:      .long   adainit
                .extern _ada_main
.L_ada_main:    .long   _ada_main
1:

                //
                // Setup stack pointer.
                //
                l       %r15,(.Lkernel_stack-.Lstart)(%r13)

                // allocate a stack frame
                ahi     %r15,-96

                //
                // Call "adainit" procedure.
                //
                l       %r14,(.Ladainit-.Lstart)(%r13)
                basr    %r14,%r14

                //
                // Jump to high-level code.
                //
                l       %r14,(.L_ada_main-.Lstart)(%r13)
                basr    %r14,%r14

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

