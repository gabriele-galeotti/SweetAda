
//
// startup.S - HiFive1 startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#define RISCV_TOOLCHAIN_WORKAROUND 1

////////////////////////////////////////////////////////////////////////////////

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
#if defined(RISCV_TOOLCHAIN_WORKAROUND)
                .long   0x30001073|5<<15
#else
                csrw    mstatus,t0
#endif
                //li      t0,0xFFFF
#if defined(RISCV_TOOLCHAIN_WORKAROUND)
                //.long   0x30201073|5<<15
#else
                //csrw    medeleg,t0
#endif
#if defined(RISCV_TOOLCHAIN_WORKAROUND)
                //.long   0x30301073|5<<15
#else
                //csrw    mideleg,t0
#endif
                la      t0,1f
#if defined(RISCV_TOOLCHAIN_WORKAROUND)
                .long   0x34101073|5<<15
#else
                csrw    mepc,t0
#endif
                mret
1:

                //
                // Allow only hart #0.
                //
#if defined(RISCV_TOOLCHAIN_WORKAROUND)
                .long   0xF1402073|5<<7
#else
                csrr    t0,mhartid
#endif
                bnez    t0,hart_idle

                //
                // Setup stack pointer.
                //
                la      sp,kernel_stack

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                call    _ada_main

dead:           j       .

hart_idle:
                wfi
                j       hart_idle

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
kernel_stack:

