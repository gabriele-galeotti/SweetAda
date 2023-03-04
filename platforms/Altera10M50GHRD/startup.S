
//
// startup.S - Altera 10M50 GHRD startup (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
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
                // Register #4 contains 0x534F494E "SOIN".
                //

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
                mov     r1,r0
                movhi   r2,%hi(NIOS2_ICACHE_SIZE)
                ori     r2,r2,%lo(NIOS2_ICACHE_SIZE)
1:              initi   r1
                addi    r1,r1,NIOS2_ICACHE_LINE_SIZE
                bltu    r1,r2,1b

                //
                // Invalidate data cache.
                //
#define NIOS2_DCACHE_SIZE      0
#define NIOS2_DCACHE_LINE_SIZE 4
                mov     r1,r0
                movhi   r2,%hi(NIOS2_DCACHE_SIZE)
                ori     r2,r2,%lo(NIOS2_DCACHE_SIZE)
1:              initd   0(r1)
                addi    r1,r1,NIOS2_DCACHE_LINE_SIZE
                bltu    r1,r2,1b

                //
                // Clear .bss section.
                //
                .extern _sbss
                .extern _ebss
                movhi   r1,%hi(_sbss)
                ori     r1,r1,%lo(_sbss)
                movhi   r2,%hi(_ebss)
                ori     r2,r2,%lo(_ebss)
1:              stb     r0,0(r1)
                addi    r1,r1,1
                bne     r1,r2,1b

                //
                // Setup stack pointer.
                //
                movhi   sp,%hi(kernel_stack)
                ori     sp,sp,%lo(kernel_stack)
                mov     fp,sp

                //
                // Setup global pointer.
                //
                .extern _gp
                movhi   gp,%hi(_gp)
                ori     gp,gp,%lo(_gp)

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                movhi   r2,%hi(_ada_main)
                ori     r2,r2,%lo(_ada_main)
                callr   r2

dead:           break

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

