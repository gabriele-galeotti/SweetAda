
#define CONFADD          0x0CF8
#define CONFDATA         0x0CFC
#define PCICFG(BN,DN,FN) (1<<31|BN<<16|DN<<11|FN<<8)

                // GM71C(S)4400C/CL datasheet 1,048,576 WORDS x 4BIT CMOS DYNAMIC RAM
                // An initial pause of 100us is required after power up
                // followed by a minimum of eight initialization cycles (RAS
                // only refresh cycle or CAS before RAS refresh cycle). If the
                // internal refresh counter is used, a minimum of eight CAS
                // before RAS refresh cycles is required.

                // 100 us delay
                movl    $1,%ecx
                fcall   delay

                //
                // Setup 82437FX TSC: device = 0, function = 0.
                //
                movl    $tscdata_start,%esi
1:              movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                cmpl    $tscdata_end,%esi
                jne     1b

                // 100 us delay
                movl    $1,%ecx
                fcall   delay

                //
                // Setup 82371FB PIIX: device = 7, function = 0.
                //
                movl    $piixdata_start,%esi
1:              movl    $PCICFG(0,7,0),%eax
                fcall   pci_configure
                cmpl    $piixdata_end,%esi
                jne     1b

                //
                // Skip configuration data.
                //
                jmp     cfg_memory_end

pci_configure:
                // write a byte to PCI configuration space
                // ESI: address of configuration data pair
                // EAX: PCI coordinates CONE/Busnum/Devnum/Funcnum
                lodsb                           // load register number from data array
                movb    %al,%cl                 // save in CL
                andb    $0x03,%cl               // from register offset to amount of bit shift
                shlb    $0x03,%cl               // 0 --> 0 bits , 1 --> 8 bits, ...
                andb    $0xFC,%al               // mask bits 0:1 for 32-bit PCI access
                movw    $CONFADD,%dx            // write to CONFADD
                outl    %eax,%dx
                movw    $CONFDATA,%dx
                inl     %dx,%eax                // read from configuration space
                xorl    %ebx,%ebx
                movb    $0xFF,%bl               // bits to be zeroed
                shll    %cl,%ebx
                notl    %ebx                    // create bitmask by inverting
                andl    %ebx,%eax
                movl    %eax,%ebx               // save temporary data in EBX
                xorl    %eax,%eax
                lodsb                           // load register value from data array
                shll    %cl,%eax
                orl     %ebx,%eax               // build final value
                outl    %eax,%dx                // write to configuration space
                fret

tscdata_start:
                // 1st byte = register offset
                // 2nd byte = register value
                .byte   0x50,0x00               // PCON  default:0x00 bios:0x48
                .byte   0x52,0x60               // CC    default:0x?2 bios:0x23 // no cache
                // 8 MB FPM DRAMs @ 66 MHz
                .byte   0x57,0x03               // DRAMC default:0x01 bios:0x03 // copy from bios
                .byte   0x58,0xAB               // DRAMT default:0x00 bios:0x4A // copy from bios
                // 32 MB EDO DRAMs @ 66 MHz
                //.byte   0x57,0x03               // DRAMC default:0x01 bios:0x03 // copy from bios
                //.byte   0x58,0x4A               // DRAMT default:0x00 bios:0x4A // copy from bios
                .byte   0x59,0x00               // PAM0  default:0x00 bios:0x10
                .byte   0x5A,0x00               // PAM1  default:0x00 bios:0x11
                .byte   0x5B,0x00               // PAM2  default:0x00 bios:0x00
                .byte   0x5C,0x00               // PAM3  default:0x00 bios:0x00
                .byte   0x5D,0x00               // PAM4  default:0x00 bios:0x00
                .byte   0x5E,0x00               // PAM5  default:0x00 bios:0x00
                .byte   0x5F,0x00               // PAM6  default:0x00 bios:0x00
                // 0x02 = 8MB RAM, 0x08 = 32 MB RAM
                .byte   0x60,0x02               // DRB0  default:0x02 bios:0x02 // populated
                .byte   0x61,0x02               // DRB1  default:0x02 bios:0x02 // not populated
                .byte   0x62,0x02               // DRB2  default:0x02 bios:0x02 // not populated
                .byte   0x63,0x02               // DRB3  default:0x02 bios:0x02 // not populated
                .byte   0x64,0x02               // DRB4  default:0x02 bios:0x02 // not populated
                .byte   0x67,0x11               // DRTH  default:0x11 bios:0x??
                .byte   0x68,0x00               // DRTL  default:0x00 bios:0x00
                .byte   0x72,0x0A               // SMRAM default:0x02 bios:0x0A
tscdata_end:

piixdata_start:
                // 1st byte = register offset
                // 2nd byte = register value
                .byte   0x4C,0x4D               // IORT    default:0x4D bios:0x4D
                .byte   0x4E,0x63               // XBCS    default:0x03 bios:0x23
                .byte   0x60,0x80               // PIRQRCA default:0x80 bios:0x80
                .byte   0x61,0x80               // PIRQRCB default:0x80 bios:0x80
                .byte   0x62,0x80               // PIRQRCC default:0x80 bios:0x0A
                .byte   0x63,0x80               // PIRQRCD default:0x80 bios:0x80
                // 0x72 = 8 MB RAM, 0xF2 = 32 MB RAM
                .byte   0x69,0x72               // TOM     default:0x02 bios:0x72
                //.byte   0x6A,0x0004             // MSTAT   default:0x???? bios:0x0004
                .byte   0x70,0x80               // MBIRQ0  default:0x80 bios:0x0F
                .byte   0x71,0x80               // MBIRQ1  default:0x80 bios:0x07
                .byte   0x76,0x0C               // MBDMA0# default:0x0C bios:0x03
                .byte   0x77,0x0C               // MBDMA1# default:0x0C bios:0x04
                //.byte   0x78,0x0002             // PCSC    default:0x0002 bios:0x0002
piixdata_end:

cfg_memory_end:

