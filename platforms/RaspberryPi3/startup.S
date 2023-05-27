
//
// startup.S - Raspberry Pi 3 startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .arch   armv8-a

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                msr     daifset,#2
                b       startcode

startcode:
                //
                // Allow only master core to execute code.
                //
                mrs     x0,mpidr_el1
                and     x0,x0,#0xFF
                cbz     x0,bootcore
hold:           wfe
                b       hold

bootcore:

                //
                // Check if current level = EL1.
                //
                mrs     x0,currentel
                ubfx    x1,x0,2,2
                cmp     x1,1
                beq     1f
                //
                // EL2 ---> EL1
                //
                ldr     x0,=(3<<28|3<<22|1<<20|1<<11)
                msr     sctlr_el1,x0
                ldr     x0,=(1<<31)
                msr     hcr_el2,x0
                ldr     x0,=(7<<6|5<<0)
                msr     spsr_el2,x0
                adr     x0,1f
                msr     elr_el2,x0
                eret
1:

                //
                // Setup stack pointer.
                //
                ldr     x0,=SVC_stack
                mov     sp,x0

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                ldr     x1,=_sbss
                ldr     x2,=_ebss
                b       2f
                mov     w0,#0
1:              str     w0,[x1],#4
2:              cmp     x1,x2
                blt     1b

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
SVC_stack:

