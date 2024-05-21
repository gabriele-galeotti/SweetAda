
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
#if   __LP64__ == 1
                ldr     x0,=kernel_stack
                mov     sp,x0
#elif __ILP32__ == 1
                ldr     w0,=kernel_stack
                mov     wsp,w0
#else
#error no ABI defined
#endif

                //
                // Static data relocation.
                //
                .extern _etext
                .extern _sdata
                .extern _edata
#if   __LP64__ == 1
                ldr     x1,=_etext
                ldr     x2,=_sdata
                ldr     x3,=_edata
                b       2f
1:              ldr     x0,[x1],#8
                str     x0,[x2],#8
2:              cmp     x2,x3
                blt     1b
#elif __ILP32__ == 1
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
#if   __LP64__ == 1
                ldr     x1,=_sbss
                ldr     x2,=_ebss
                mov     x0,#0
                b       2f
1:              str     x0,[x1],#8
2:              cmp     x1,x2
                blt     1b
#elif __ILP32__ == 1
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

