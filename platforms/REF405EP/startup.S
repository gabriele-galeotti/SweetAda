
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <ppc405ep.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .ppc405reset,"ax"

                //
                // Reset entry point.
                // __REF__ acroread /a "page=190" "PPC405EP_UM2003.pdf"
                //

                b       _start

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                //
                // __REF__ acroread /a "page=190" "PPC405EP_UM2003.pdf"
                //

                .type   _start,@function
                .global _start
_start:

                //
                // Initial setup.
                //
                li      r4,0
                mtspr   SGR,r4
                mtspr   DCWR,r4
                mtesr   r4                              // clear Exception Syndrome Register
                mttcr   r4                              // clear Timer Control Register
                mtxer   r4                              // clear Fixed-Point Exception Register
                mtevpr  r4                              // clear Exception Vector Prefix Register
                li      r4,0x1000                       // set ME bit (Machine Exceptions)
                oris    r4,r4,0x0002                    // set CE bit (Critical Exceptions)
                mtmsr   r4                              // change MSR
                li      r4,0xFFFFFFFF                   // set r4 to 0xFFFFFFFF (status in the dbsr is cleared by setting bits to 1)
                mtdbsr  r4                              // clear/reset DBSR

                //
                // MSR setup.
                //
                // disable instruction and data address translation
                // __REF__ acroread /a "page=119" "PPC405EP_UM2003.pdf"
                // __REF__ acroread /a "page=123" "PPC405EP_UM2003.pdf"
                mfmsr   r0
                lis     r1,(IR|DR)@ha
                ori     r1,r1,(IR|DR)@l
                not     r1,r1
                and     r0,r0,r1
                mtmsr   r0
                // enforce "guarded" storage and big-endian ordering
                // __REF__ acroread /a "page=160" "PPC405EP_UM2003.pdf"
                lis     r0,0xFFFFFFFF@ha
                ori     r0,r0,0xFFFFFFFF@l
                mtspr   SGR,r0
                lis     r0,0@ha
                ori     r0,r0,0@l
                mtspr   SLER,r0
                // Instruction Cache Cachability Register (ICCR)
                iccci                                   // invalidate
                lis     r0,0@ha
                ori     r0,r0,0@l
                mtspr   ICCR,r0
                isync
                // Data Cache Cachability Register (DCCR)
                // __REF__ acroread /a "page=123" "PPC405EP_UM2003.pdf"
                dccci                                   // invalidate
                lis     r0,0@ha
                ori     r0,r0,0@l
                mtspr   DCCR,r0
                isync

                //
                // Initialize EVPR.
                // PowerPC 405 Embedded Processor Core User?s Manual
                // 5.4 Critical and Noncritical Interrupts
                //
                .extern ivtable
                lis     r0,ivtable@ha                   // lower 15 bits of EVPR are always 0
                ori     r0,r0,ivtable@l
                mtspr   EVPR,r0

#include "pll.h"
#include "sdram.h"

                //
                // Timer facilities.
                //
                // clear PIT so no PIT indication after TSR cleared
                lis     r0,0@ha
                ori     r0,r0,0@l
                mtspr   PIT,r0
                // clear TSR
                lis     r0,0xFFFFFFFF@ha
                ori     r0,r0,0xFFFFFFFF@l
                mtspr   TSR,r0
                // reset time base low first to avoid ripple
                lis     r0,0@ha
                ori     r0,r0,0@l
                mtspr   TBL,r0
                // set time base, hi first to catch possible ripple
                mtspr   TBU,r0
                // set time base, low
                mtspr   TBL,r0

                //
                // Code relocation.
                //
                bl      movcode

                //
                // Static data relocation.
                //
                bl      movdata

                //
                // Initialize .bss section.
                //
                bl      zerobss

                //
                // Setup stack pointer.
                //
                lis     r1,kernel_stack@ha
                ori     r1,r1,kernel_stack@l
                //li      r14,0
                //stw     r14,0(r1)
                //stwu    r1,-8(r1)

                //
                // EABI setup.
                //
                .extern _sdata
                .extern _sdata2
                lis     r13,_sdata@ha
                ori     r13,r13,_sdata@l
                lis     r2,_sdata2@ha
                ori     r2,r2,_sdata2@l

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////
// movcode                                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

movcode:
                .extern _text_start
                .extern _stext
                .extern _etext
                lis     r28,_text_start@ha
                ori     r28,r28,_text_start@l
                lis     r29,_stext@ha
                ori     r29,r29,_stext@l
                lis     r30,_etext@ha
                ori     r30,r30,_etext@l
                cmplw   cr7,r29,r30
                beq     cr7,3f
                b       2f
1:              mr      r9,r29
                addi    r29,r9,4
                mr      r10,r28
                addi    r28,r10,4
                lwz     r10,0(r10)
                stw     r10,0(r9)
2:              cmplw   cr7,r29,r30
                blt     cr7,1b
3:              blr

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

movdata:
                .extern _data_start
                .extern _sdata
                .extern _edata
                lis     r28,_data_start@ha
                ori     r28,r28,_data_start@l
                lis     r29,_sdata@ha
                ori     r29,r29,_sdata@l
                lis     r30,_edata@ha
                ori     r30,r30,_edata@l
                cmplw   cr7,r29,r30
                beq     cr7,3f
                b       2f
1:              mr      r9,r29
                addi    r29,r9,4
                mr      r10,r28
                addi    r28,r10,4
                lwz     r10,0(r10)
                stw     r10,0(r9)
2:              cmplw   cr7,r29,r30
                blt     cr7,1b
3:              blr

////////////////////////////////////////////////////////////////////////////////
// zerobss                                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

zerobss:
                .extern _sbss
                .extern _ebss
                lis     r29,_sbss@ha
                ori     r29,r29,_sbss@l
                lis     r30,_ebss@ha
                ori     r30,r30,_ebss@l
                cmplw   cr7,r29,r30
                addi    r29,r29,-1
                addi    r30,r30,-1
                subf    r30,r29,r30
                li      r28,0
                mtctr   r30
                bgelr   cr7
1:              stbu    r28,1(r29)
                bdnz    1b
                blr

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  3                               // EABI requires 8-byte (2^3) aligned stack
                .space  4096
kernel_stack:

