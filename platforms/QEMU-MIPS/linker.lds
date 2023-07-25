
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
                . = ALIGN(0x4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(0x4);
                *(.MIPS.abiflags)
                . = ALIGN(0x10);
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
                *(.sdata.*)
                . = ALIGN(0x10);
                _edata = .;
        } > RAM
        _gp = ALIGN(16);
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
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     0 : { *(.debug_info) }
        .debug_abbrev   0 : { *(.debug_abbrev) }
        .debug_aranges  0 : { *(.debug_aranges) }
        .debug_frame    0 : { *(.debug_frame) }
        .debug_line     0 : { *(.debug_line) }
        .debug_line_str 0 : { *(.debug_line_str) }
        .debug_loclists 0 : { *(.debug_loclists) }
        .debug_macro    0 : { *(.debug_macro) }
        .debug_names    0 : { *(.debug_names) }
        .debug_rnglists 0 : { *(.debug_rnglists) }
        .debug_str      0 : { *(.debug_str) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

