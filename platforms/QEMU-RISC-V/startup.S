
//
// startup.S - RISC-V startup (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .option arch,+zicsr,+zifencei

                .sect   .text,"ax"

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
                // Clear medeleg/mideleg.
                //
                csrw    medeleg,zero
                csrw    mideleg,zero

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
                la      a0,_sbss
                la      a1,_ebss
                ble     a1,a0,2f
1:              sw      zero,(a0)
                add     a0,a0,__SIZEOF_POINTER__
                blt     a0,a1,1b
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
                .space  4096
kernel_stack:

