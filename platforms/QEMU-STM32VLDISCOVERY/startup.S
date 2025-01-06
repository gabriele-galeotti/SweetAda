
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

                .syntax unified

                .sect   .startup,"ax"

                .thumb_func
                .type   _start,%function
                .global _start
_start:

                //
                // Disable interrupts.
                //
                cpsid   i
                cpsid   f

                //
                // Setup stack pointer.
                //
                ldr     r0,=kernel_stack
                mov     sp,r0

                //
                // Static data relocation.
                //
                bl      movdata

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                ldr     r1,=_sbss
                ldr     r2,=_ebss
                mov     r0,#0
                b       2f
1:              stm     r1!,{r0}
2:              cmp     r1,r2
                bne     1b

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

                .thumb_func
movdata:
                // registers used: r0-r4
                .extern _etext
                .extern _sdata
                .extern _edata
                ldr     r1,=_etext
                ldr     r2,=_sdata
                ldr     r3,=_edata
                cmp     r2,r3
                beq     2f
                sub     r3,r3,r2
                mov     r4,#0
1:              ldr     r0,[r1,r4]
                str     r0,[r2,r4]
                add     r4,#4
                cmp     r4,r3
                blt     1b
2:              bx      lr

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  3
                .space  1024
kernel_stack:

