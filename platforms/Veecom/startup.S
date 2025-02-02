
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

                .option arch,+zicsr,+zifencei

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                la      sp,kernel_stack

                //
                // Setup global pointer.
                //
                .extern _gp
                la      gp,_gp

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                la      t0,_sbss
                la      t1,_ebss
                ble     t1,t0,2f
1:              sw      zero,(t0)
                add     t0,t0,__SIZEOF_POINTER__
                blt     t0,t1,1b
2:

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jal     _ada_main

dead:           j       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .p2align 4
                .space  256
kernel_stack:

