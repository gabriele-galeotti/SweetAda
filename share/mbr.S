
//
// MS-DOS 3.30/5.0/6.22 MBR
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

//
// MBR = CHS(0,0,1)
// The PC BIOS loads MBR at address 0000:7C00.
//
// The MBR (except for the startup code 0000:7C00 - 0000:7C1C) is relocated
// to 0000:061D, and operation resumes at the new location. Since the linker
// is instructed to place this code at address 0, every reference must have
// an offset 0x0600.
//

//
// NOTE: some tools (e.g. ms-sys) check on a byte-by-byte basis MBR contents,
// so this MBR could be not detected due to some instructions that are encoded
// differently with respect to the original ones (e.g. XOR AX,AX)
//

                .sect   .text,"ax"
                .code16

                .global _start
_start:
                cli
                xorw    %ax,%ax
                movw    %ax,%ss
                movw    $0x7C00,%sp
                movw    %sp,%si
                pushw   %ax
                popw    %es
                pushw   %ax
                popw    %ds
                sti
                cld                             // clear direction flag
                movw    $0x0600,%di             // new address offset
                movw    $0x0100,%cx             // 512 bytes
          repne movsw
                ljmp    $0x0,$(0x0600+L_1D)

//
// The following code gets executed like if an ORG 0x0600 directive is issued,
// so every reference must takes this into account.
//

L_1D:           movw    $(0x0600+PTABLE),%si    // start with 1st partition
                movb    $0x04,%bl               // 4 partitions
L_22:           cmpb    $0x80,(%si)             // bootable?
                jz      L_35                    // yes, go boot
                cmpb    $0x00,(%si)             // no, test for a bad flag (!= 0)
                jnz     L_48                    // yes, print an error
                addw    $0x10,%si               // step through the table
                decb    %bl
                jnz     L_22                    // another partition
                int     $0x18                   // halt

L_35:           movw    0(%si),%dx              // DL will contain 0x80, DH will contain B0
                movw    2(%si),%cx              // CL will contain B1, CH will contain B2
                movw    %si,%bp
L_3C:           addw    $0x10,%si               // advance to next partition
                decb    %bl                     // last partition?
                jz      L_5D                    // no, go read bootsector
                cmpb    $0x00,(%si)             // yes, check bootable flag
                jz      L_3C                    // if 0, next partition
L_48:           movw    $(0x0600+ERRMSG1),%si   // error, no more partitions

PRINTERR:       lodsb
                cmpb    $0x00,%al               // check for NULL end of string
                jz      L_5B
                pushw   %si
                movw    $0x07,%bx
                movb    $0x0E,%ah
                int     $0x10
                popw    %si
                jmp     PRINTERR
L_5B:           jmp     L_5B

L_5D:           movw    $0x05,%di               // 5 retries
L_60:           movw    $0x7C00,%bx             // 16-bit low buffer address
                movw    $0x0201,%ax             // function 2, 1 sector to read
                pushw   %di
                int     $0x13                   // BIOS disk read (1 sector)
                popw    %di
                jnc     L_78
                xorw    %ax,%ax
                int     $0x13                   // BIOS disk reset
                decw    %di
                jnz     L_60
                movw    $(0x0600+ERRMSG2),%si   // error
                jmp     PRINTERR

L_78:           movw    $(0x0600+ERRMSG3),%si   // prepare error buffer in SI
                movw    $0x7DFE,%di
                cmpw    $0xAA55,(%di)           // signature ok?
                jnz     PRINTERR                // no, error
                movw    %bp,%si
                ljmp    $0x0,$0x7C00            // got to boot code

ERRMSG1:        .asciz  "Invalid partition table"
ERRMSG2:        .asciz  "Error loading operating system"
ERRMSG3:        .asciz  "Missing operating system"

                .org    0x01BE
PTABLE:
PARTITION1:     // 0x01BE
                .byte   0x00                    // boot indicator
                .byte   0x00,0x00,0x00          // starting encoded CHS
                .byte   0x00                    // partition type
                .byte   0x00,0x00,0x00          // ending encoded CHS
                .byte   0x00,0x00,0x00,0x00     // starting sector
                .byte   0x00,0x00,0x00,0x00     // partition size
PARTITION2:     // 0x01CE
                .byte   0x00                    // boot indicator
                .byte   0x00,0x00,0x00          // starting encoded CHS
                .byte   0x00                    // partition type
                .byte   0x00,0x00,0x00          // ending encoded
                .byte   0x00,0x00,0x00,0x00     // starting sector
                .byte   0x00,0x00,0x00,0x00     // partition size
PARTITION3:     // 0x01DE
                .byte   0x00                    // boot indicator
                .byte   0x00,0x00,0x00          // starting encoded CHS
                .byte   0x00                    // partition type
                .byte   0x00,0x00,0x00          // ending encoded CHS
                .byte   0x00,0x00,0x00,0x00     // starting sector
                .byte   0x00,0x00,0x00,0x00     // partition size
PARTITION4:     // 0x01EE
                .byte   0x00                    // boot indicator
                .byte   0x00,0x00,0x00          // starting encoded CHS
                .byte   0x00                    // partition type
                .byte   0x00,0x00,0x00          // ending encoded CHS
                .byte   0x00,0x00,0x00,0x00     // starting sector
                .byte   0x00,0x00,0x00,0x00     // partition size

                // 0xAA55 signature
                .org    0x01FE
SIGNATURE:      .word   0xAA55

