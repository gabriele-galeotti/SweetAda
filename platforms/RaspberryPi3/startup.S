
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
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

                //
                // Allow only master core to execute code.
                //
                mrs     x0,mpidr_el1
                and     x0,x0,#0xFF
                cbz     x0,bootcore
hold:           wfe
                b       hold
bootcore:

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
                // CPACR_EL1/FPEN Advanced SIMD and floating-point registers.
                //
                mrs     x1,cpacr_el1
                orr     x0,x1,#(3<<20)
                msr     cpacr_el1,x0

                //
                // Ensure completion of previous instructions.
                //
                isb

                //
                // Setup stack pointer.
                //
                ldr     x0,=kernel_stack
                mov     sp,x0

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

                .align  4
                .space  4096
kernel_stack:

