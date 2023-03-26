
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <armv4.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   irq_handler,%function
                .global irq_handler
irq_handler:
                sub     sp,sp,#64
                str     r0,[sp]
                str     r1,[sp,#4]
                str     r2,[sp,#8]
                str     r3,[sp,#12]
                str     r4,[sp,#16]
                str     r5,[sp,#20]
                str     r6,[sp,#24]
                str     r7,[sp,#28]
                str     r8,[sp,#32]
                str     r9,[sp,#36]
                str     r10,[sp,#40]
                str     r11,[sp,#44]
                str     r12,[sp,#48]
                str     lr,[sp,#52]
                .extern irq_process
                bl      irq_process
                ldr     r0,[sp]
                ldr     r1,[sp,#4]
                ldr     r2,[sp,#8]
                ldr     r3,[sp,#12]
                ldr     r4,[sp,#16]
                ldr     r5,[sp,#20]
                ldr     r6,[sp,#24]
                ldr     r7,[sp,#28]
                ldr     r8,[sp,#32]
                ldr     r9,[sp,#36]
                ldr     r10,[sp,#40]
                ldr     r11,[sp,#44]
                ldr     r12,[sp,#48]
                ldr     lr,[sp,#52]
                add     sp,sp,#64
                subs    pc,lr,#4

