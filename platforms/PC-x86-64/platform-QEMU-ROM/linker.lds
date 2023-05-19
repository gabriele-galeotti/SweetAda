
ENTRY(_start16)

MEMORY
{
        RAM : ORIGIN = 0x00000000, LENGTH = 256k
        ROM : ORIGIN = 0x000E0000, LENGTH = 128k
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = .;
                . = 0x10000;
                . = ALIGN(0x10000); /* .init16 must be placed on 64k-boundary */
                _sinit16 = .;
                *(.init16)
                *(.startup)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.gnu.linkonce.t.*)
                *(.gnu.linkonce.r.*)
                . = ALIGN(0x4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(0x10);
                _etext = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data : AT(_etext)
        {
                _sdata = .;
                . = ALIGN(0x10);
                *(.data)
                *(.data.*)
                *(.gnu.linkonce.d.*)
                . = ALIGN(0x10);
                _edata = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .reset : AT(0x000FFFF0)
        {
                /* jmp $CS:IP to .init16 section with IP = 0x0000 */
                BYTE(0xEA);
                BYTE(0x00);
                BYTE(0x00);
                BYTE((_sinit16 >> 4) & 0xFF);
                BYTE((_sinit16 >> 12) & 0xFF);
                FILL(0x90);
                . = 0x10;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                . = ALIGN(0x10);
                *(.pagetables)
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(COMMON)
                *(.gnu.linkonce.b.*)
                . = ALIGN(0x10);
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     : { *(.debug_info) }
        .debug_abbrev   : { *(.debug_abbrev) }
        .debug_aranges  : { *(.debug_aranges) }
        .debug_frame    : { *(.debug_frame) }
        .debug_line     : { *(.debug_line) }
        .debug_line_str : { *(.debug_line_str) }
        .debug_loclists : { *(.debug_loclists) }
        .debug_macro    : { *(.debug_macro) }
        .debug_names    : { *(.debug_names) }
        .debug_rnglists : { *(.debug_rnglists) }
        .debug_str      : { *(.debug_str) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

