
//
// bootsector.S
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

////////////////////////////////////////////////////////////////////////////////

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
#endif

// BIOS/MBR loads the boot sector @ 0000:7C00.
#define BIOSSEGMENT 0x07C0

// BOOTSEGMENT is the segment target address of the binary
// NSECTORS is the number of sectors to load

//#define OFFSET(x) (0x7C00+x) // offset without resetting CS:IP
//#define OFFSET(x) x

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
                lbasectorlo = (0x7C00+0x1C)
                lbasectorhi = (0x7C00+0x1E)

                clc
                cld
                movw    %cs,%ax                         // SS = DS = CS
                movw    %ax,%ds
                movw    %ax,%ss
                movw    $0x7C00,%sp
                movw    $BOOTSEGMENT,%ax                // ES = BOOTSEGMENT
                movw    %ax,%es
                //xorw    %bx,%bx
                movw    $NSECTORS,%si
                incw    lbasectorlo
                jne     1f
                incw    lbasectorhi
1:

READ:           movw    lbasectorlo,%ax
                movw    lbasectorhi,%dx
                call    DUMP
                //call    LS2CHS
                //jc      ERROR
                //call    BIOSREAD
                call    EXTENDED
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
                incw    lbasectorlo
                jne     READ
                incw    lbasectorhi
                jmp     READ

                //
                // Issue read one sector request.
                // INT 13H AH=02H READ SECTORS FROM DRIVE
                //
                // input: sctnum = [0x7DE8]
                // input: head = [0x7DE9]
                // input: trk = [0x7DEA]
                //
BIOSREAD:       movb    $0x01,%al
                movb    $0x02,%ah
                movw    trk,%dx
                movb    $0x06,%cl
                shlb    %cl,%dh
                orb     sctnum,%dh
                movw    %dx,%cx
                xchgb   %cl,%ch
                movb    $DRIVE_NUMBER,%dl               // physical drive number
                movb    head,%dh                        // current head
                int     $0x13
                ret

                //
                // Extended read.
                // LBA sector = DX:AX
                //
EXTENDED:       pusha                                   // push all registers onto stack
                movb    $DRIVE_NUMBER,%dl               // DL = drive number
                movw    $0x55AA,%bx                     // BX must be set to 55AAh
                movb    $0x41,%ah                       // INT 0x13 function 41h "INSTALLATION CHECK"
                int     $0x13                           // "check for INT 0x13 extensions"
                jc      EXTENDEDFAIL                    // was operation successful? if not, return (with carry flag set)
                cmpw    $0xAA55,%bx                     // the contents of BX are changed into AA55h if exts installed
                jnz     EXTENDEDFAIL                    // are they installed? if not, return (with carry flag set)
                testb   $0x01,%cl                       // function 42h supported?
                jz      EXTENDEDFAIL                    // return (with carry flag set)
                popa                                    // pop all registers from stack
                movw    $5,%di                          // 5 retries
EXTENDEDRETRY:  pusha                                   // push all registers onto stack
                pushw   $0
                pushw   $0

                pushw   %dx                             // LBA starting sector MSB bytes
                pushw   %ax                             // LBA starting sector LSB bytes
                pushw   %es                             // transfer buffer segment
                pushw   $0                              // transfer buffer offset

                pushw   $0x01                           // number of sectors to transfer = 1
                pushw   $0x10                           // packet size = 10h
                movb    $DRIVE_NUMBER,%dl               // DL = drive number
                movb    $0x42,%ah                       // INT 0x13 function 42h "EXTENDED READ"
                movw    %sp,%si                         // (DS):SI = disk address packet which was pushed onto stack
                int     $0x13                           // extended read of drive sectors
                popa                                    // pop packet values from stack
                popa                                    // pop all registers from stack
                jnb     READRETURN                      // return without reset of disks
                decw    %di                             // decrement # of retries
                jz      READRETURN                      // return without reset of disks
                // INT 0x13 function 00h "RESET DISK SYSTEM"
                movb    $DRIVE_NUMBER,%dl               // DL = drive number
                xorb    %ah,%ah                         // INT 0x13 function 0
                int     $0x13
                jmp     EXTENDEDRETRY                   // retry
EXTENDEDFAIL:   popa
                stc                                     // set carry flag
READRETURN:     ret

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
                // Convert a logical sector into CHS.
                //
                // http://en.wikipedia.org/wiki/Logical_block_addressing
                // http://wiki.osdev.org/ATA_in_x86_RealMode_%28BIOS%29
                // MSDOS622/bootrecord.S
                // input: logical sector = DX:AX
                // input: spt = [7DE4]
                // input: heads = [7DE6]
                // output: sctnum = [0x7DE8]
                // output: head = [0x7DE9]
                // output: trk = [0x7DEA]
                //
LS2CHS:         cmpw    spt,%dx                         // compare with spt (overflow)
                jnc     1f                              // error
                divw    spt                             // divisor = spt
                incb    %dl                             // sector number is 1-based, limited to 63
                movb    %dl,sctnum                      // sector #
                xorw    %dx,%dx
                divw    heads                           // divisor = heads
                movb    %dl,head                        // head #, limited to 254
                movw    %ax,trk                         // trk #
                clc
                ret
1:              stc
                ret

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


                .org    0x01E0
nsectorshi:     .word   0                               // logical starting sector HI
#if defined(FLOPPYDISK)
nsectorslo:     .word   1                               // logical starting sector LO
#else
nsectorslo:     .word   HEADS*SPT+1                     // logical starting sector LO = CHS(1,0,2)
#endif
spt:            .word   SPT                             // sectors per track
heads:          .word   HEADS                           // heads per cylinder
sctnum:         .byte   0                               // S output from ls2chs
head:           .byte   0                               // H output from ls2chs
trk:            .word   0                               // C output from ls2chs

                // 0xAA55 signature
                .org    0x01FE
                .word   0xAA55

