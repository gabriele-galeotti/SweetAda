
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>
#include <coldfire.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global VECTOR_TABLE
                .global _VECTOR_TABLE
                .extern __SDRAM
                .extern __SDRAM_SIZE
                .extern __SP_INIT
                .extern __IPSBAR
                .extern __DATA_END
                .extern ___BSS_START
                .extern ___BSS_END
                .extern _start_kernel
                .extern irq_handler
                .extern pit0_handler
                .extern pit1_handler
                .extern fec_handler

                .type   _start,@function
                .global _start
_start:

                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts

                //
                // Disable the ACRs and cache.
                //
                moveq.l #0,%d0
                movec.l %d0,%acr0
                movec.l %d0,%acr1
                movec.l %d0,%cacr
                jmp     1f
1:

                //
                // IPSBAR initialization.
                //
                move.l  #(IPSBAR+1),%d0                 // bit0 = 1 --> mark as valid
                move.l  %d0,IPSBAR_DEFAULT              // store in IPSBAR power-on configuration register

                //
                // Disable watchdog and test logic safeguard (9.3.2).
                //
                clr.w   SCM_CWCR
                clr.l   CCM_TEST

                //
                // Setup VBR.
                //
                //move.l  #vector_table,%d0                       // MCF5200 PRM Section 5, "Supervisor (privileged) instructions"
                //movec.l %d0,%vbr

                //
                // Core/SCM RAMBAR initialization, see RM 6.2.1
                //
                //move.l  #(RAMBAR_BASE_ADDRESS+0x0201),%d0       // bit9 = SPV --> DMA access OK
                //movec.l %d0,#0xC05                              // store in CPU-dependent core RAMBAR register
                //move.l  #(RAMBAR_BASE_ADDRESS+0x0200),%d0       // 11.2.1.2 Memory Base Address Register (RAMBAR)
                //move.l  %d0,MCF_SCM_RAMBAR
#if defined(USE_A5)
                // data segment reference
                move.l  #__DATA_END,%a5
#endif

                //
                // Setup stack pointer.
                //
                lea.l   kernel_stack,%sp

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                move.l  #_sbss,%a0
                move.l  #_ebss,%a1
1:              cmp.l   %a0,%a1
                beq.s   2f
                clr.b   (%a0)+
                bra.s   1b
2:

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jsr     _ada_main

dead:           jmp     .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

