
/*
 * mips.h - MIPS architecture definitions.
 *
 * Copyright (C) 2020-2025 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _MIPS_H
#define _MIPS_H 1

#define CP0_INDEX    $0         // TLB entry index register
#define CP0_RANDOM   $1
#define CP0_ENTRYLO  $2         // TLB entry contents (low-order half)
#define CP0_ENTRYLO0 $2         // TLB entry contents (low-order half) 0
#define CP0_ENTRYLO1 $3         // TLB entry contents (low-order half) 1
#define CP0_CONTEXT  $4
#define CP0_PAGEMASK $5
#define CP0_WIRED    $6
#define CP0_BADVADDR $8
#define CP0_COUNT    $9
#define CP0_ENTRYHI  $10        // TLB entry contents (high-order half)
#define CP0_COMPARE  $11
#define CP0_SR       $12
#define CP0_CAUSE    $13
#define CP0_EPC      $14
#define CP0_PRID     $15        // Processor Revision Indentifier
#define CP0_CONFIG   $16
#define CP0_CONFIG1  $16,1
#define CP0_CONFIG2  $16,2
#define CP0_CONFIG3  $16,3
#define CP0_WATCHLO  $18        // WatchpointLo
#define CP0_WATCHHI  $19        // WatchpointHi
#define CP0_XCONTEXT $20
#define CP0_DEBUG    $23

#define K0BASE 0x80000000

// R3000 cache control bits
#define SR_IsC (1 << 16)        // isolate (data) cache
#define SR_SwC (1 << 17)        // swap caches
#define SR_CM  (1 << 19)        // cache management
#define SR_PE  (1 << 20)        // cache parity error

#define SR_BEV (1 << 22)        // Bootstrap Exception Vector

#endif /* _MIPS_H */

