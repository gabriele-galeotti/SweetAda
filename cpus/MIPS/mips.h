
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

#define CP0_Index    $0         // TLB entry index register
#define CP0_Random   $1
#define CP0_EntryLo  $2         // TLB entry contents (low-order half)
#define CP0_EntryLo0 $2         // TLB entry contents (low-order half) 0
#define CP0_EntryLo1 $3         // TLB entry contents (low-order half) 1
#define CP0_Context  $4
#define CP0_PageMask $5
#define CP0_Wired    $6
#define CP0_BadVAddr $8
#define CP0_Count    $9
#define CP0_EntryHi  $10        // TLB entry contents (high-order half)
#define CP0_Compare  $11
#define CP0_SR       $12
#define CP0_Cause    $13
#define CP0_EPC      $14
#define CP0_PRId     $15        // Processor Revision Indentifier
#define CP0_Config   $16
#define CP0_Config1  $16,1
#define CP0_Config2  $16,2
#define CP0_Config3  $16,3
#define CP0_WatchLo  $18        // WatchpointLo
#define CP0_WatchHi  $19        // WatchpointHi
#define CP0_XContext $20        // XContext
#define CP0_Debug    $23

#define SR_SR  0x00100000       // Soft Reset
#define SR_BEV 0x00400000       // Bootstrap Exception Vector

#endif /* _MIPS_H */

