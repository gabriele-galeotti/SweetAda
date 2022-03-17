
//
// startup.S - MPC8306-SOM startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <e300.h>
#include <mpc8306.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // e300 Power Architecture Core Family Reference Manual,
                // 5.2.3 Steps for Interrupt Processing
                //
                // "If IP is cleared, interrupts are vectored to the physical
                // address 0x000n_nnnn. If IP is set, interrupts are vectored
                // to the physical address 0xFFFn_nnnn."
                //
                // __FIX__ set MSR[IP] so interrupts are visible
                //
                mfmsr   r0
                li      r1,MSR_IP
                andc    r0,r0,r1
                mtmsr   r0

                //
                // Configure HID2, enable BATs 4-7.
                //
                lis     r0,HBE@h
                ori     r0,r0,HBE@l
                mtspr   HID2,r0
                isync

                //
                // BATs setup.
                //
                bl      bats_clear
#define CFG_IMMRBAR        0xFF400000
#define SDRAM_BASE_ADDRESS 0x00000000
#define NANDF_BASE_ADDRESS 0xC0000000
#include "startup-memory.S"

                //
                // Local Bus Window 0.
                //
                lis     r0,NANDF_BASE_ADDRESS@h
                ori     r0,r0,NANDF_BASE_ADDRESS@l
                lis     r1,LBLAWBAR0@h
                ori     r1,r1,LBLAWBAR0@l
                stw     r0,0(r1)
                lis     r0,0x8000001B@h
                ori     r0,r0,0x8000001B@l
                lis     r1,LBLAWAR0@h
                ori     r1,r1,LBLAWAR0@l
                stw     r0,0(r1)
                sync

                bl      tlb_invalidate
                bl      enable_address_translation
                //bl      dcache_enable
                //bl      icache_enable

                //
                // Setup stack pointer.
                //
                lis     r1,kernel_stack@h
                ori     r1,r1,kernel_stack@l
                li      r0,0
                stwu    r0,-64(r1)

                //
                // EABI SDA_BASEx setup.
                //
                //.extern _SDA_BASE_
                //.extern _SDA2_BASE_
                //lis     r2,_SDA2_BASE_@h
                //ori     r2,r2,_SDA2_BASE_@l
                //lis     r13,_SDA_BASE_@h
                //ori     r13,r13,_SDA_BASE_@l

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                bl      adainit

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

//
// Clear all BATs.
//
bats_clear:
                lis     r0,0
                mtspr   IBAT0U,r0
                mtspr   IBAT1U,r0
                mtspr   IBAT2U,r0
                mtspr   IBAT3U,r0
                mtspr   IBAT4U,r0
                mtspr   IBAT5U,r0
                mtspr   IBAT6U,r0
                mtspr   IBAT7U,r0
                mtspr   DBAT0U,r0
                mtspr   DBAT1U,r0
                mtspr   DBAT2U,r0
                mtspr   DBAT3U,r0
                mtspr   DBAT4U,r0
                mtspr   DBAT5U,r0
                mtspr   DBAT6U,r0
                mtspr   DBAT7U,r0
                isync
                sync
                blr

//
// Invalidate TLBs.
//
tlb_invalidate:
                lis     r3,0
                addis   r5,0,0x2
                isync
1:              tlbie   r3
                sync
                addi    r3,r3,0x1000
                cmp     0,0,r3,r5
                blt     1b
                sync
                blr

//
// Enable address translation.
//
enable_address_translation:
                mfmsr   r5
                ori     r5,r5,(MSR_IR|MSR_DR)
                mtmsr   r5
                isync
                sync
                blr

//
// Enable/Disable/Invalidate cache operations.
//
// e300 Power Architecture Core Family Reference Manual,
// Table 1-1. e300 HID0 Bit Descriptions
//
// "For the e300 core, the proper use of the ICFI and DCFI bits is to set and
// clear them with two consecutive mtspr operations."
// "The data cache must be enabled for the invalidation to occur."
//
dcache_enable:
                mfspr   r3,HID0
                li      r5,(DCFI|DLOCK)                 // default condition
                andc    r3,r3,r5                        // r3 = r3 & ~r5
                mtspr   HID0,r3                         // no invalidate, unlock
                ori     r3,r3,DCE                       // r3 = DCE set
                ori     r5,r3,DCFI                      // r5 = DCE, DCFI set
                mtspr   HID0,r5                         // enable + invalidate
                mtspr   HID0,r3                         // enable
                sync
                blr
icache_enable:
                mfspr   r3,HID0
                li      r5,(ICFI|ILOCK)                 // default condition
                andc    r3,r3,r5                        // r3 = r3 & ~r5
                mtspr   HID0,r3                         // no invalidate, unlock
                ori     r3,r3,ICE                       // r3 = ICE set
                ori     r5,r3,ICFI                      // r5 = ICE, ICFI set
                mtspr   HID0,r5                         // enable + invalidate
                mtspr   HID0,r3                         // enable
                sync
                blr

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  3
                .space  4096
kernel_stack:

