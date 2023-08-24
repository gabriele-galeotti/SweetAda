
//
// startup.S - HiFive1 startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
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
                // Set Previous Privilege Mode.
                // S: 1 << 11
                // M: 3 << 11
                //
                li      t0,0x3<<11                      // "M" mode
                csrw    mstatus,t0
                la      t0,1f
                csrw    mepc,t0
                mret
1:

                //
                // Allow only hart #0.
                //
                csrr    t0,mhartid
                bnez    t0,hart_idle

                //
                // Setup stack pointer.
                //
                la      sp,kernel_stack

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                la      a3,_sbss
                la      a4,_ebss
                ble     a4,a3,2f
1:              sw      zero,(a3)
                add     a3,a3,__SIZEOF_POINTER__
                blt     a3,a4,1b
2:

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jal     _ada_main

dead:           j       .

hart_idle:
                wfi
                j       hart_idle

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  1024
kernel_stack:

