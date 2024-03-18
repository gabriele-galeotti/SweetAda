
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>
#include <m68k.h>

////////////////////////////////////////////////////////////////////////////////

                // macros for calling code without using the stack (which will
                // be trashed by the memory wipeout performed by zerobss)

                .macro  fjsr address
                lea.l   1f,%a6
                jmp     \address
1:              // next instruction
                .endm

                .macro  frts
                jmp     %a6@
                .endm

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

#define INITIALSP 0x11114EF9                            // 1111 = 256k ROM, 4EF9 = jmp
#define INITIALPC _start
#include "startup-vectors.h"

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                //
                // Kickstart header @ 0x00FC0000.
                //
                // The execution thread is now in ROM space because the reset
                // vector specified @ 0x4 (aliased) contains an high-address
                // program counter.
                //

                .type   _start,@function
                .global _start
_start:

                //
                // M68040 USER''S MANUAL
                // 3.1.3 Transparent Translation Registers
                // __REF__ acroread /a "page=54" "M68040UM.pdf"
                //
                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts
                clr.l   %d0
#if defined(__mc68020__) || defined(__mc68030__) || defined(__mc68040__)
                movec   %d0,%sfc
                movec   %d0,%dfc
                movec   %d0,%cacr
#if !defined(__mc68020__) && !defined(__mc68030__)
                movec   %d0,%tcr
                movec   %d0,%itt0
                movec   %d0,%itt1
                movec   %d0,%dtt0
                movec   %d0,%dtt1
#endif
#endif

#define CIAA_PRA  0x00BFE001 // Port A
#define CIAA_DDRA 0x00BFE201 // Data Direction Port A
                move.b  #0x3,CIAA_DDRA                  // CIAA: LED, OVL signals are outputs
                move.b  #0x2,CIAA_PRA                   // CIAA: PWR LED on, disable aliased ROM and make RAM appears @ 0x00000000

#if (CODE_RAM == 1)
                //
                // Code relocation.
                //
                //fjsr    movcode
#endif

                //
                // Static data relocation.
                //
                //fjsr    movdata

                //
                // Setup stack pointers (ISP and/or MSP).
                //
                // The active supervisor stack pointer out of reset is ISP.
                // Load ISP, then select and load MSP.
                //
                lea.l   isp_stack,%sp                   // load Interrupt SSP
//#if !defined(__mc68060__)
//                ori.w   #MBIT,%sr                       // select MSP
//                lea.l   msp_stack,%sp                   // load Master SSP
//#endif

                //
                // Setup frame pointer.
                //
                move.l  #0,%fp

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                move.l  #_sbss,%a0
                move.l  #_ebss,%a1
                bra.s   2f
1:              clr.b   %a0@+
2:              cmp.l   %a0,%a1
                bne.s   1b

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jsr     _ada_main

dead:           jmp     .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////
// movcode                                                                    //
//                                                                            //
// A6 = return address                                                        //
////////////////////////////////////////////////////////////////////////////////

#if 0
movcode:
                .extern _text_start
                .extern _stext
                .extern _etext
                move.l  #_text_start,%a0
                move.l  #_stext,%a1
                move.l  #_etext,%a2
1:              cmp.l   %a1,%a2
                beq.s   2f
                move.b  %a0@+,%a1@+
                bra.s   1b
2:              frts
#endif

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// A6 = return address                                                        //
////////////////////////////////////////////////////////////////////////////////

#if 0
movdata:
                .extern _data_start
                .extern _sdata
                .extern _edata
                move.l  #_data_start,%a0
                move.l  #_sdata,%a1
                move.l  #_edata,%a2
                cmp.l   %a0,%a1
                beq.s   2f
1:              cmp.l   %a1,%a2
                beq.s   2f
                move.b  %a0@+,%a1@+
                bra.s   1b
2:              frts
#endif

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
isp_stack:

//#if !defined(__mc68060__)
//                .align  8
//                .space  1024
//msp_stack:
//#endif

