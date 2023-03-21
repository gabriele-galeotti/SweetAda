
//
// startup.S - MIPS 24Kf Malta startup (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

#define CONFIG_K0_MASK  (7 << 0)
#define CONFIG_KU_MASK  (7 << 25)
#define CONFIG_K23_MASK (7 << 28)

#define CACHE_ATTRIBUTE_NC_WT_NVA 0     // cacheable, noncoherent, write-through, no write allocate
#define CACHE_ATTRIBUTE_UNCACHED  2     // uncached
#define CACHE_ATTRIBUTE_NC_WB_WA  3     // cacheable, noncoherent, write-back, write allocate
#define CACHE_ATTRIBUTE_UNCACHEDA 7     // uncached accelerated

////////////////////////////////////////////////////////////////////////////////

                .sect   .text

                .type   _init,@function
                .global _init
_init:

                //
                // Zero all registers.
                //
                .set    noat
                move    $1,$0
                .set    at
                move    $2,$0
                move    $3,$0
                move    $4,$0
                move    $5,$0
                move    $6,$0
                move    $7,$0
                move    $8,$0
                move    $9,$0
                move    $10,$0
                move    $11,$0
                move    $12,$0
                move    $13,$0
                move    $14,$0
                move    $15,$0
                move    $16,$0
                move    $17,$0
                move    $18,$0
                move    $19,$0
                move    $20,$0
                move    $21,$0
                move    $22,$0
                move    $23,$0
                move    $24,$0
                move    $25,$0
                move    $26,$0
                move    $27,$0
                move    $28,$0
                move    $29,$0
                move    $30,$0
                move    $31,$0

                // KSU=0, ERL=0, EXL=0
                mfc0    $t0,CP0_SR
                nop
                la      $t1,~(0x18|0x6)
                and     $t0,$t1
                mtc0    $t0,CP0_SR
                nop

                // clear CP0_Cause, CP0_WatchLo, CP0_WatchHi
                mtc0    $0,CP0_Cause
                mtc0    $0,CP0_WatchLo
                mtc0    $0,CP0_WatchHi
                nop

                // disable cacheability in kseg2/kseg3, kuseg/useg, kseg0
                mfc0    $t0,CP0_Config
                nop
                la      $t1,~(CONFIG_K0_MASK|CONFIG_KU_MASK|CONFIG_K23_MASK)
                and     $t0,$t1
                la      $t1,(CACHE_ATTRIBUTE_UNCACHED<<28)|(CACHE_ATTRIBUTE_UNCACHED<<25)|(CACHE_ATTRIBUTE_UNCACHED<<0)
                or      $t0,$t1
                mtc0    $t0,CP0_Config
                nop

                // IV=0, use the general exception vector (0x0180)
                mfc0    $t0,CP0_Cause
                nop
                la      $t1,~(0x00800000)
                and     $t0,$t1
                mtc0    $t0,CP0_Config
                nop

                // TLB initialization
                //jal     tlb_reset
                //nop

                //
                // Code relocation.
                //
                //jal     movcode
                //nop

                //
                // Static data relocation.
                //
                jal     movdata
                nop

                //
                // Initialize .bss section.
                //
                jal     zerobss
                nop

                //
                // Setup stack pointer.
                //
                la      $sp,kernel_stack

                //
                // "The fp register points to the base of the stack frame for
                // the current function"
                //
                move    $fp,$sp
                move    $ra,$0

                //
                // Setup global pointer.
                //
                .extern _gp
                lui     $gp,%hi(_gp)
                ori     $gp,%lo(_gp)

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                la      $t0,_ada_main
                jalr    $t0
                nop

dead:           b       .
                nop

                .size   _init,.-_init

#if 0
////////////////////////////////////////////////////////////////////////////////
// movcode                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movcode:
                .set    noreorder
                .extern _text_start
                .extern _stext
                .extern _etext
                la      $t0,_text_start
                la      $t1,_stext
                la      $t2,_etext
                beq     $t1,$t2,3f
                nop
                b       2f
                nop
1:              move    $t3,$t1
                addiu   $t1,$t3,4
                move    $t4,$t0
                addiu   $t0,$t4,4
                lw      $t4,0($t4)
                sw      $t4,0($t3)
2:              sltu    $t3,$t1,$t2
                bne     $t3,$0,1b
                nop
3:              jr      $ra
                nop
                .set    reorder
#endif

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movdata:
                .set    noreorder
                .extern _etext
                .extern _sdata
                .extern _edata
                la      $t0,_etext
                la      $t1,_sdata
                la      $t2,_edata
                beq     $t1,$t2,3f
                nop
                b       2f
                nop
1:              move    $t3,$t1
                addiu   $t1,$t3,4
                move    $t4,$t0
                addiu   $t0,$t4,4
                lw      $t4,0($t4)
                sw      $t4,0($t3)
2:              sltu    $t3,$t1,$t2
                bne     $t3,$0,1b
                nop
3:              jr      $ra
                nop
                .set    reorder

////////////////////////////////////////////////////////////////////////////////
// zerobss                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

zerobss:
                .set    noreorder
                .extern _sbss
                .extern _ebss
                la      $t0,_sbss
                la      $t1,_ebss-4
1:              sw      $0,($t0)
                bne     $t0,$t1,1b
                addiu   $t0,4                   // delay slot
                jr      $ra
                nop
                .set    reorder

////////////////////////////////////////////////////////////////////////////////
// tlb_reset                                                                  //
//                                                                            //
// Initialize the TLB.                                                        //
// vmips-1.5/sample_code/setup.S                                              //
////////////////////////////////////////////////////////////////////////////////

tlb_reset:
                .set    noreorder
                li      $t0,0                   // t0 <- tlb index number (shifted)
                li      $t1,0x81000000          // t1 <- tlb reset vaddr
1:              mtc0    $0,CP0_EntryLo          // set up proposed tlb entry for reset
                mtc0    $t1,CP0_EntryHi
                ssnop                           // wait for pipeline hazard
                ssnop
                tlbp                            // check if it already exists
                ssnop                           // wait for pipeline hazard
                ssnop
                mfc0    $t2,CP0_Index
                bgez    $t2,1b                  // if it does, loop back
                addiu   $t1,$t1,0x1000          // next vaddr (in delay slot)
                mtc0    $t0,CP0_Index           // doesn''t exist, set index to write to
                ssnop                           // wait for pipeline hazard
                ssnop
                addiu   $t0,$t0,0x100           // next tlb index (shifted)
                bne     $t0,0x4000,1b           // if it''s not the last tlb index, loop
                tlbwi                           // write tlb entry (in delay slot)
                jr      $ra                     // done
                nop                             // delay slot
                .set    reorder

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

