
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>

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
                // Boot the selected hart.
                //
                li      t1,BOOT_HART
                csrr    t0,mhartid
                beq     t0,t1,1f
                j       hart_idle
1:

                //
                // Setup stack pointer.
                //
                la      sp,kernel_stack

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

hart_idle:
                wfi
                j       hart_idle

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  4096
kernel_stack:

