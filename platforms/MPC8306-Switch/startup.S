
//
// startup.S - Switch startup.
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
                // Configure HID2, enable BATs 4-7.
                //
                lis     r0,HBE@h
                ori     r0,r0,HBE@l
                mtspr   HID2,r0
                isync

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
                // Clear all BATs.
                //
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

                li      r3,32
                mtctr   r3
                li      r3,0
1:              tlbie   r3
                addi    r3,r3,0x1000
                bdnz    1b

//1:              mfctr   r3
//                andi.   r3,r3,0x1
//                bne     1b

                isync
                sync

//
// Configuration registers
// size = 2M 6.2 Local Memory Map Overview and Example
//
// IMMRBAR @ 0xE0000000, PCI IO @ 0xE2000000 & BCSR @ 0xE2400000
#define CFG_IMMRBAR 0xFF400000

#define SDRAM_BASE_ADDRESS 0x00000000
//#define NANDF_BASE_ADDRESS 0xC0000000
#define NANDF_BASE_ADDRESS 0xFF800000

// BAT0 memory block SDRAM
#define CFG_IBAT0L      (SDRAM_BASE_ADDRESS|BATL_PP_10|BATL_MEMCOHERENCE)
#define CFG_IBAT0U      (SDRAM_BASE_ADDRESS|BATU_BL_128M|BATU_VS|BATU_VP)
#define CFG_DBAT0L      (SDRAM_BASE_ADDRESS|BATL_PP_10|BATL_MEMCOHERENCE)
#define CFG_DBAT0U      (SDRAM_BASE_ADDRESS|BATU_BL_128M|BATU_VS|BATU_VP)

// BAT1 memory block NAND Flash
#define CFG_IBAT1L      (NANDF_BASE_ADDRESS|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_IBAT1U      (NANDF_BASE_ADDRESS|BATU_BL_1M|BATU_VS|BATU_VP)
#define CFG_DBAT1L      (NANDF_BASE_ADDRESS|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_DBAT1U      (NANDF_BASE_ADDRESS|BATU_BL_1M|BATU_VS|BATU_VP)

// BAT5 configuration registers
#define CFG_IBAT5L      (CFG_IMMRBAR|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_IBAT5U      (CFG_IMMRBAR|BATU_BL_2M|BATU_VS|BATU_VP)
#define CFG_DBAT5L      (CFG_IMMRBAR|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_DBAT5U      (CFG_IMMRBAR|BATU_BL_2M|BATU_VS|BATU_VP)

                bl      setup_bats
                sync
                bl      enable_address_translation
                sync
                bl      dcache_enable

#if 0
                //
                // Setup IMMRBAR.
                // 6.2.4.1.1 Updating IMMRBAR
                //
                lis     r1,IMMRBAR_DEFAULT@h
                ori     r1,r1,IMMRBAR_DEFAULT@l
                lwz     r0,0(r1)
                lis     r0,IMMRBAR_VALUE@h
                ori     r0,r0,IMMRBAR_VALUE@l
                stw     r0,0(r1)
                lis     r1,0xC0000000@h                 // __FIX__ default memory area
                ori     r1,r1,0xC0000000@l
                lwz     r0,0(r1)
                isync
                lis     r1,IMMRBAR_VALUE@h
                ori     r1,r1,IMMRBAR_VALUE@l
                lwz     r0,0(r1)
                isync
#endif

#if 0
                //
                // Local Bus Window 0.
                //
                lis     r0,NANDF_BASE_ADDRESS@h
                ori     r0,r0,NANDF_BASE_ADDRESS@l
                lis     r1,LBLAWBAR0@h
                ori     r1,r1,LBLAWBAR0@l
                stw     r0,0(r1)
                lis     r0,0x8000000f@h
                ori     r0,r0,0x8000000f@l
                lis     r1,LBLAWAR0@h
                ori     r1,r1,LBLAWAR0@l
                stw     r0,0(r1)
#endif

                //
                // Setup stack pointer.
                //
                lis     r1,kernel_stack@h
                ori     r1,r1,kernel_stack@l
                li      r0,0
                stwu    r0,-64(r1)                      // __FIX__ -64 ???

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
                b       _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

setup_bats:
                // IBAT 0
                lis     r4,CFG_IBAT0L@h
                ori     r4,r4,CFG_IBAT0L@l
                lis     r3,CFG_IBAT0U@h
                ori     r3,r3,CFG_IBAT0U@l
                mtspr   IBAT0L,r4
                mtspr   IBAT0U,r3
                isync
                // DBAT 0
                lis     r4,CFG_DBAT0L@h
                ori     r4,r4,CFG_DBAT0L@l
                lis     r3,CFG_DBAT0U@h
                ori     r3,r3,CFG_DBAT0U@l
                mtspr   DBAT0L,r4
                mtspr   DBAT0U,r3
                isync
                // IBAT 1
                lis     r4,CFG_IBAT1L@h
                ori     r4,r4,CFG_IBAT1L@l
                lis     r3,CFG_IBAT1U@h
                ori     r3,r3,CFG_IBAT1U@l
                mtspr   IBAT1L,r4
                mtspr   IBAT1U,r3
                isync
                // DBAT 1
                lis     r4,CFG_DBAT1L@h
                ori     r4,r4,CFG_DBAT1L@l
                lis     r3,CFG_DBAT1U@h
                ori     r3,r3,CFG_DBAT1U@l
                mtspr   DBAT1L,r4
                mtspr   DBAT1U,r3
                isync
#if 0
                // BATs 2-4
                lis     r4,CFG_IBATxL@h
                ori     r4,r4,CFG_IBATxL@l
                lis     r3,CFG_IBATxU@h
                ori     r3,r3,CFG_IBATxU@l
                mtspr   IBAT2L,r4
                mtspr   IBAT2U,r3
                mtspr   DBAT2L,r4
                mtspr   DBAT2U,r3
                mtspr   IBAT3L,r4
                mtspr   IBAT3U,r3
                mtspr   DBAT3L,r4
                mtspr   DBAT3U,r3
                mtspr   IBAT4L,r4
                mtspr   IBAT4U,r3
                mtspr   DBAT4L,r4
                mtspr   DBAT4U,r3
                isync
#endif
                // IBAT 5
                lis     r4,CFG_IBAT5L@h
                ori     r4,r4,CFG_IBAT5L@l
                lis     r3,CFG_IBAT5U@h
                ori     r3,r3,CFG_IBAT5U@l
                mtspr   IBAT5L,r4
                mtspr   IBAT5U,r3
                isync
                // DBAT 5
                lis     r4,CFG_DBAT5L@h
                ori     r4,r4,CFG_DBAT5L@l
                lis     r3,CFG_DBAT5U@h
                ori     r3,r3,CFG_DBAT5U@l
                mtspr   DBAT5L,r4
                mtspr   DBAT5U,r3
                isync
                //
                // Invalidate TLBs.
                //
                lis     r3,0
                addis   r5,0,0x2
                isync
1:              tlbie   r3
                sync
                addi    r3,r3,0x1000
                cmp     0,0,r3,r5
                blt     1b
                blr

//
// Enable address translation.
//

enable_address_translation:
                mfmsr   r5
                ori     r5,r5,(MSR_IR|MSR_DR)
                mtmsr   r5
                isync
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
//                mfspr   r3,HID0
//                li      r5,(DCFI|DLOCK)                 // default condition
//                andc    r3,r3,r5                        // r3 = r3 & ~r5
//                mtspr   HID0,r3                         // no invalidate, unlock
//                ori     r3,r3,DCE                       // r3 = DCE set
//                ori     r5,r3,DCFI                      // r5 = DCE, DCFI set
//                mtspr   HID0,r5                         // enable + invalidate
//                mtspr   HID0,r3                         // enable
//                sync
                blr

icache_enable:
//                mfspr   r3,HID0
//                li      r5,(ICFI|ILOCK)
//                andc    r3,r3,r5
//                mtspr   HID0,r3
//                ori     r3,r3,ICE
//                ori     r5,r3,ICFI
//                mtspr   HID0,r5
//                mtspr   HID0,r3
//                sync
                blr

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  3
                .space  4096
kernel_stack:

