
//
// startup.S - AArch64 startup (QEMU emulator).
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

                b       startcode

startcode:
                //
                // Allow only master core to execute code.
                //
                mrs     x0,mpidr_el1
                mov     x1,#0xC1000000
                bic     x0,x0,x1
                cbz     x0,bootcore
hold:           b       .
bootcore:

                //
                // Static data relocation.
                //
                .extern _etext
                .extern _sdata
                .extern _edata
                ldr     x1,=_etext
                ldr     x2,=_sdata
                ldr     x3,=_edata
                cmp     x2,x3
                beq     2f
1:              ldr     x0,[x1],#8
                str     x0,[x2],#8
                cmp     x2,x3
                blt     1b
2:

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                ldr     x1,=_sbss
                ldr     x2,=_ebss
                cmp     x1,x2
                beq     2f
                ldr     x0,=0
1:              str     x0,[x1],#8
                cmp     x1,x2
                blt     1b
2:

                //
                // Setup stack pointer.
                //
                ldr     x0,=SVC_stack
                mov     sp,x0

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

