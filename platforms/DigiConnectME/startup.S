
//
// startup.S - Digi Connect ME NS7520 startup.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .sect   .startup,"ax"

                .type   _start,%function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                ldr     r0,=SVC_stack
                mov     sp,r0

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
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movdata:
                // registers used: r0-r3
                .extern _etext
                .extern _sdata
                .extern _edata
                ldr     r1,=_etext
                ldr     r2,=_sdata
                ldr     r3,=_edata
                cmp     r2,r3
                movcs   pc,lr
1:              ldr     r0,[r1],#4
                str     r0,[r2],#4
                cmp     r2,r3
                blt     1b
                mov     pc,lr

////////////////////////////////////////////////////////////////////////////////
// zerobss                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

zerobss:
                // registers used: r0-r2
                .extern _sbss
                .extern _ebss
                ldr     r1,=_sbss
                ldr     r2,=_ebss
                cmp     r1,r2
                movcs   pc,lr
                ldr     r0,=0
1:              str     r0,[r1],#4
                cmp     r1,r2
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

