
/*
 * e300.h - PowerPC e300 architecture definitions.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _E300_H
#define _E300_H 1

#define r0 %r0
#define r1 %r1
#define r2 %r2
#define r3 %r3
#define r4 %r4
#define r5 %r5
#define r9 %r9
#define r13 %r13

#define MSR_DR 0x00000010
#define MSR_IR 0x00000020
#define MSR_IP 0x00000040

#define IBAT0U 0x210    /* Instruction BAT 0 Upper Register */
#define IBAT0L 0x211    /* Instruction BAT 0 Lower Register */
#define IBAT1U 0x212    /* Instruction BAT 1 Upper Register */
#define IBAT1L 0x213    /* Instruction BAT 1 Lower Register */
#define IBAT2U 0x214    /* Instruction BAT 2 Upper Register */
#define IBAT2L 0x215    /* Instruction BAT 2 Lower Register */
#define IBAT3U 0x216    /* Instruction BAT 3 Upper Register */
#define IBAT3L 0x217    /* Instruction BAT 3 Lower Register */
#define IBAT4U 0x230    /* Instruction BAT 4 Upper Register */
#define IBAT4L 0x231    /* Instruction BAT 4 Lower Register */
#define IBAT5U 0x232    /* Instruction BAT 5 Upper Register */
#define IBAT5L 0x233    /* Instruction BAT 5 Lower Register */
#define IBAT6U 0x234    /* Instruction BAT 6 Upper Register */
#define IBAT6L 0x235    /* Instruction BAT 6 Lower Register */
#define IBAT7U 0x236    /* Instruction BAT 7 Upper Register */
#define IBAT7L 0x237    /* Instruction BAT 7 Lower Register */
#define DBAT0U 0x218    /* Data BAT 0 Upper Register */
#define DBAT0L 0x219    /* Data BAT 0 Lower Register */
#define DBAT1U 0x21A    /* Data BAT 1 Upper Register */
#define DBAT1L 0x21B    /* Data BAT 1 Lower Register */
#define DBAT2U 0x21C    /* Data BAT 2 Upper Register */
#define DBAT2L 0x21D    /* Data BAT 2 Lower Register */
#define DBAT3U 0x21E    /* Data BAT 3 Upper Register */
#define DBAT3L 0x21F    /* Data BAT 3 Lower Register */
#define DBAT4U 0x238    /* Data BAT 4 Upper Register */
#define DBAT4L 0x239    /* Data BAT 4 Lower Register */
#define DBAT5U 0x23A    /* Data BAT 5 Upper Register */
#define DBAT5L 0x23B    /* Data BAT 5 Lower Register */
#define DBAT6U 0x23C    /* Data BAT 6 Upper Register */
#define DBAT6L 0x23D    /* Data BAT 6 Lower Register */
#define DBAT7U 0x23E    /* Data BAT 7 Lower Register */
#define DBAT7L 0x23F    /* Data BAT 7 Lower Register */

#define BATL_PP_10            0x00000002        /* read-write */
#define BATL_GUARDEDSTORAGE   0x00000008
#define BATL_MEMCOHERENCE     0x00000010
#define BATL_CACHEINHIBIT     0x00000020
#define BATU_BL_1M            0x0000001C
#define BATU_BL_2M            0x0000003C
#define BATU_BL_16M           0x000001FC
#define BATU_BL_128M          0x00000FFC
#define BATU_BL_256M          0x00001FFC
#define BATU_VP               0x00000001
#define BATU_VS               0x00000002

#define HID0 0x03F0
#define  DCFI  0x00000400
#define  ICFI  0x00000800
#define  DLOCK 0x00001000
#define  ILOCK 0x00002000
#define  DCE   0x00004000
#define  ICE   0x00008000
#define HID2 0x03F3
#define  HBE 0x00040000

#endif /* _E300_H */

