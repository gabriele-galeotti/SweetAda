
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <arm.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   irq_handler,%function
                .global irq_handler
irq_handler:
                str     r0,[sp,#-4]
                str     r1,[sp,#-8]
                str     r2,[sp,#-12]
                str     r3,[sp,#-16]
                str     r4,[sp,#-20]
                str     r5,[sp,#-24]
                str     r6,[sp,#-28]
                str     r7,[sp,#-32]
                str     r8,[sp,#-36]
                str     r9,[sp,#-40]
                str     r10,[sp,#-44]
                str     r11,[sp,#-48]
                str     r12,[sp,#-52]
                mov     r0,lr
                str     r0,[sp,#-56]
                .extern irq_process
                bl      irq_process
                ldr     r0,[sp,#-56]
                mov     lr,r0
                ldr     r0,[sp,#-4]
                ldr     r1,[sp,#-8]
                ldr     r2,[sp,#-12]
                ldr     r3,[sp,#-16]
                ldr     r4,[sp,#-20]
                ldr     r5,[sp,#-24]
                ldr     r6,[sp,#-28]
                ldr     r7,[sp,#-32]
                ldr     r8,[sp,#-36]
                ldr     r9,[sp,#-40]
                ldr     r10,[sp,#-44]
                ldr     r11,[sp,#-48]
                ldr     r12,[sp,#-52]
                subs    pc,lr,#4

