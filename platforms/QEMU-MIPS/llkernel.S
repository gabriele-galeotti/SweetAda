
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
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

#define REGSAREA_SIZE 76*X2

#define SAVE_REGS                                \
                SAVEREG $at,( 0*X2)($sp)        ;\
                SAVEREG $v0,( 4*X2)($sp)        ;\
                SAVEREG $v1,( 8*X2)($sp)        ;\
                SAVEREG $a0,(12*X2)($sp)        ;\
                SAVEREG $a1,(16*X2)($sp)        ;\
                SAVEREG $a2,(20*X2)($sp)        ;\
                SAVEREG $a3,(24*X2)($sp)        ;\
                SAVEREG $t0,(28*X2)($sp)        ;\
                SAVEREG $t1,(32*X2)($sp)        ;\
                SAVEREG $t2,(36*X2)($sp)        ;\
                SAVEREG $t3,(40*X2)($sp)        ;\
                SAVEREG $t4,(44*X2)($sp)        ;\
                SAVEREG $t5,(48*X2)($sp)        ;\
                SAVEREG $t6,(52*X2)($sp)        ;\
                SAVEREG $t7,(56*X2)($sp)        ;\
                SAVEREG $t8,(60*X2)($sp)        ;\
                SAVEREG $t9,(64*X2)($sp)        ;\
                SAVEREG $gp,(68*X2)($sp)        ;\
                SAVEREG $ra,(72*X2)($sp)

#define RESTORE_REGS                             \
                LOADREG $at,( 0*X2)($sp)        ;\
                LOADREG $v0,( 4*X2)($sp)        ;\
                LOADREG $v1,( 8*X2)($sp)        ;\
                LOADREG $a0,(12*X2)($sp)        ;\
                LOADREG $a1,(16*X2)($sp)        ;\
                LOADREG $a2,(20*X2)($sp)        ;\
                LOADREG $a3,(24*X2)($sp)        ;\
                LOADREG $t0,(28*X2)($sp)        ;\
                LOADREG $t1,(32*X2)($sp)        ;\
                LOADREG $t2,(36*X2)($sp)        ;\
                LOADREG $t3,(40*X2)($sp)        ;\
                LOADREG $t4,(44*X2)($sp)        ;\
                LOADREG $t5,(48*X2)($sp)        ;\
                LOADREG $t6,(52*X2)($sp)        ;\
                LOADREG $t7,(56*X2)($sp)        ;\
                LOADREG $t8,(60*X2)($sp)        ;\
                LOADREG $t9,(64*X2)($sp)        ;\
                LOADREG $gp,(68*X2)($sp)        ;\
                LOADREG $ra,(72*X2)($sp)

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
                subu    $sp,$sp,REGSAREA_SIZE
                SAVE_REGS
                .extern exception_process
                la      $t0,exception_process
                jalr    $t0
                nop
                RESTORE_REGS
                addu    $sp,$sp,REGSAREA_SIZE
                mtc0    $0,CP0_CAUSE
                eret

