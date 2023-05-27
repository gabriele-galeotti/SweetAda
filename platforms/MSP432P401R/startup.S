
//
// startup.S - MSP432P401R startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                ldr     r0,=stack
                mov     sp,r0

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                ldr     r1,=_sbss
                ldr     r2,=_ebss
                movs    r0,#0
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

                .sect   .bss

                .align  8
                .space  1024
stack:

