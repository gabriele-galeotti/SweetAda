
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <armv4.h>

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                //
                // CPU is in supervisor mode.
                // CPSR defaults to IRQ&FIRQ disabled.
                // CPU modes setup: enter each mode one at the time, setting
                // stack and IRQ/FIRQ flags.
                //
                mrs     r0,cpsr
                bic     r0,r0,#Mode_MASK
                orr     r1,r0,#Mode_FIQ
                msr     cpsr,r1
                ldr     sp,=FIQ_stack
                orr     r1,r0,#Mode_IRQ
                msr     cpsr,r1
                ldr     sp,=IRQ_stack
                orr     r1,r0,#Mode_ABT
                msr     cpsr,r1
                ldr     sp,=ABT_stack
                orr     r1,r0,#Mode_UND
                msr     cpsr,r1
                ldr     sp,=UND_stack
                orr     r1,r0,#Mode_SVC
                msr     cpsr,r1
                ldr     sp,=SVC_stack

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                ldr     r1,=_sbss
                ldr     r2,=_ebss
                mov     r0,#0
                b       2f
1:              str     r0,[r1],#4
2:              cmp     r1,r2
                blt     1b

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

movdata:
                // registers used: r0-r3
                .extern _etext
                .extern _sdata
                .extern _edata
                ldr     r1,=_etext
                ldr     r2,=_sdata
                ldr     r3,=_edata
                b       2f
1:              ldr     r0,[r1],#4
                str     r0,[r2],#4
2:              cmp     r2,r3
                blt     1b
                mov     pc,lr

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
FIQ_stack:
                .align  8
                .space  1024
IRQ_stack:
                .align  8
                .space  1024
ABT_stack:
                .align  8
                .space  1024
UND_stack:
                .align  8
                .space  2048
SVC_stack:
                .align  8
                .space  4096
USR_stack:

