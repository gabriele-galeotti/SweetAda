
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2026 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <powerpc.h>
#include <ppc440ep.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:
                b       init

////////////////////////////////////////////////////////////////////////////////

                //
                // Initial setup.
                //
init:
                li      r4,0
                mtspr   SGR,r4                          // clear SGR
                mtspr   DCWR,r4                         // clear DCWR
                mtesr   r4                              // clear Exception Syndrome Register
                mttcr   r4                              // clear Timer Control Register
                mtxer   r4                              // clear Fixed-Point Exception Register
                mtivpr  r4                              // clear Interrupt Vector Prefix Register
                li      r4,0x1000                       // set ME bit (Machine Exceptions)
                oris    r4,r4,0x0002                    // set CE bit (Critical Exceptions)

                //
                // MSR setup.
                //
                // disable instruction and data address translation
                mfmsr   r0
                lis     r1,(MSR_IR|MSR_DR)@ha
                ori     r1,r1,(MSR_IR|MSR_DR)@l
                not     r1,r1
                and     r0,r0,r1
                mtmsr   r0

                //
                // Initialize .bss section.
                //
                bl      zerobss

                //
                // Setup stack pointer.
                //
                lis     r1,kernel_stack@ha
                ori     r1,r1,kernel_stack@l

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
                // Initialize IVPR.
                //
                .extern ivtable
                lis     r0,ivtable@ha                   // lower 15 bits of EVPR are always 0
                ori     r0,r0,ivtable@l
                mtspr   IVPR,r0

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

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

