
ENTRY(_start)

MEMORY
{
        ROM : ORIGIN = 0xBFC00000, LENGTH = 1M
        RAM : ORIGIN = 0xA0000000, LENGTH = 16M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = . ;
                *(.vectors)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.MIPS.abiflags)
                . = ALIGN(0x4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                _etext = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data : AT(_etext)
        {
                _sdata = . ;
                *(.data)
                *(.data.*)
                *(.sdata)
                . = ALIGN(0x10);
                _edata = .;
        } > RAM
        _gp = ALIGN(16);
        .lit8 : { *(.lit8) }
        .lit4 : { *(.lit4) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(.sbss)
                *(.sbss.*)
                *(COMMON)
                *(.scommon)
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     0 : { *(.debug_info) }
        .debug_abbrev   0 : { *(.debug_abbrev) }
        .debug_aranges  0 : { *(.debug_aranges) }
        .debug_ranges   0 : { *(.debug_ranges) }
        .debug_line     0 : { *(.debug_line) }
        .debug_str      0 : { *(.debug_str) }
        .debug_line_str 0 : { *(.debug_line_str) }
        .debug_rnglists 0 : { *(.debug_rnglists) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

