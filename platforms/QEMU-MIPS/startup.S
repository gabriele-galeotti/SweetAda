
//
// startup.S - MIPS R4300 startup (QEMU emulator).
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>
#include <llutils.h>

RAM_BASE   = 0xA0000000
RAM_SIZE   = 0x00400000
STACK_INIT = RAM_BASE+RAM_SIZE-4

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global reset_exception
reset_exception:
                .set noreorder
                nop
                j       _start                          // RESET entry point
                move    $k0,$0
                j       _start                          // Why are we doing this?
                move    $k0,$0

//
// Exception Vectors.
//

                .align  9                               // BFC00200: R4000 tlbmiss
                .extern tlb_miss
                j       tlb_miss
                nop

                .align  7                               // BFC00280: R4000 xtlbmiss
                .extern x_tlb_miss
                j       x_tlb_miss
                nop

                .align  7                               // BFC00300: R4000 cache error
                .extern cache_err
                j       cache_err
                nop

                .align  7                               // BFC00380: R4000 general
                .extern gen_exc
                j       gen_exc
                nop

                .set    at

#if 0
                .align  10                              // BFC00400: ITPROM boot package table
                .org    0x500                           // BFC00500: YAMON API table
                .word   _start
                .word   print_count
                .org    0x520
                .word   _start
                .org    0x52C
                .word   flush_cache
                .org    0x534
                .word   print
                .org    0x538
                .word   reg_cpu_isr
                .word   unred_cpu_isr
                .word   reg_ic_isr
                .word   unred_ic_isr
                .word   reg_esr
                .word   unreg_esr
                .org    0x550
                .word   getchar
                .org    0x554
                .word   syscon_read
#endif

                .org    0x580

                .global _start
_start:

                //
                // Set up status and cause registers
                //
                mfc0    $t0,CP0_PRId
                mfc0    $v0,CP0_SR
                mtc0    $0,CP0_WatchLo
                mtc0    $0,CP0_WatchHi
                and     $v0,SR_SR                       // preserve Soft Reset
                or      $v0,SR_BEV                      // set Boot Exceptions
                mtc0    $v0,CP0_SR                      // 32 bit, kernel mode, bootstrap
                mtc0    $0,CP0_Cause
                nop

                //
                // Set up stack.
                //
                la      $sp,STACK_INIT

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                la      $t0,adainit
                jalr    $t0
                nop

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                la      $t0,_ada_main
                jalr    $t0
                nop

dead:           b       .
                nop

