
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
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
                // Setup stack pointer.
                //
                l.movhi r1,hi(kernel_stack)
                l.ori   r1,r1,lo(kernel_stack)

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                l.movhi r13,hi(_sbss)
                l.ori   r13,r13,lo(_sbss)
                l.movhi r15,hi(_ebss)
                l.ori   r15,r15,lo(_ebss)
1:              l.sfgeu r13,r15
                l.bf    2f
                l.addi  r13,r13,4
                l.sw    0(r13),r0
                l.j     1b
                l.nop
2:

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                l.jal   _ada_main
                l.nop

dead:           l.j     .
                l.nop

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  4096
kernel_stack:

