
//
// startup.S - Altera 10M50 GHRD startup (QEMU emulator).
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .set    noat

                .type   _start,@function
                .global _start
_start:

                //
                // Disable interrupts.
                //
                wrctl   status,r0
                wrctl   ienable,r0

                //
                // Invalidate instruction cache.
                //
#define NIOS2_ICACHE_SIZE      4096
#define NIOS2_ICACHE_LINE_SIZE 32
                mov     r2,r0
                movhi   r3,%hi(NIOS2_ICACHE_SIZE)
                ori     r3,r3,%lo(NIOS2_ICACHE_SIZE)
1:              initi   r2
                addi    r2,r2,NIOS2_ICACHE_LINE_SIZE
                bltu    r2,r3,1b

                //
                // Invalidate data cache.
                //
#define NIOS2_DCACHE_SIZE      0
#define NIOS2_DCACHE_LINE_SIZE 4
                mov     r2,r0
                movhi   r3,%hi(NIOS2_DCACHE_SIZE)
                ori     r3,r3,%lo(NIOS2_DCACHE_SIZE)
1:              initd   0(r2)
                addi    r2,r2,NIOS2_DCACHE_LINE_SIZE
                bltu    r2,r3,1b

                //
                // Setup stack pointer.
                //
                movhi   sp,%hi(kernel_stack)
                ori     sp,sp,%lo(kernel_stack)
                mov     fp,sp

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                movhi   r2,%hi(adainit)
                ori     r2,r2,%lo(adainit)
                callr   r2

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                movhi   r2,%hi(_ada_main)
                ori     r2,r2,%lo(_ada_main)
                callr   r2

dead:           br      .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

