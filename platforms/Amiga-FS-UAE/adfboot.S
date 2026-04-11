
//
// adfboot.S
//
// Copyright (C) 2020-2026 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <amiga.h>

//
// Environment variables:
// LOADADDRESS is the starting address of the binary executable
// NSECTORS is the number of sectors to load
// ENTRYPOINT is the the target address of the binary executable
//

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global _start
_start:

                .ascii  "DOS"
                .byte   0                       // flags
                .long   0                       // bytes 4..7, checksum (filled in by adfcreate.py)
                .long   880                     // rootblock

                // offset 0x12

                // a1 points to a struct IOStdReq
                move.w  #CMD_READ,IO_COMMAND(%a1)
                // address of data
                move.l  #LOADADDRESS,IO_DATA(%a1)
                // amount of data
                move.l  #(NSECTORS*512),IO_LENGTH(%a1)
                // offset of data start (sector 2)
                move.l  #(2*512),IO_OFFSET(%a1)
                jsr     _LVODoIO(%a6)
                // turn on supervisor mode
                lea.l   supervisor(%pc),%a5
                move.l  ExecBase,%a6
                jsr     _LVOSupervisor(%a6)
                // jump to payload
supervisor:     move.w  #0x2700,%sr
                move.l  #ENTRYPOINT,%a0
                jmp     (%a0)

                .space  1024-(.-_start)

