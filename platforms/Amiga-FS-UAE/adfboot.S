
//
// adfboot.S
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

//
// Environment variables:
// LOADADDRESS is the starting address of the binary executable
// NSECTORS is the number of sectors to load
// ENTRYPOINT is the the target address of the binary executable
//

#define EXECBASE   4
#define SUPERSTATE -150 // 0xFFFFFF6A
#define LVODoIO    -456 // 0xFFFFFE38
#define CMD_READ   2
#define IO_COMMAND 28
#define IO_LENGTH  36
#define IO_DATA    40
#define IO_OFFSET  44

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global _start
_start:

                .ascii  "DOS"
                .byte   0                       // flags
                .long   0                       // bytes 4..7, checksum (filled in by adfcreate.py)
                .long   880                     // rootblock

                // offset 0x12

                move.w  #CMD_READ,IO_COMMAND(%a1)
                // address of data
                move.l  #LOADADDRESS,IO_DATA(%a1)
                // amount of data
                move.l  #(NSECTORS*512),IO_LENGTH(%a1)
                // offset of data start (sector 2)
                move.l  #(2*512),IO_OFFSET(%a1)
                jsr     LVODoIO(%a6)
                // turn on supervisor mode
                move.l  EXECBASE,%a6
                jsr     SUPERSTATE(%a6)
                // entry point
                move.l  #ENTRYPOINT,%a6
                // pass the entry point in A0
                move.l  %a6,%a0
                // jump to payload
                jmp     (%a6)

                .space  1024-(.-_start)

