
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <ppc405ep.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .reset,"ax"

                //
                // Reset entry point.
                // PowerPC 405 Embedded Processor Core User''s Manual, 3.2 PPC405 Initial
                // Processor Sequencing
                // Reset address: 0xFFFFFFFC
                //

                b       _start

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   _start,@function
                .global _start
_start:

                mfccr0  3
                oris    3,3,0x50000000@h
                mtccr0  3
                //
                // PowerPC 405 Embedded Processor Core User''s Manual
                // 7.8.1.4 Storage Guarded Register (SGR)
                //
                // Setta il bit 29 a 1 per configurare la zona di memoria
                // 0xE8000000-0xEFFFFFFF come I/O "guarded".
                //
                lis     r0,(1 << 29)@ha
                mtspr   SGR,r0
                // from gbios_0_2/ppc/crt0.s
                //isync
                //
                // Disable dcache and MMU, so that init_memory stands a chance.
                //
                li      r0,0
                mtspr   0x3F0,r0                // Debug Status Register 1008
                sync
                //mtmsr   r0                      // MSR = R0
                //sync
                //
                // Setup stack pointer.
                //
                lis     r1,kernel_stack@ha
                addi    r1,r1,kernel_stack@l
                li      r0,0
                stwu    r0,-64(r1)              // -64 ???

                //lis     r2,_SDA2_BASE@ha # r2 is the read-only SDA anchor
                //addi    r2,r2,_SDA2_BASE@l
                //lis     r13,_SDA_BASE@ha # r13 is the read-write SDA anchor
                //addi    r13,r13,_SDA_BASE@l

                //
                // Initialize EVPR.
                // PowerPC 405 Embedded Processor Core User''s Manual
                // 5.4 Critical and Noncritical Interrupts
                //
                //lis     r0,ivtable@ha
                //mtspr   EVPR,r0

                //
                // Set EE bit (External interrupt Enable) in MSR.
                //
                //mfmsr   r0
                //ori     r0,r0,EE
                //mtmsr   r0

                //
                // UIC0 setup.
                //
                //lis     r0,0x8000
                //mtdcr   UIC0_ER,r0
                //lis     r0,0
                //mtdcr   UIC0_CR,r0
                //lis     r0,0x8000
                //mtdcr   UIC0_PR,r0
                //lis     r0,0
                //mtdcr   UIC0_TR,r0

                //
                // Set PIT count rate.
                //
                //lis     r0,0x0200
                //mtspr   PIT,r0
                //
                // Set PIE bit (PIT Interrupt Enable) in TCR.
                //
                //lis     r0,(PIE | ARE)@ha
                //mtspr   TCR,r0

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

