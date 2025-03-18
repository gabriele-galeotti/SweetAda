
//
// bootsector.S
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

//
// bootsector CHS mapping = 1,0,1
// bootsector loaded @ 0000:7C00
//
// Environment variables:
// BOOTSEGMENT is the segment target address of the binary
// NSECTORS is the number of sectors to load
//

#define STARTIP   0x7C00
#define OFFSET(x) (STARTIP + (x))

#if defined(FLOPPYDISK)
# define MEDIA_TYPE              0xF0
# define CYLINDERS               80
# define HEADS                   2
# define SPT                     18
# define ROOT_ENTRIES            0x00E0
# define PARTITION_SECTORS_SSIZE 2880
# define PARTITION_SECTOR_START  0
# define PARTITION_SECTORS_LSIZE 0
# define DRIVE_NUMBER            0
# define FAT_NAME                "FAT12   "
#else
# define MEDIA_TYPE              0xF8
# define ROOT_ENTRIES            0x0200
# define DRIVE_NUMBER            0x80
# define FAT_NAME                "FAT16   "
# define EXTENDED                1
#endif

                .sect   .text,"ax"
                .code16

                .global _start
_start:
                //
                // Hardwired MS-DOS header + BPB.
                //
                .byte   0xEB,0x3C,0x90                  // +00  3 hardwired short JMP + NOP (jump @ offset 0x003E)
                .ascii  "MSDOS5.0"                      // +03  8 OEM signature
                // DOS 2.0 BPB
                .word   0x0200                          // +0B  2 sector size: bytes x sector
                .byte   1                               // +0D  1 sectors x cluster (must be a power of 2)
                .word   1                               // +0E  2 reserved sectors (at least 1)
                .byte   2                               // +10  1 number of FATs
                .word   ROOT_ENTRIES                    // +11  2 root entries
                .word   PARTITION_SECTORS_SSIZE         // +13  2 small sectors (if <= 65535)
                .byte   MEDIA_TYPE                      // +15  1 0xF0 = 3.5'' 1.44 MB floppy disk, 0xF8 = hard disk
                .word   0x0009                          // +16  2 sectors per FAT
                // DOS 3.31 BPB
                .word   SPT                             // +18  2 sectors per track
                .word   HEADS                           // +1A  2 number of heads
                .long   PARTITION_SECTOR_START          // +1C  4 hidden sectors
                .long   PARTITION_SECTORS_LSIZE         // +20  4 large sectors (total # of sectors)
                // DOS 4.0 Extended BPB (only FAT12/FAT16/HPFS, no FAT32/NTFS)
                .byte   DRIVE_NUMBER                    // +24  1 physical drive number (0x00 = first floppy disk, 0x80 = first hard disk)
                .byte   0                               // +25  1 flags (current head - for FAT always set to 0)
                .byte   0x29                            // +26  1 extended BPB signature
                .long   0x12345678                      // +27  4 volume serial number
                .ascii  "SweetAda   "                   // +2B 11 "           " volume label
                .ascii  FAT_NAME                        // +36  8 system ID
                // current offset = 0x003E

                clc
                cld
                movw    %cs,%ax                         // SS = DS = CS
                movw    %ax,%ds
                movw    %ax,%ss
                movw    $STARTIP,%sp
                movw    $BOOTSEGMENT,%ax                // ES = BOOTSEGMENT
                movw    %ax,%es
#if defined(EXTENDED)
                movw    OFFSET(0x1C),%ax
                movw    %ax,OFFSET(nsectorslo)
                movw    OFFSET(0x1E),%ax
                movw    %ax,OFFSET(nsectorshi)
                incw    OFFSET(nsectorslo)              // skip this bootsector
                jne     1f
                incw    OFFSET(nsectorshi)
1:
#endif
                movw    $NSECTORS,%si

                //
                // Read loop.
                //
READLOOP:       movw    OFFSET(nsectorslo),%ax
                movw    OFFSET(nsectorshi),%dx
                call    DUMP
#if defined(EXTENDED)
                call    EXTREAD
#else
                call    LS2CHS
                jc      ERROR
                call    CHSREAD
#endif
                jc      ERROR
                decw    %si
                je      BOOT
#if defined(DELAY)
                movl    $0x00100000,%ecx
1:       addr32 loop    1b
#endif
                movw    %es,%ax                         // ES = ES + 0x200 >> 8
                addw    $0x20,%ax
                movw    %ax,%es
                incw    OFFSET(nsectorslo)
                jne     READLOOP
                incw    OFFSET(nsectorshi)
                jmp     READLOOP

                //
                // Convert a logical sector into CHS.
                //
                // input: logical sector = DX:AX
                // input: spt
                // input: heads
                // output: sctnum
                // output: head
                // output: trk
                //
LS2CHS:         cmpw    OFFSET(spt),%dx                 // compare with spt (overflow)
                jnc     1f                              // error
                divw    OFFSET(spt)                     // divisor = spt
                incb    %dl                             // sector number is 1-based, limited to 63
                movb    %dl,OFFSET(sctnum)              // sector #
                xorw    %dx,%dx
                divw    OFFSET(heads)                   // divisor = heads
                movb    %dl,OFFSET(head)                // head #, limited to 254
                movw    %ax,OFFSET(trk)                 // trk #
                clc
                ret
1:              stc
                ret

                //
                // Issue read one sector request.
                // INT 13H AH=02H READ SECTORS FROM DRIVE
                //
                // input: sctnum
                // input: head
                // input: trk
                //
CHSREAD:        movw    OFFSET(trk),%dx
                movb    $0x06,%cl
                shlb    %cl,%dh
                orb     OFFSET(sctnum),%dh
                movw    %dx,%cx
                xchgb   %cl,%ch
                movb    $DRIVE_NUMBER,%dl               // physical drive number
                movb    OFFSET(head),%dh                // current head
                xorw    %bx,%bx
                movb    $0x01,%al
                movb    $0x02,%ah
                int     $0x13
                ret

                //
                // Extended read.
                // LBA sector = DX:AX
                //
EXTREAD:        pusha                                   // push all registers onto stack
                movb    $DRIVE_NUMBER,%dl               // DL = drive number
                movw    $0x55AA,%bx                     // BX must be set to 55AAh
                movb    $0x41,%ah                       // INT 0x13 function 41h "INSTALLATION CHECK"
                int     $0x13                           // "check for INT 0x13 extensions"
                jc      EXTFAIL                         // was operation successful? if not, return (with carry flag set)
                cmpw    $0xAA55,%bx                     // the contents of BX are changed into AA55h if exts installed
                jnz     EXTFAIL                         // are they installed? if not, return (with carry flag set)
                testb   $0x01,%cl                       // function 42h supported?
                jz      EXTFAIL                         // return (with carry flag set)
                popa                                    // pop all registers from stack
                movw    $3,%di                          // 3 retries
EXTRETRY:       pusha                                   // push all registers onto stack
                pushl   $0
                pushw   %dx                             // LBA starting sector MSB bytes
                pushw   %ax                             // LBA starting sector LSB bytes
                pushw   %es                             // transfer buffer segment
                pushw   $0                              // transfer buffer offset
                pushw   $0x01                           // number of sectors to transfer = 1
                pushw   $0x10                           // packet size = 10h
                movb    $0x42,%ah                       // INT 0x13 function 42h "EXTENDED READ"
                movb    $DRIVE_NUMBER,%dl               // DL = drive number
                movw    %sp,%si                         // (DS):SI = disk address packet which was pushed onto stack
                int     $0x13                           // extended read of drive sectors
                add     $0x10,%sp
                popa                                    // pop all registers from stack
                jnb     EXTRTN                          // return without reset of disks
                decw    %di                             // decrement # of retries
                jz      EXTRTN                          // return without reset of disks
                // INT 0x13 function 00h "RESET DISK SYSTEM"
                xorb    %ah,%ah                         // INT 0x13 function 0
                movb    $DRIVE_NUMBER,%dl               // DL = drive number
                int     $0x13
                jmp     EXTRETRY                        // retry
EXTFAIL:        popa
                stc                                     // set carry flag
EXTRTN:         ret

                //
                // Final bootstrap phase.
                //
BOOT:
#if defined(FLOPPYDISK)
                // shutdown floppy disk motor
                movw    $0x03F2,%dx
                xorb    %al,%al
                outb    %al,%dx
#endif
                ljmp    $BOOTSEGMENT,$0

                //
                // Write a "." for every sector loaded.
                //
DUMP:           pushw   %ax
                pushw   %bx
                movb    $0x0E,%ah
                movw    $0x0007,%bx
                movb    $'.',%al
                int     $0x10
                popw    %bx
                popw    %ax
                ret

                //
                // Write "ERR" to the screen.
                //
ERROR:          movb    $0x0E,%ah
                movw    $0x0007,%bx
                movb    $'*',%al
                int     $0x10
                movb    $'*',%al
                int     $0x10
                movb    $'*',%al
                int     $0x10
                movb    $'E',%al
                int     $0x10
                movb    $'R',%al
                int     $0x10
                movb    $'R',%al
                int     $0x10
1:              jmp     1b

                //
                // Variable space.
                //
                .org    0x01E0
#if defined(FLOPPYDISK)
nsectorslo:     .word   1                               // logical starting sector LO
nsectorshi:     .word   0                               // logical starting sector HI
#else
nsectorslo:     .word   HEADS*SPT+1                     // logical starting sector LO
nsectorshi:     .word   0                               // logical starting sector HI
#endif
spt:            .word   SPT                             // sectors per track
heads:          .word   HEADS                           // heads per cylinder
sctnum:         .byte   0                               // S output from LS2CHS
head:           .byte   0                               // H output from LS2CHS
trk:            .word   0                               // C output from LS2CHS

                // 0xAA55 signature
                .org    0x01FE
                .word   0xAA55

