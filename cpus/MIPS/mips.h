
/*
 * mips.h - MIPS architecture definitions.
 *
 * Copyright (C) 2020-2023 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _MIPS_H
#define _MIPS_H 1

#define C0_INDEX    $0          // TLB entry index register
#define C0_RANDOM   $1
#define C0_ENTRYLO  $2          // TLB entry contents (low-order half)
#define C0_ENTRYLO0 $2          // TLB entry contents (low-order half) 0
#define C0_ENTRYLO1 $3          // TLB entry contents (low-order half) 1
#define C0_CONTEXT  $4
#define C0_PAGEMASK $5
#define C0_WIRED    $6
#define C0_BADVADDR $8
#define C0_COUNT    $9
#define C0_ENTRYHI  $10         // TLB entry contents (high-order half)
#define C0_COMPARE  $11
#define C0_SR       $12
#define C0_CAUSE    $13
#define C0_EPC      $14
#define C0_PRID     $15         // Processor Revision Indentifier
#define C0_CONFIG   $16
#define C0_CONFIG1  $16,1
#define C0_CONFIG2  $16,2
#define C0_CONFIG3  $16,3
#define C0_WATCHLO  $18         // WatchpointLo
#define C0_WATCHHI  $19         // WatchpointHi
#define C0_XCONTEXT $20
#define C0_DEBUG    $23

#define SR_SR  0x00100000       // Soft Reset
#define SR_BEV 0x00400000       // Bootstrap Exception Vector

#endif /* _MIPS_H */

