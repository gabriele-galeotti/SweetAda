
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

                .option arch,+zicsr,+zifencei

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // CSR initialization.
                //
                csrrwi  zero,mstatus,0
                csrw    mie,zero

                //
                // Setup stack pointer.
                //
                la      sp,kernel_stack

                //
                // Setup global pointer.
                //
                .extern _gp
                la      gp,_gp

                //
                // Static data relocation.
                //
                .extern _etext
                .extern _sdata
                .extern _edata
                la      x11,_etext
                la      x12,_sdata
                la      x13,_edata
                beq     x11,x12,2f
1:              bge     x12,x13,2f
                lw      x14,0(x11)
                sw      x14,0(x12)
                addi    x11,x11,4
                addi    x12,x12,4
                j       1b
2:

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                la      t0,_sbss
                la      t1,_ebss
                ble     t1,t0,2f
1:              sw      zero,(t0)
                add     t0,t0,__SIZEOF_POINTER__
                blt     t0,t1,1b
2:

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jal     _ada_main

dead:           j       .

hart_idle:
                wfi
                j       hart_idle

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  1024
kernel_stack:

