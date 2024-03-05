
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

#if __mips64 == 1
# define SAVEREG sd
# define LOADREG ld
# define X2 2
#else
# define SAVEREG sw
# define LOADREG lw
# define X2 1
#endif

#define SAVE_REGS                                \
                SAVEREG $at,( 0*X2)($k1)        ;\
                SAVEREG $v0,( 4*X2)($k1)        ;\
                SAVEREG $v1,( 8*X2)($k1)        ;\
                SAVEREG $a0,(12*X2)($k1)        ;\
                SAVEREG $a1,(16*X2)($k1)        ;\
                SAVEREG $a2,(20*X2)($k1)        ;\
                SAVEREG $a3,(24*X2)($k1)        ;\
                SAVEREG $t0,(28*X2)($k1)        ;\
                SAVEREG $t1,(32*X2)($k1)        ;\
                SAVEREG $t2,(36*X2)($k1)        ;\
                SAVEREG $t3,(40*X2)($k1)        ;\
                SAVEREG $t4,(44*X2)($k1)        ;\
                SAVEREG $t5,(48*X2)($k1)        ;\
                SAVEREG $t6,(52*X2)($k1)        ;\
                SAVEREG $t7,(56*X2)($k1)        ;\
                SAVEREG $t8,(60*X2)($k1)        ;\
                SAVEREG $t9,(64*X2)($k1)        ;\
                SAVEREG $gp,(68*X2)($k1)        ;\
                SAVEREG $sp,(72*X2)($k1)        ;\
                SAVEREG $ra,(76*X2)($k1)

#define RESTORE_REGS                             \
                LOADREG $at,( 0*X2)($k1)        ;\
                LOADREG $v0,( 4*X2)($k1)        ;\
                LOADREG $v1,( 8*X2)($k1)        ;\
                LOADREG $a0,(12*X2)($k1)        ;\
                LOADREG $a1,(16*X2)($k1)        ;\
                LOADREG $a2,(20*X2)($k1)        ;\
                LOADREG $a3,(24*X2)($k1)        ;\
                LOADREG $t0,(28*X2)($k1)        ;\
                LOADREG $t1,(32*X2)($k1)        ;\
                LOADREG $t2,(36*X2)($k1)        ;\
                LOADREG $t3,(40*X2)($k1)        ;\
                LOADREG $t4,(44*X2)($k1)        ;\
                LOADREG $t5,(48*X2)($k1)        ;\
                LOADREG $t6,(52*X2)($k1)        ;\
                LOADREG $t7,(56*X2)($k1)        ;\
                LOADREG $t8,(60*X2)($k1)        ;\
                LOADREG $t9,(64*X2)($k1)        ;\
                LOADREG $gp,(68*X2)($k1)        ;\
                LOADREG $sp,(72*X2)($k1)        ;\
                LOADREG $ra,(76*X2)($k1)

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .set    noreorder
                .set    noat

//
// Exception Vectors.
//

                //
                // RESET entry point
                //
                .global reset
reset:
                .extern _start
                j       _start
                move    $k0,$0

                //
                // 0xBFC00200: R4000 TLB Miss
                //
                .align  9
                j       tlb_miss
                nop

                //
                // 0xBFC00280: R4000 xTLB Miss
                //
                .align  7
                j       x_tlb_miss
                nop

                //
                // 0xBFC00300: R4000 Cache Error
                //
                .align  7
                j       cache_err
                nop

                //
                // 0xBFC00380: R4000 General Exception
                //
                .align  7
                j       irq_handler
                nop

tlb_miss:
                j       handle_exc
                nop

x_tlb_miss:
                j       handle_exc
                nop

cache_err:
                j       handle_exc
                nop

handle_exc:
                j       .
                nop

irq_handler:
                la      $k1,savearea
                SAVE_REGS
                .extern exception_process
                la      $t0,exception_process
                jalr    $t0
                nop
                RESTORE_REGS
                mtc0    $0,C0_CAUSE
                eret

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .p2align 3
savearea:       .space  80*X2

