
//
// startup.S - ZOOM startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>

#define SDCS0_SIZE16M 0x17
#define SDCS0_SIZE32M 0x18

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

//
// 14.2.9.1 Interrupt Sources
// 14.3.1.3 Interrupt Vector Determination
//

vector_table:
reset_sp:       .long   0
reset_pc:       .long   _start
                .space  (64-2)*4

// Table 14-15. Interrupt Source Assignment For INTC0
                .space  (64)*4                          // INTC0 vectors 0..63 (+64)

// Table 14-16. Interrupt Source Assignment for INTC1
                .space  (40)*4                          // INTC1 vectors 0..39 (+128) Not Used
                .long   0                               // INTC1 vector 40 (+128) RNG
                .long   0                               // INTC1 vector 41 (+128) SKHA
                .long   0                               // INTC1 vector 42 (+128) MDHA
                .extern pit0_handler
                .long   pit0_handler                    // INTC1 vector 43 (+128) PIT0

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   _start,@function
                .global _start
_start:

                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts

                // __FIX__
                //clr.w   MCF_WTM_WCR                     // disable watchdog

                //
                // Invalidate the cache and disable it.
                //
                move.l  #0x01000000,%d0
                movec.l %d0,%cacr
                jmp     1f
1:
                //
                // Disable the ACRs.
                //
                moveq.l #0,%d0
                movec.l %d0,%acr0
                movec.l %d0,%acr1
                //
                // Setup VBR.
                //
                move.l  #vector_table,%d0               // VBR setting -- see MCF5200 PRM Section 5, "Supervisor (privileged) instructions"
                movec.l %d0,%vbr
                //
                // Initialize stack pointer.
                //
                lea.l   kernel_stack,%sp
#if defined(PLATFORM_DBUG)
#define ISRAM_ADDRESS 0x80000000
#define ISRAM_SIZE    0x8000
                //
                // Enable Internal SRAM @ 0x80000000.
                // 6.2.1 SRAM Base Address Register (RAMBAR)
                //
                move.l  #(ISRAM_ADDRESS+0x221),%d0      // BDE (BackDoor Enable) + Valid
                movec.l %d0,#0xC05
                //
                // Clear internal SRAM (6.3.1 SRAM Initialization Code).
                //
                lea.l   ISRAM_ADDRESS,%a0               // load pointer to SRAM
                move.l  #(ISRAM_SIZE/4),%d0             // load loop counter into D0 (SRAM size/4)
1:              clr.l   (%a0)+                          // clear 4 bytes of SRAM
                clr.l   (%a0)+                          // clear 4 bytes of SRAM
                clr.l   (%a0)+                          // clear 4 bytes of SRAM
                clr.l   (%a0)+                          // clear 4 bytes of SRAM
                subq.l  #4,%d0                          // decrement loop counter
                bne.b   1b                              // if done, then exit, else continue looping
#endif
#if !defined(PLATFORM_DBUG)
                //
                // Enter LIMP mode, program the PLL, and return back
                // to normal "PLL drives internal clocks".
                //
                // Peripheral bus clock frequency is fsys/3.
                // Warning! invalida il contenuto della SDRAM!
                // Questo molto probabilmente succede perchè:
                // 1) viene in qualche modo variata la frequenza durante questo
                //    processo, il che provoca una desincronizzazione dei cicli
                //    di refresh e una conseguente perdita del contenuto della
                //    memoria
                // 2) non si può effettuare 2 volte questo processo, se
                //    eventualemente è già stato effettuato dallo script BDM
                //    (e se è valida la considerazione 1), questo processo può
                //    essere effettuato solo se non si fa il download diretto
                //    in SDRAM, che ne auto-distruggerebbe il contenuto)
                //
                move.w  #0x10F1,%d0                     // enable LIMP mode
                move.w  %d0,MISCCR
                move.b  #0x26,%d0                       // 7.2.1 must be fixed at 0x26
                move.b  %d0,MCF_CLOCK_PODR
                move.b  #CLOCK_MULTIPLIER,%d0
                move.b  %d0,MCF_CLOCK_PFDR
                move.b  #0,%d0
                move.b  %d0,MCF_CLOCK_PCR
                move.w  #0x00F1,%d0                     // exit from LIMP mode
                move.w  %d0,MISCCR
1:              move.w  MISCCR,%d0                      // wait for PLL lock
                andi.l  #0x2000,%d0
                beq.b   1b
                nop
                nop
                nop
                nop
#endif
#if !defined(PLATFORM_DBUG)
                //
                // SDRAM programming.
                // port size = 16
                //
                // __FIX__ see also ZOOM-sdram.cfg
                //
                move.l  #(SDRAM_ADDRESS+SDCS0_SIZE32M),%d0
                move.l  %d0,MCF_SDRAMC_SDCS0
                move.l  #0x53722730,%d0
                move.l  %d0,MCF_SDRAMC_SDCFG1
                move.l  #0x56670000,%d0
                move.l  %d0,MCF_SDRAMC_SDCFG2
                // issue PALL command
                move.l  #0xC0090002,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                // generate an LMR command with SD_A[11:0] = 0
                move.l  #0x00010000,%d0
                move.l  %d0,MCF_SDRAMC_SDMR
                // generate an LMR command with SD_A[11:0] = 0x22
                move.l  #0x00890000,%d0
                move.l  %d0,MCF_SDRAMC_SDMR
                // issue PALL command
                move.l  #0xC0090002,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                // issue two refresh cycles
                move.l  #0xC0090004,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                move.l  #0xC0090004,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                // generate an LMR command with SD_A[11:0] = 0x22
                move.l  #0x00890000,%d0
                move.l  %d0,MCF_SDRAMC_SDMR
                move.l  #0x50090C00,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
#endif
                //
                // setup A6 dummy stackframe
                //
                movea.l #0,%a6
                link    %a6,#0
                //
                // setup A5
                //lea    _SDA_BASE,%a5

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                jsr     adainit

                //
                // Jump to high-level code.
                //
                //.extern start_kernel
                //jsr     start_kernel
                .extern _ada_main
                jsr     _ada_main

dead:           jmp     .

                .size   _start,.-_start

delay:
                move.l  #1000000,%d0
1:              subq.l  #1,%d0
                bne.b   1b
                rts

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

