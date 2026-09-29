
#define CONFADDR         0x0CF8
#define CONFDATA         0x0CFC
#define PCICFG(BN,DN,FN) (1<<31|BN<<16|DN<<11|FN<<8)

                // 100 us delay
                movl    $1,%ecx
                fcall   delay

                //
                // Setup 82443BX: device = 0, function = 0.
                //
                movl    $hbdata_start,%esi
1:              movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                cmpl    $hbdata_end,%esi
                jne     1b

                // 100 us delay
                movl    $1,%ecx
                fcall   delay

                //
                // Setup 82371AB PIIX4: device = 7, function = 0.
                //
                movl    $piix4data_start,%esi
1:              movl    $PCICFG(0,7,0),%eax
                fcall   pci_configure
                cmpl    $piix4data_end,%esi
                jne     1b

                //
                // Skip PCI configuration data.
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
                movw    CONFADDR,%dx            // write to CONFADDR
                outl    %eax,%dx
                movw    CONFDATA,%dx
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

hbdata_start:
                ////////////////////////////////////////////////////////////////
                // FDHC
                ////////////////////////////////////////////////////////////////
                .byte   0x68,0x00               // no hole in 512-640k, 15-16M
                ////////////////////////////////////////////////////////////////
                // PMCR
                ////////////////////////////////////////////////////////////////
                .byte   0x7A,0x00               // GCLKEN
                ////////////////////////////////////////////////////////////////
                // PAM0..PAM6
                ////////////////////////////////////////////////////////////////
                //.byte   0x59,0x30               // PAM0
                //.byte   0x5A,0x11               // PAM1
                //.byte   0x5B,0x00               // PAM2
                //.byte   0x5C,0x00               // PAM3
                //.byte   0x5D,0x00               // PAM4
                //.byte   0x5E,0x00               // PAM5
                //.byte   0x5F,0x00               // PAM6
                // PAM0..PAM6
                .byte   0x59,0x10               // PAM0 0F0000h – 0FFFFFh RE
                .byte   0x5A,0x11               // PAM1 0C0000h – 0C3FFFh RE 0C4000h – 0C7FFFh RE
                .byte   0x5B,0x00               // PAM2
                .byte   0x5C,0x00               // PAM3
                .byte   0x5D,0x00               // PAM4
                .byte   0x5E,0x00               // PAM5
                .byte   0x5F,0x10               // PAM6 0EC000h – 0EFFFFh RE
                ////////////////////////////////////////////////////////////////
                // DRB0..DRB7
                ////////////////////////////////////////////////////////////////
                .byte   0x60,0x02               // DRB0 Total memory in row0 (in 8 MB)
                .byte   0x61,0x04               // DRB1 Total memory in row0 + row1 (in 8 MB)
                .byte   0x62,0x04               // DRB2 ...
                .byte   0x63,0x04               // DRB3
                .byte   0x64,0x04               // DRB4
                .byte   0x65,0x04               // DRB5
                .byte   0x66,0x04               // DRB6
                .byte   0x67,0x04               // DRB7
                ////////////////////////////////////////////////////////////////
                // PGPOL
                ////////////////////////////////////////////////////////////////
                .byte   0x78,0x23               // DRAM Idle Timer = 8 clocks
                .byte   0x79,0x00               // all 2 banks
                ////////////////////////////////////////////////////////////////
                // RPS
                ////////////////////////////////////////////////////////////////
                .byte   0x74,0x05               // 4 kB
                .byte   0x75,0x00
                ////////////////////////////////////////////////////////////////
                // NBXCFG
                ////////////////////////////////////////////////////////////////
                //.byte   0x50,0x04               // IOQD
                //.byte   0x51,0x00               //
                //.byte   0x52,0x00               //
                //.byte   0x53,0x03               //
                .byte   0x50,0x04               // IOQD
                .byte   0x51,0x00               // Host/DRAM Frequency = 100 MHz
                .byte   0x52,0x00               //
                .byte   0x53,0x03               // ECC components are not populated in this row
                ////////////////////////////////////////////////////////////////
                // DRAMC
                ////////////////////////////////////////////////////////////////
                .byte   0x57,0x09               // MMCONFIG = 0, SDRAM, 15.6 us
                ////////////////////////////////////////////////////////////////
                // DRAMT
                ////////////////////////////////////////////////////////////////
                .byte   0x58,0x03               // CWS|RWS
                ////////////////////////////////////////////////////////////////
                // MBSC
                ////////////////////////////////////////////////////////////////
                .byte   0x69,0x0F               // CKE0/FENA Buffer Strength: 3x (66 MHz & 100 MHz) CKE1/GCKE Buffer Strength: 3x (66 MHz & 100 MHz)
                .byte   0x6A,0xC0               // CSA0#/RASA0#, CSB0#/RASB0# Buffer Strength: 2x (66 MHz & 100 MHz)
                .byte   0x6B,0x00               // CSA1#/RASA1#, CSB1#/RASB1# Buffer Strength: 2x (66 MHz & 100 MHz)
                .byte   0x6C,0x00               //
                .byte   0x6D,0x8A               // MD [63:0] Buffer Strength Control 1: 2x (66 MHz & 100 MHz)
                                                // MD [63:0] Buffer Strength Control 2: 2x (66 MHz & 100 MHz)
                                                // MAB[12:11, 9:0]# & MAB[13,10], WEB#, SRASB#, SCASB# Buffer Strengths: 1x (66 MHz & 100 MHz)
                                                // MAA[13:0], WEA#, SRASA#, SCASA# Buffer Strengths: 2x (66 MHz & 100 MHz)
                .byte   0x6E,0x00               // Reserved
                ////////////////////////////////////////////////////////////////
                // SDRAMC
                ////////////////////////////////////////////////////////////////
                .byte   0x76,0x00
                .byte   0x77,0x01               // Idle/Pipeline DRAM Leadoff Timing: 01
hbdata_end:

piix4data_start:
                ////////////////////////////////////////////////////////////////
                // IORT
                ////////////////////////////////////////////////////////////////
                .byte   0x4C,0x4D               // bios: 0x4D
                ////////////////////////////////////////////////////////////////
                // XBCS
                ////////////////////////////////////////////////////////////////
                .byte   0x4E,0x63               // bios: 0x30
                ////////////////////////////////////////////////////////////////
                // PIRQCA/PIRQCB/PIRQCC/PIRQCD
                ////////////////////////////////////////////////////////////////
                .byte   0x60,0x80               // A bios:0x80
                .byte   0x61,0x80               // B bios:0x80
                .byte   0x62,0x80               // C bios:0x80
                .byte   0x63,0x0B               // D bios:0x0B
                ////////////////////////////////////////////////////////////////
                // TOM
                ////////////////////////////////////////////////////////////////
                .byte   0x69,0x72               // bios:0xFE
                                                // 0x72 = 8 MB RAM, 0xF2 = 32 MB RAM
piix4data_end:

#define SRP3     (0<<0)
#define SRP2     (1<<0)
#define SRCD3    (0<<1)
#define SRCD2    (1<<1)
#define CL3      (0<<2)
#define CL2      (1<<2)
#define LCT4     (0<<3)
#define LCT3     (1<<3)
#define SDRAMPWR (1<<4)
#define SMS_NORM (0<<5)
#define SMS_NOP  (1<<5)
#define SMS_PREC (2<<5)
#define SMS_MODE (3<<5)
#define SMS_CBR  (4<<5)
sdram_disacnt:  .byte   0x57,0x08
sdram_enacnt:   .byte   0x57,0x09
sdram_nop:      .byte   0x76,SRP3|SRCD3|CL3|LCT4|SMS_NOP
sdram_prec:     .byte   0x76,SRP3|SRCD3|CL3|LCT4|SMS_PREC
sdram_cbr:      .byte   0x76,SRP3|SRCD3|CL3|LCT4|SMS_CBR
sdram_mode:     .byte   0x76,SRP3|SRCD3|CL3|LCT4|SMS_MODE
sdram_norm:     .byte   0x76,SRP3|SRCD3|CL3|LCT4|SMS_NORM
refresh_enable: .byte   0x7A,0x14               // GCLKEN|NREF_EN

cfg_memory_end:

#if 1
                movl    $sdram_disacnt,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                // 100 us delay
                movl    $0x10,%ecx
                fcall   delay
                // NOP
                movl    $sdram_nop,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                movl    $0,%esi
                lodsb
                // 100 us delay
                movl    $0x10,%ecx
                fcall   delay
                // PRECHARGE
                movl    $sdram_prec,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                movl    $(1<<(10+2)),%edi
                stosl
                movl    $(0x200000+(1<<(10+2))),%edi
                stosl
                //movl    $(0x300E00<<2),%edi
                //movl    $(0x400E00<<2),%edi
                // 100 us delay
                movl    $0x10,%ecx
                fcall   delay
                // REFEN
                //movl    $refresh_enable,%esi
                //movl    $PCICFG(0,0,0),%eax
                //fcall   pci_configure
                // 100 us delay
                //movl    $0x10,%ecx
                //fcall   delay
                // AUTOREFRESH
                movl    $sdram_cbr,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                movl    $8,%ecx
ar:
                movl    $0,%esi
                movl    $0,%edi
                lodsl
                // 100 us delay
                movl    %ecx,%ebp
                movl    $0x10,%ecx
                fcall   delay
                movl    %ebp,%ecx
                loop    ar
                // MODE
                movl    $sdram_mode,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                movl    $(0x00<<2),%esi
                movl    $(0x00<<2),%edi
                stosl
                // 100 us delay
                movl    $0x10,%ecx
                fcall   delay
                // NORMAL
                movl    $sdram_norm,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                movl    $0,%esi
                lodsb
                // 100 us delay
                movl    $0x10,%ecx
                fcall   delay
                //
                movl    $sdram_disacnt,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
                // 100 us delay
                movl    $0x10,%ecx
                fcall   delay
                //
                movl    $refresh_enable,%esi
                movl    $PCICFG(0,0,0),%eax
                fcall   pci_configure
#endif

#include "W83977TF.h"

