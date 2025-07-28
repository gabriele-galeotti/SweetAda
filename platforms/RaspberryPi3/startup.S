
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include "mmu.h"

////////////////////////////////////////////////////////////////////////////////

                .arch   armv8-a

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                //
                // Disable all DAIF exceptions.
                //
                msr     daifset,#0xF

                //
                // CPACR_EL1/FPEN Advanced SIMD and floating-point registers.
                //
#define CPACR_FPEN_NOTRAP (3<<20)
                mrs     x1,cpacr_el1
                orr     x0,x1,#CPACR_FPEN_NOTRAP
                msr     cpacr_el1,x0
                isb

#if defined(STARTUP_EL1)
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
#define SCTLR_DEFAULT  ((3<<28)|(3<<22)|(1<<20)|(1<<11))
#define HCR_RW         (1<<31)
#define SPSR_MASK_ALL  (7<<6)
#define SPSR_MODE_EL0  (0<<0)
#define SPSR_MODE_ELt  (4<<0)
#define SPSR_MODE_EL1h (5<<0)
#define SPSR_MODE_EL2t (8<<0)
#define SPSR_MODE_EL2h (9<<0)
                ldr     x0,=SCTLR_DEFAULT
                msr     sctlr_el1,x0
                ldr     x0,=HCR_RW
                msr     hcr_el2,x0
                ldr     x0,=(SPSR_MASK_ALL|SPSR_MODE_EL1h)
                msr     spsr_el2,x0
                adr     x0,1f
                msr     elr_el2,x0
                eret
1:
#endif

                //
                // Enable CPUECTLR_EL1.SMPEN.
                //
#define CPUECTLR_SMPEN (1<<6)
                mrs     x0,s3_1_c15_c2_1
                //orr     x0,x0,#CPUECTLR_SMPEN
                //msr     s3_1_c15_c2_1,x0
                //isb
                cmp     x0,#CPUECTLR_SMPEN
                beq     1f
                b       .
1:

                //
                // Enable MMU.
                //
                .extern mmu_l1
                .extern mmu_l2
                tlbi    alle2
                movz    x0,#(0<<8|0xEE<<0)
                msr     mair_el2,x0
                adrp    x0,mmu_l1
                adrp    x1,mmu_l2
                orr     x1,x1,#MMU_TABLE_DESCRIPTOR
                str     x1,[x0]
                msr     ttbr0_el2,x0
                ldr     x0,=(TCR_T0SZ_31|TCR_IRGN0|TCR_ORGN0|TCR_SH0)
                msr     tcr_el2,x0
                isb

                //
                // Enable cache.
                //
#define SCTLR_M   (1<<0)
#define SCTLR_C   (1<<2)
#define SCTLR_I   (1<<12)
#define SCTLR_WXN (1<<19)
                mrs     x0,sctlr_el2
                bic     x0,x0,#SCTLR_WXN
                movz    x1,#(SCTLR_M|SCTLR_C|SCTLR_I)
                orr     x0,x0,x1
                msr     sctlr_el2, x0
                isb

                //
                // Allow only master core to execute code.
                //
                mrs     x0,mpidr_el1
                and     x0,x0,#0xFF
                cbnz    x0,core_is_ap

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                ldr     x1,=_sbss
                ldr     x2,=_ebss
                mov     w0,#0
                b       2f
1:              str     w0,[x1],#4
2:              cmp     x1,x2
                blt     1b

                //
                // Setup stack pointer.
                //
                ldr     x0,=kernel_stack
                mov     sp,x0
                mov     fp,sp

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

core_is_ap:
                // x0 contains core #
                .extern ap_key
                .extern ap_sp
                .extern ap_pc
                ldr     x1,=ap_key
                ldr     w2,=0xAA55AA55
1:              ldr     w3,[x1],#0
                cmp     w2,w3
                bne     1b
                ldr     x1,=ap_sp
                ldr     x2,=ap_pc
                lsl     x0,x0,#3
                add     x1,x1,x0
                add     x2,x2,x0
1:              ldr     x13,[x1],#0
                ldr     x3,[x2],#0
                cbz     x13,1b
                cbz     x3,1b
                mov     sp,x13
                br      x3

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  4096
kernel_stack:

