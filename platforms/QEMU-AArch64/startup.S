
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

                .arch   armv8-a

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                b       startcode

startcode:

                //
                // Disable all DAIF exceptions.
                //
                msr     daifset,#0xF

                //
                // CPACR_EL1/FPEN Advanced SIMD and floating-point registers.
                //
                mrs     x1,cpacr_el1
                orr     x0,x1,#(3<<20)
                msr     cpacr_el1,x0

                //
                // Enable CPUECTLR_EL1.SMPEN.
                //
                mrs     x0,s3_1_c15_c2_1
                orr     x0,x0,#0x40
                msr     s3_1_c15_c2_1,x0

                //
                // Ensure completion of previous instructions.
                //
                isb

                //
                // Allow only master core to execute code.
                //
                mrs     x0,mpidr_el1
                and     x0,x0,#0xFF
                cbnz    x0,core_is_ap

                //
                // Static data relocation.
                //
                .extern _etext
                .extern _sdata
                .extern _edata
#if   defined(__LP64__)
                ldr     x1,=_etext
                ldr     x2,=_sdata
                ldr     x3,=_edata
                b       2f
1:              ldr     x0,[x1],#8
                str     x0,[x2],#8
2:              cmp     x2,x3
                blt     1b
#elif defined(__ILP32__)
                ldr     w1,=_etext
                ldr     w2,=_sdata
                ldr     w3,=_edata
                b       2f
1:              ldr     w0,[x1],#4
                str     w0,[x2],#4
2:              cmp     w2,w3
                blt     1b
#else
#error no ABI defined
#endif

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
#if   defined(__LP64__)
                ldr     x1,=_sbss
                ldr     x2,=_ebss
                mov     x0,#0
                b       2f
1:              str     x0,[x1],#8
2:              cmp     x1,x2
                blt     1b
#elif defined(__ILP32__)
                ldr     w1,=_sbss
                ldr     w2,=_ebss
                mov     w0,#0
                b       2f
1:              str     w0,[x1],#4
2:              cmp     w1,w2
                blt     1b
#else
#error no ABI defined
#endif

                //
                // Setup stack pointer.
                //
#if   defined(__LP64__)
                ldr     x0,=kernel_stack
                mov     sp,x0
#elif defined(__ILP32__)
                ldr     w0,=kernel_stack
                mov     wsp,w0
#else
#error no ABI defined
#endif

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
#if   defined(__LP64__)
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
#elif defined(__ILP32__)
1:              wfe
                b       1b
#else
#error no ABI defined
#endif

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  4096
kernel_stack:

