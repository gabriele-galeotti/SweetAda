
#define CONFADD          0x0CF8
#define CONFDATA         0x0CFC
#define PCICFG(BN,DN,FN) (1<<31|BN<<16|DN<<11|FN<<8)

                // 100 us delay
                movl    $1,%ecx
                fcall   delay

                //
                // Setup 82443BX.
                //
                movl    $hbdata_start,%esi
1:              movl    $PCICFG(0,0,0),%eax     // CONE = 1, Busnum = 0, Devnum = 0, Funcnum = 0
                fcall   pci_configure
                cmpl    $hbdata_end,%esi
                jne     1b

                // 100 us delay
                movl    $1,%ecx
                fcall   delay

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
                movw    CONFADD,%dx             // write to CONFADD
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
                // 1st byte = register offset
                // 2nd byte = register value
                .byte   0x50,0x0C               // NBXCFG 0..7
                .byte   0x51,0xA8               // NBXCFG 8..15
                .byte   0x52,0x00               // NBXCFG 16..23
                .byte   0x53,0xFF               // NBXCFG 24..31

                .byte   0x57,0x09               // DRAMC SDRAM, 15.6 us

                .byte   0x58,0x03               // DRAMT

                .byte   0x59,0x30               // PAM0
                .byte   0x5A,0x11               // PAM1
                .byte   0x5B,0x00               // PAM2
                .byte   0x5C,0x00               // PAM3
                .byte   0x5D,0x00               // PAM4
                .byte   0x5E,0x00               // PAM5
                .byte   0x5F,0x00               // PAM6

                .byte   0x60,0x02               // DRB0 1st row of DIMM1
                .byte   0x61,0x04               // DRB1 2nd row of DIMM1
                .byte   0x62,0x04               // DRB2
                .byte   0x63,0x04               // DRB3
                .byte   0x64,0x04               // DRB4
                .byte   0x65,0x04               // DRB5
                .byte   0x66,0x04               // DRB6
                .byte   0x67,0x04               // DRB7

                .byte   0x68,0x00               // FDHC

                .byte   0x69,0x00               // MBSC 0..7
                .byte   0x6A,0x00               // MBSC 8..15
                .byte   0x6B,0x00               // MBSC 16..23
                .byte   0x6C,0x00               // MBSC 24..31
                .byte   0x6D,0x80               // MBSC 32..39 MAA[13:0], WEA#, SRASA#, SCASA# Buffer Strengths = 2x (66 MHz & 100 MHz)
                .byte   0x6E,0x00               // MBSC 40..47

                .byte   0x7A,0x10               // PMCR
hbdata_end:

cfg_memory_end:

