
//
// bootsector.S
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

////////////////////////////////////////////////////////////////////////////////

#if defined(FLOPPYDISK)
# define MEDIA_TYPE 0xF0
# define CYLINDERS 80
# define HEADS 2
# define SPT 18
# define ROOT_ENTRIES 0x00E0
# define PARTITION_SECTORS_SSIZE 2880
# define PARTITION_SECTOR_START 0
# define PARTITION_SECTORS_LSIZE 0
# define DRIVE_NUMBER 0
# define FAT_NAME "FAT12   "
#else
# define MEDIA_TYPE 0xF8
# define ROOT_ENTRIES 0x0200
# define DRIVE_NUMBER 0x80
# define FAT_NAME "FAT16   "
#endif

// BIOS loads the boot sector @ 0000:7C00.
#define BIOSSEGMENT 0x07C0

// BOOTSEGMENT is the segment target address of the binary
// NSECTORS is the number of sectors to load

//#define OFFSET(x) (0x7C00+x) // offset without resetting CS:IP
//#define OFFSET(x) x

                .sect   .text,"ax"
                .code16

                .org    0x0000

                .global _start
_start:
                //
                // Hardwired MS-DOS header + BPB.
                //
                .byte   0xEB,0x3C,0x90          // +00 hardwired short JMP + NOP (jump @ offset 0x003E)
                .ascii  "MSDOS5.0"              // +03 OEM signature
                                                //     DOS 2.0 BPB
                .word   0x0200                  // +0B sector size: bytes x sector
                .byte   1                       // +0D sectors x cluster (must be a power of 2)
                .word   1                       // +0E reserved sectors (at least 1)
                .byte   2                       // +10 number of FATs
                .word   ROOT_ENTRIES            // +11 root entries
                .word   PARTITION_SECTORS_SSIZE // +13 small sectors (if <= 65535)
                .byte   MEDIA_TYPE              // +15 0xF0 = 3.5'' 1.44 MB floppy disk, 0xF8 = hard disk
                .word   0x0009                  // +16 sectors per FAT
                                                //     DOS 3.31 BPB
                .word   SPT                     // +18 sectors per track
                .word   HEADS                   // +1A number of heads
                .long   PARTITION_SECTOR_START  // +1C hidden sectors
                .long   PARTITION_SECTORS_LSIZE // +20 large sectors (total # of sectors)
                                                //     DOS 4.0 Extended BPB (only FAT12/FAT16/HPFS, no FAT32/NTFS)
                .byte   DRIVE_NUMBER            // +24 physical drive number (0x00 = first floppy disk, 0x80 = first hard disk)
                .byte   0                       // +25 flags (current head - for FAT always set to 0)
                .byte   0x29                    // +26 extended BPB signature
                .long   0x12345678              // +27 volume serial number
                .ascii  "SweetAda   "           // +2B "           " volume label
                .ascii  FAT_NAME                // +36 system ID

                // offset = 0x003E

                //
                // Reset CS:IP so that the start of this code appears to live
                // @ 0x07C0:0000. This way, we know possibly how to arrange a
                // GDT without complicate offset calculations and relocations.
                //
                nop                             // sync disassembly
                nop
                nop
                ljmp    $BIOSSEGMENT,$(start1-_start)

                //
                // GDT descriptors could be placed here.
                //

start1:
                clc
                cld
                // DS = CS
                movw    %cs,%ax
                movw    %ax,%ds
                // setup ES:DX buffer
                movw    $BOOTSEGMENT,%ax
                movw    %ax,%es
                xorw    %bx,%bx
                movw    $NSECTORS,%si

read:           movw    nsectorslo,%ax
                movw    nsectorshi,%dx
                call    dump
#if defined(DELAY)
                call    delay
#endif
                call    ls2chs
                jc      error
                movb    $0x01,%al
                call    biosread
                jc      error
                decw    %si
                je      boot
                movw    %es,%ax
                addw    $0x20,%ax               // bump buffer by 1 sector = 0x200 bytes
                movw    %ax,%es
                incw    nsectorslo
                jne     read
                incw    nsectorshi
                jmp     read

boot:
#if defined(FLOPPYDISK)
                // shutdown floppy disk motor
                movw    $0x3F2,%dx
                xorb    %al,%al
                outb    %al,%dx
#endif
                ljmp    $BOOTSEGMENT,$0         // jump to code

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
ls2chs:         cmpw    spt,%dx                 // compare with spt (overflow)
                jnc     1f                      // error
                divw    spt                     // divisor = spt
                incb    %dl                     // sector number is 1-based, limited to 63
                movb    %dl,sctnum              // sector #
                xorw    %dx,%dx
                divw    heads                   // divisor = heads
                movb    %dl,head                // head #, limited to 254
                movw    %ax,trk                 // trk #
                clc
                ret
1:              stc
                ret

                //
                // Issue one read request.
                //
                // input: sector count = AL
                // input: sctnum = [0x7DE8]
                // input: head = [0x7DE9]
                // input: trk = [0x7DEA]
                //
biosread:       movb    $0x02,%ah               // INT 13H AH=02H READ SECTORS FROM DRIVE
                movw    trk,%dx
                movb    $0x06,%cl
                shlb    %cl,%dh
                orb     sctnum,%dh
                movw    %dx,%cx
                xchgb   %cl,%ch
                movb    $DRIVE_NUMBER,%dl       // physical drive number
                movb    head,%dh                // current head
                int     $0x13
                ret

                //
                // Write a "." for every sector loaded.
                //
dump:           pushw   %ax
                pushw   %bx
                movb    $0x0E,%ah
                movw    $0x0007,%bx
                movb    $'.',%al
                int     $0x10
                popw    %bx
                popw    %ax
                ret

#if 0
                //
                // Write logical sector # to the screen.
                //
dump:           pushw   %ax
                pushw   %bx
                movw    %ax,%cx
                movb    $0x0E,%ah
                movb    $0x07,%bl
                movb    $'S',%al
                int     $0x10
                movb    $':',%al
                int     $0x10
                movb    %cl,%al
                shrb    $4,%al
                andb    $0x0F,%al
                cmpb    $0x09,%al
                jle     1f
                addb    $0x07,%al
1:              addb    $0x30,%al
                int     $0x10
                movb    %cl,%al
                andb    $0x0F,%al
                cmpb    $0x09,%al
                jle     2f
                addb    $0x07,%al
2:              addb    $0x30,%al
                int     $0x10
                movb    $0x0D,%al
                int     $0x10
                popw    %bx
                popw    %ax
                ret
#endif

                //
                // Write "ERR" to the screen.
                //
error:          movb    $0x0E,%ah
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
                // Delay routine.
                //
delay:          movl    $0x100000,%ecx
1:       addr32 loop    1b
                ret

                .org    0x01E0

// logical starting sector HI
nsectorshi:     .word   0

// logical starting sector LO
#if defined(FLOPPYDISK)
nsectorslo:     .word   1
#else
nsectorslo:     .word   HEADS*SPT+1             // CHS(1,0,2)
#endif

// sectors per track
spt:            .word   SPT

// heads per cylinder
heads:          .word   HEADS

// S output from ls2chs
sctnum:         .byte   0

// H output from ls2chs
head:           .byte   0

// C output from ls2chs
trk:            .word   0

                // 0xAA55 signature
                .org    0x01FE
                .word   0xAA55

