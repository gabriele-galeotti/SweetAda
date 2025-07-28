
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

#define STOREREG2SP(r1, r2, x) stp r1,r2,[sp,x]
#define LOADREG2SP(r1, r2, x) ldp r1,r2,[sp,x]

////////////////////////////////////////////////////////////////////////////////

                .arch   armv8-a

                .sect   .text,"ax"

                .align  11
                .global el3_table
el3_table:
                // Current EL with SP0
                .align  7
el3_celsp0_syn: b       .                       // + 0x000 Synchronous
                .align  7
el3_celsp0_irq: b       .                       // + 0x080 IRQ/vIRQ
                .align  7
el3_celsp0_fiq: b       .                       // + 0x100 FIQ/vFIQ
                .align  7
el3_celsp0_serr:b       .                       // + 0x180 SError/vSError
                // Current EL with SPx
                .align  7
el3_celspx_syn: b       .                       // + 0x200 Synchronous
                .align  7
el3_celspx_irq: b       irq_handler             // + 0x280 IRQ/vIRQ
                .align  7
el3_celspx_fiq: b       .                       // + 0x300 FIQ/vFIQ
                .align  7
el3_celspx_serr:b       .                       // + 0x380 SError/vSError
                // Lower EL using AArch64
                .align  7
el3_lel64_syn:  b       .                       // + 0x400 Synchronous
                .align  7
el3_lel64_irq:  b       .                       // + 0x480 IRQ/vIRQ
                .align  7
el3_lel64_fiq:  b       .                       // + 0x500 FIQ/vFIQ
                .align  7
el3_lel64_serr: b       .                       // + 0x580 SError/vSError
                // Lower EL using AArch32
                .align  7
el3_lel32_syn:  b       .                       // + 0x600 Synchronous
                .align  7
el3_lel32_irq:  b       .                       // + 0x680 IRQ/vIRQ
                .align  7
el3_lel32_fiq:  b       .                       // + 0x700 FIQ/vFIQ
                .align  7
el3_lel32_serr: b       .                       // + 0x780 SError/vSError

                .align  8
                .global el2_table
el2_table:
                // Current EL with SP0
                .align  7
el2_celsp0_syn: b       .                       // + 0x000 Synchronous
                .align  7
el2_celsp0_irq: b       .                       // + 0x080 IRQ/vIRQ
                .align  7
el2_celsp0_fiq: b       .                       // + 0x100 FIQ/vFIQ
                .align  7
el2_celsp0_serr:b       .                       // + 0x180 SError/vSError
                // Current EL with SPx
                .align  7
el2_celspx_syn: b       el_handler              // + 0x200 Synchronous
                .align  7
el2_celspx_irq: b       irq_handler             // + 0x280 IRQ/vIRQ
                .align  7
el2_celspx_fiq: b       .                       // + 0x300 FIQ/vFIQ
                .align  7
el2_celspx_serr:b       .                       // + 0x380 SError/vSError
                // Lower EL using AArch64
                .align  7
el2_lel64_syn:  b       .                       // + 0x400 Synchronous
                .align  7
el2_lel64_irq:  b       .                       // + 0x480 IRQ/vIRQ
                .align  7
el2_lel64_fiq:  b       .                       // + 0x500 FIQ/vFIQ
                .align  7
el2_lel64_serr: b       .                       // + 0x580 SError/vSError
                // Lower EL using AArch32
                .align  7
el2_lel32_syn:  b       .                       // + 0x600 Synchronous
                .align  7
el2_lel32_irq:  b       .                       // + 0x680 IRQ/vIRQ
                .align  7
el2_lel32_fiq:  b       .                       // + 0x700 FIQ/vFIQ
                .align  7
el2_lel32_serr: b       .                       // + 0x780 SError/vSError

                .align  8
                .global el1_table
el1_table:
                // Current EL with SP0
                .align  7
el1_celsp0_syn: b       .                       // + 0x000 Synchronous
                .align  7
el1_celsp0_irq: b       .                       // + 0x080 IRQ/vIRQ
                .align  7
el1_celsp0_fiq: b       .                       // + 0x100 FIQ/vFIQ
                .align  7
el1_celsp0_serr:b       .                       // + 0x180 SError/vSError
                // Current EL with SPx
                .align  7
el1_celspx_syn: b       .                       // + 0x200 Synchronous
                .align  7
el1_celspx_irq: b       irq_handler             // + 0x280 IRQ/vIRQ
                .align  7
el1_celspx_fiq: b       .                       // + 0x300 FIQ/vFIQ
                .align  7
el1_celspx_serr:b       .                       // + 0x380 SError/vSError
                // Lower EL using AArch64
                .align  7
el1_lel64_syn:  b       .                       // + 0x400 Synchronous
                .align  7
el1_lel64_irq:  b       .                       // + 0x480 IRQ/vIRQ
                .align  7
el1_lel64_fiq:  b       .                       // + 0x500 FIQ/vFIQ
                .align  7
el1_lel64_serr: b       .                       // + 0x580 SError/vSError
                // Lower EL using AArch32
                .align  7
el1_lel32_syn:  b       .                       // + 0x600 Synchronous
                .align  7
el1_lel32_irq:  b       .                       // + 0x680 IRQ/vIRQ
                .align  7
el1_lel32_fiq:  b       .                       // + 0x700 FIQ/vFIQ
                .align  7
el1_lel32_serr: b       .                       // + 0x780 SError/vSError

el_handler:
                .extern exception_process
                b       exception_process

irq_handler:
                sub     sp,sp,256
                STOREREG2SP(x0, x1, 0)
                STOREREG2SP(x2, x3, 16)
                STOREREG2SP(x4, x5, 32)
                STOREREG2SP(x6, x7, 48)
                STOREREG2SP(x8, x9, 64)
                STOREREG2SP(x10,x11,80)
                STOREREG2SP(x12,x13,96)
                STOREREG2SP(x14,x15,112)
                STOREREG2SP(x16,x17,128)
                STOREREG2SP(x18,x19,144)
                STOREREG2SP(x30,xzr,160)
                .extern irq_process
                bl      irq_process
                LOADREG2SP(x0, x1, 0)
                LOADREG2SP(x2, x3, 16)
                LOADREG2SP(x4, x5, 32)
                LOADREG2SP(x6, x7, 48)
                LOADREG2SP(x8, x9, 64)
                LOADREG2SP(x10,x11,80)
                LOADREG2SP(x12,x13,96)
                LOADREG2SP(x14,x15,112)
                LOADREG2SP(x16,x17,128)
                LOADREG2SP(x18,x19,144)
                LOADREG2SP(x30,xzr,160)
                add     sp,sp,256
                eret

