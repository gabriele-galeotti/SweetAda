
//
// mbr.S
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

//
// MBR CHS mapping = 0,0,1
// MBR loaded @ 0000:7C00
//
// The MBR (except for the startup code 0000:7C00 - 0000:7C1A) is relocated
// to 0000:061B, and operation resumes at the new location.
//

                .sect   .text,"ax"
                .code16

                .global _start
_start:
                //
                // Relocation stub.
                //
                // On entry, CS:IP = 0000:7C00.
                //
                // The relocation stub is 0x1B bytes long.
                //
                xorw    %ax,%ax                         // SS = 0
                movw    %ax,%ss
                movw    $0x7C00,%sp
                sti
                pushw   %ax                             // ES = 0
                popw    %es
                pushw   %ax                             // DS = 0
                popw    %ds
                cld
                movw    $0x7C1B,%si                     // hardwired
                movw    $0x061B,%di                     // hardwired
                pushw   %ax                             // put new address in the stack for RETF
                pushw   %di
                movw    $0x01E5,%cx                     // copy 0x200-0x1B=0x1E5=485 bytes of code
            rep movsb
                retf                                    // jump to 0000:061B

                //
                // Check partition table.
                //
                // On entry, CS:IP = 0000:061B, CX = 0.
                //
                // Partitions should be:
                // 0x80 (bootable)
                // 0x00 (not-bootable)
                // any other value is refused. Only one partition should be
                // bootable. If no partition is bootable, exit to INT 0x18.
                //
CHECKP:         movw    $(PTABLE+0x0600),%bp            // start of partition table
                movb    $04,%cl                         // 4 partitions
L1:             cmpb    %ch,0(%bp)                      // CH is 0
                jl      L2                              // 80 = bootable, jump
                jnz     INVP                            // error: invalid partition table
                addw    $0x10,%bp                       // another partition
                loop    L1
                int     $0x18                           // exit to BASIC
                // check if other partitions are bootable
L2:             movw    %bp,%si
L3:             addw    $0x10,%si
                decw    %cx
                jz      MAIN                            // ok
                cmpb    %ch,(%si)
                jz      L3
INVP:           movb    $(ERR_INVALID-0x0100),%al       // "Invalid partition table"
                // fall-through in error message

                //
                // Print error routine.
                //
                // Warning: movb $0x07,%ah instruction is needed for error
                // messages being located at address 0x7??.
                //
ERROR:          movb    $0x07,%ah                       // high-byte of the offset of error messages, MSB(0x600+0x100)
                movw    %ax,%si
PRINTC:         lodsb                                   // load character into AL from [SI]
DEADLOOP:       cmpb    $0x00,%al                       // have we reached end of message marker?(00) if so, then lock
                jz      DEADLOOP                        // execution into infinite loop
                // INT 0x10 function 0Eh "TELETYPE OUTPUT"
                movw    $0x0007,%bx                     // display page 0, normal white on black characters
                movb    $0x0E,%ah
                int     $0x10
                jmp     PRINTC

                //
                // Main logic.
                //
                // On entry, BP = partition pointer, CX = 0.
                // Memory @ BP+0x10 is unused, use this as a counter variable.
                //
MAIN:           movb    %cl,0x10(%bp)                   // clear counter
                call    DISKREAD                        // will set the carry on error
                jnc     CHKSIGN                         // ok, check signature
LOOK3:          incb    0x10(%bp)
                // if the partition is not WIN95 OSR2 FAT32, output an error,
                // else check the FAT32 backup boot sector
                cmpb    $0x0B,4(%bp)                    // partition type = WIN95 OSR2 FAT32 basic?
                jz      LOOK2
                cmpb    $0x0C,4(%bp)                    // partition type = WIN95 OSR2 FAT32 LBA-mapped?
                jz      LOOK2
                movb    $(ERR_LOADING-0x100),%al        // "Error loading operating system"
                jnz     ERROR
                // FAT32 partition, check the backup sector
                // http://support.microsoft.com/kb/247575
                // "The primary boot sector is sector 0 of the logical drive.
                // The backup FAT32 boot sector is located at sector 6 of the
                // logical drive."
LOOK2:          addb    $0x06,2(%bp)                    // stretch starting sector += 6 inside the table
                addb    $0x06,8(%bp)
                adcb    $0,10(%bp)
                call    DISKREAD
                jnb     CHKSIGN                         // ok, check signature
                movb    $(ERR_LOADING-0x100),%al        // "Error loading operating system"
                jmp     ERROR

                //
                // Once the boot sector is loaded, check signature.
                //
CHKSIGN:        cmpw    $0xAA55,(0x7C00+0x1FE)          // check for 0xAA55
                jz      GOBOOT                          // ok, jump to boot record
                cmpb    $0,0x10(%bp)                    // another partition?
                jz      LOOK3
                movb    $(ERR_MISSING-0x100),%al        // "Missing operating system"
                jmp     ERROR

                //
                // Disk drive routines.
                //
                // Use INT 0x13 function 08h "GET DRIVE PARAMETERS".
                //
DISKREAD:       movw    $5,%di                          // 5 retries
                movb    0(%bp),%dl                      // 80 -> DL (first hard drive)
                movb    $0x08,%ah
                int     $0x13
                jc      READSECTOR                      // error, normal read
                // compute total # of sectors = sectors * heads * cylinders
                // AH is 0
                movb    %cl,%al
                andb    $0x3F,%al                       // extract maximum sector #
                cbw
                // now AX = # of sectors
                movb    %dh,%bl
                movb    %ah,%bh
                // now BX = head #
                // head is 0-based
                incw    %bx
                // ... * # of heads
                mul     %bx
                // CL bits 6-7 = cylinder MSB
                // CH cylinder LSB
                movw    %cx,%dx
                xchg    %dh,%dl
                movb    $0x06,%cl                       // shift MSB cylinder #
                shrb    %cl,%dh
                // now DX = cylinders
                // cylinder is 0-based
                incw    %dx
                // ... * # of cylinders
                mul     %dx
                // result in DX:AX, check 8 GB barrier
                cmpw    %dx,10(%bp)
                ja      EXTENDED                        // extended INT 0x13
                jc      READSECTOR                      // normal read
                cmpw    %ax,8(%bp)
                jnc     EXTENDED                        // extended INT 0x13

                //
                // INT 13H extended read.
                //
READSECTOR:
#if 1
                // unconditionally use EXTENDED READ
                jmp     EXTENDED
                nop
#else
                // default (original MBR code)
                // INT 0x13 function 02h "READ SECTOR(S) INTO MEMORY"
                movw    $0x0201,%ax
#endif
                movw    $0x7C00,%bx                     // (ES):BX = memory buffer
                movw    2(%bp),%cx                      // CX, DX = drive + encoded CHS from partition table
                movw    0(%bp),%dx
                int     $0x13
                jnc     READRETURN
                decw    %di                             // decrement # of retries
                jz      READRETURN
                // INT 0x13 function 00h "RESET DISK SYSTEM"
                xorb    %ah,%ah                         // INT 0x13 function 0
                movb    0(%bp),%dl                      // DL = drive number
                int     $0x13
                jmp     READSECTOR                      // retry

EXTENDED:       movb    0(%bp),%dl                      // DL = drive number
                pusha                                   // push all registers onto stack
                movw    $0x55AA,%bx                     // BX must be set to 55AAh
                movb    $0x41,%ah                       // INT 0x13 function 41h "INSTALLATION CHECK"
                int     $0x13                           // "check for INT 0x13 extensions"
                jc      EXTENDEDFAIL                    // was operation successful? if not, return (with carry flag set)
                cmpw    $0xAA55,%bx                     // the contents of BX are changed into AA55h if exts installed
                jnz     EXTENDEDFAIL                    // are they installed? if not, return (with carry flag set)
                testb   $0x01,%cl                       // function 42h supported?
                jz      EXTENDEDFAIL                    // return (with carry flag set)
                popa                                    // pop all registers from stack
EXTENDEDRETRY:  pusha                                   // push all registers onto stack
                pushw   $0
                pushw   $0
                pushw   10(%bp)                         // LBA starting sector MSB bytes
                pushw   8(%bp)                          // LBA starting sector LSB bytes
                pushw   $0                              // transfer buffer segment
                pushw   $0x7C00                         // transfer buffer offset
                pushw   $0x01                           // number of sectors to transfer = 1
                pushw   $0x10                           // packet size = 10h
                movb    $0x42,%ah                       // INT 0x13 function 42h "EXTENDED READ"
                movw    %sp,%si                         // (DS):SI = disk address packet which was pushed onto stack
                int     $0x13                           // extended read of drive sectors
                popa                                    // pop packet values from stack
                popa                                    // pop all registers from stack
                jnb     READRETURN                      // return without reset of disks
                decw    %di                             // decrement # of retries
                jz      READRETURN                      // return without reset of disks
                // INT 0x13 function 00h "RESET DISK SYSTEM"
                xorb    %ah,%ah                         // INT 0x13 function 0
                movb    0(%bp),%dl                      // DL = drive number
                int     $0x13
                jmp     EXTENDEDRETRY                   // retry
EXTENDEDFAIL:   popa
                stc                                     // set carry flag
READRETURN:     ret

                //
                // Error messages.
                //
                .org    0x012C
ERROR1:         .asciz  "Invalid partition table"
ERROR2:         .asciz  "Error loading operating system"
ERROR3:         .asciz  "Missing operating system"

                //
                // Boot the operating system bootsector.
                //
GOBOOT:         movw    %sp,%di
                pushw   %ds                             // DS is 0 at this time
                pushw   %di                             // SP -> DI (now 0x7C00)
                movw    %bp,%si                         // BP (still 0x07BE) -> SI for use by boot record
                retf                                    // simulated jump to 0000:7C00

                //
                // Error message offsets.
                //
                .org    0x01B5
ERR_INVALID:    .byte   ERROR1-0x0100                   // 0x1B5: 0x2C
ERR_LOADING:    .byte   ERROR2-0x0100                   // 0x1B6: 0x44
ERR_MISSING:    .byte   ERROR3-0x0100                   // 0x1B7: 0x63

                //
                // Disk serial number.
                //
                .org    0x01B8
DISKSN:         .byte   0x00,0x00,0x00,0x00

                //
                // Partition table.
                //
                // CHS bytes    +0       +1       +2
                //           76543210 76543210 76543210
                //           HHHHHHHH CCSSSSSS cccccccc
                // INT 0x13     DH       CL       CH
                // C = cylinder MSB, c = cylinder LSB
                //
                // starting sector is LBA 0-based
                //
                .org    0x01BE
PTABLE:
PARTITION1:     // 0x01BE
                .byte   0x00                            // +00 boot indicator
                .byte   0x00,0x00,0x00                  // +01 starting encoded CHS
                .byte   0x00                            // +04 partition type
                .byte   0x00,0x00,0x00                  // +05 ending encoded CHS
                .byte   0x00,0x00,0x00,0x00             // +08 starting sector
                .byte   0x00,0x00,0x00,0x00             // +0C partition size
PARTITION2:     // 0x01CE
                .byte   0x00                            // +00 boot indicator
                .byte   0x00,0x00,0x00                  // +01 starting encoded CHS
                .byte   0x00                            // +04 partition type
                .byte   0x00,0x00,0x00                  // +05 ending encoded
                .byte   0x00,0x00,0x00,0x00             // +08 starting sector
                .byte   0x00,0x00,0x00,0x00             // +0C partition size
PARTITION3:     // 0x01DE
                .byte   0x00                            // +00 boot indicator
                .byte   0x00,0x00,0x00                  // +01 starting encoded CHS
                .byte   0x00                            // +04 partition type
                .byte   0x00,0x00,0x00                  // +05 ending encoded CHS
                .byte   0x00,0x00,0x00,0x00             // +08 starting sector
                .byte   0x00,0x00,0x00,0x00             // +0C partition size
PARTITION4:     // 0x01EE
                .byte   0x00                            // +00 boot indicator
                .byte   0x00,0x00,0x00                  // +01 starting encoded CHS
                .byte   0x00                            // +04 partition type
                .byte   0x00,0x00,0x00                  // +05 ending encoded CHS
                .byte   0x00,0x00,0x00,0x00             // +08 starting sector
                .byte   0x00,0x00,0x00,0x00             // +0C partition size

                // 0xAA55 signature
                .org    0x01FE
SIGNATURE:      .word   0xAA55

