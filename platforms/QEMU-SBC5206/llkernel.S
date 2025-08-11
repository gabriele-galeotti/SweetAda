
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <m68k.h>

////////////////////////////////////////////////////////////////////////////////

                .macro SAVE_REGISTERS
                lea     %sp@(-16),%sp           // space for 4 registers
                movem.l %d0-%d1/%a0-%a1,%sp@
                .endm

                .macro RESTORE_REGISTERS
                movem.l %sp@,%d0-%d1/%a0-%a1
                lea     %sp@(16),%sp            // space for 4 registers
                .endm

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                //.p2align 20

                .extern _start

                .global vector_table
vector_table:
                                                // #   offset
initialsp:      .long   0                       // 000 0x0000 -
initialpc:      .long   _start                  // 001 0x0004 -
accesserr:      .long   VH_accesserr            // 002 0x0008 -
addresserr:     .long   VH_addresserr           // 003 0x000C -
illinstr:       .long   VH_illinstr             // 004 0x0010 -
div0:           .long   VH_div0                 // 005 0x0014 -
reserved1:      .long   VH_default              // 006 0x0018 -
reserved2:      .long   VH_default              // 007 0x001C -
privilegev:     .long   VH_privilegev           // 008 0x0020 -
trace:          .long   VH_trace                // 009 0x0024 -
lineA:          .long   VH_lineA                // 010 0x0028 -
lineF:          .long   VH_lineF                // 011 0x002C -
debugint:       .long   VH_debugint             // 012 0x0030 -
reserved3:      .long   VH_default              // 013 0x0034 -
formaterr:      .long   VH_formaterr            // 014 0x0038 -
reserved4:      .long   VH_default              // 015 0x003C -
reserved5:      .long   VH_default              // 016 0x0040 -
reserved6:      .long   VH_default              // 017 0x0044 -
reserved7:      .long   VH_default              // 018 0x0048 -
reserved8:      .long   VH_default              // 019 0x004C -
reserved9:      .long   VH_default              // 020 0x0050 -
reserved10:     .long   VH_default              // 021 0x0054 -
reserved11:     .long   VH_default              // 022 0x0058 -
reserved12:     .long   VH_default              // 023 0x005C -
spuriousint:    .long   VH_spuriousint          // 024 0x0060 -
level1auto:     .long   VH_level1auto           // 025 0x0064 -
level2auto:     .long   VH_level2auto           // 026 0x0068 -
level3auto:     .long   VH_level3auto           // 027 0x006C -
level4auto:     .long   VH_level4auto           // 028 0x0070 -
level5auto:     .long   VH_level5auto           // 029 0x0074 -
level6auto:     .long   VH_level6auto           // 030 0x0078 -
level7auto:     .long   VH_level7auto           // 031 0x007C -
trap0:          .long   VH_trap0                // 032 0x0080 -
trap1:          .long   VH_trap1                // 033 0x0084 -
trap2:          .long   VH_trap2                // 034 0x0088 -
trap3:          .long   VH_trap3                // 035 0x008C -
trap4:          .long   VH_trap4                // 036 0x0090 -
trap5:          .long   VH_trap5                // 037 0x0094 -
trap6:          .long   VH_trap6                // 038 0x0098 -
trap7:          .long   VH_trap7                // 039 0x009C -
trap8:          .long   VH_trap8                // 040 0x00A0 -
trap9:          .long   VH_trap9                // 041 0x00A4 -
trap10:         .long   VH_trap10               // 042 0x00A8 -
trap11:         .long   VH_trap11               // 043 0x00AC -
trap12:         .long   VH_trap12               // 044 0x00B0 -
trap13:         .long   VH_trap13               // 045 0x00B4 -
trap14:         .long   VH_trap14               // 046 0x00B8 -
trap15:         .long   VH_trap15               // 047 0x00BC -
reserved20:     .long   VH_default              // 048 0x00C0 -
reserved21:     .long   VH_default              // 049 0x00C4 -
reserved22:     .long   VH_default              // 050 0x00C8 -
reserved23:     .long   VH_default              // 051 0x00CC -
reserved24:     .long   VH_default              // 052 0x00D0 -
reserved25:     .long   VH_default              // 053 0x00D4 -
reserved26:     .long   VH_default              // 054 0x00D8 -
reserved27:     .long   VH_default              // 055 0x00DC -
reserved28:     .long   VH_default              // 056 0x00E0 -
reserved29:     .long   VH_default              // 057 0x00E4 -
reserved30:     .long   VH_default              // 058 0x00E8 -
reserved31:     .long   VH_default              // 059 0x00EC -
reserved32:     .long   VH_default              // 060 0x00F0 -
reserved33:     .long   VH_default              // 061 0x00F4 -
reserved34:     .long   VH_default              // 062 0x00F8 -
reserved35:     .long   VH_default              // 063 0x00FC -

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .extern exception_process
                .extern irq_process

VH_accesserr:
VH_addresserr:
VH_illinstr:
VH_div0:
VH_privilegev:
VH_trace:
VH_lineA:
VH_lineF:
VH_debugint:
VH_formaterr:
VH_spuriousint:
VH_trap0:
VH_trap1:
VH_trap2:
VH_trap3:
VH_trap4:
VH_trap5:
VH_trap6:
VH_trap7:
VH_trap8:
VH_trap9:
VH_trap10:
VH_trap11:
VH_trap12:
VH_trap13:
VH_trap14:
VH_trap15:
                jmp     exception_process

VH_level1auto:
VH_level2auto:
VH_level3auto:
VH_level4auto:
VH_level5auto:
VH_level6auto:
VH_level7auto:
                SAVE_REGISTERS
                jsr     irq_process
                RESTORE_REGISTERS
                rte

VH_default:
                jmp     .

