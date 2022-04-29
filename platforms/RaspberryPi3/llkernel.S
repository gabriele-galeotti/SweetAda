
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global el1_table
                .align  8
el1_table:
                // Current EL with SP0
                .align  7
el1_celsp0_syn: b       el1_handler             // + 0x000 Synchronous
                .align  7
el1_celsp0_irq: b       el1_handler             // + 0x080 IRQ/vIRQ
                .align  7
el1_celsp0_fiq: b       el1_handler             // + 0x100 FIQ/vFIQ
                .align  7
el1_celsp0_serr:b       el1_handler             // + 0x180 SError/vSError
                // Current EL with SPx
                .align  7
el1_celspx_syn: b       el1_handler             // + 0x200 Synchronous
                .align  7
el1_celspx_irq: b       el1_handler             // + 0x280 IRQ/vIRQ
                .align  7
el1_celspx_fiq: b       el1_handler             // + 0x300 FIQ/vFIQ
                .align  7
el1_celspx_serr:b       el1_handler             // + 0x380 SError/vSError
                // Lower EL using AArch64
                .align  7
el1_lel64_syn:  b       el1_handler             // + 0x400 Synchronous
                .align  7
el1_lel64_irq:  b       el1_handler             // + 0x480 IRQ/vIRQ
                .align  7
el1_lel64_fiq:  b       el1_handler             // + 0x500 FIQ/vFIQ
                .align  7
el1_lel64_serr: b       el1_handler             // + 0x580 SError/vSError
                // Lower EL using AArch32
                .align  7
el1_lel32_syn:  b       el1_handler             // + 0x600 Synchronous
                .align  7
el1_lel32_irq:  b       el1_handler             // + 0x680 IRQ/vIRQ
                .align  7
el1_lel32_fiq:  b       el1_handler             // + 0x700 FIQ/vFIQ
                .align  7
el1_lel32_serr: b       el1_handler             // + 0x780 SError/vSError

                .extern exception_process
el1_handler:    b       exception_process

