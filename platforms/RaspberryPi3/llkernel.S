
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

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
el3_celspx_irq: b       .                       // + 0x280 IRQ/vIRQ
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
el2_celspx_syn: b       .                       // + 0x200 Synchronous
                .align  7
el2_celspx_irq: b       .                       // + 0x280 IRQ/vIRQ
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
                b       .
                .extern exception_process
                bl      exception_process
                eret

irq_handler:
                sub     sp,sp,256
                stp     x0,x1,[sp,#16*0]
                stp     x2,x3,[sp,#16*1]
                stp     x4,x5,[sp,#16*2]
                stp     x6,x7,[sp,#16*3]
                stp     x8,x9,[sp,#16*4]
                stp     x10,x11,[sp,#16*5]
                stp     x12,x13,[sp,#16*6]
                stp     x14,x15,[sp,#16*7]
                stp     x16,x17,[sp,#16*8]
                stp     x18,x19,[sp,#16*9]
                stp     x20,x21,[sp,#16*10]
                stp     x22,x23,[sp,#16*11]
                stp     x24,x25,[sp,#16*12]
                stp     x26,x27,[sp,#16*13]
                stp     x28,x29,[sp,#16*14]
                stp     x29,x30,[sp,#16*15]
                .extern irq_process
                bl      irq_process
                ldp     x0,x1,[sp,#16*0]
                ldp     x2,x3,[sp,#16*1]
                ldp     x4,x5,[sp,#16*2]
                ldp     x6,x7,[sp,#16*3]
                ldp     x8,x9,[sp,#16*4]
                ldp     x10,x11,[sp,#16*5]
                ldp     x12,x13,[sp,#16*6]
                ldp     x14,x15,[sp,#16*7]
                ldp     x16,x17,[sp,#16*8]
                ldp     x18,x19,[sp,#16*9]
                ldp     x20,x21,[sp,#16*10]
                ldp     x22,x23,[sp,#16*11]
                ldp     x24,x25,[sp,#16*12]
                ldp     x26,x27,[sp,#16*13]
                ldp     x28,x29,[sp,#16*14]
                ldp     x29,x30,[sp,#16*15]
                add     sp,sp,256
                eret

