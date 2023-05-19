
ENTRY(_start)

MEMORY
{
        RAM : ORIGIN = 0x00000000, LENGTH = 128M
        ROM : ORIGIN = 0xFFE00000, LENGTH = 2M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _text_start = .;
                *(.startup)
                *(.vectortable)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.got1)
                . = ALIGN(0x10);
                _text_end = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data :
        {
                _data_start = .;
                *(.data)
                *(.data.*)
                /* _sdata = .; */
                *(.sdata)
                *(.sdata.*)
                /* _sdata2 = .; */
                *(.sdata2)
                *(.got.plt)
                *(.got)
                . = ALIGN(0x10);
                _data_end = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _bss_start = .;
                *(.bss)
                *(.bss.*)
                *(COMMON)
                *(.sbss)
                *(.sbss.*)
                *(.scommon)
                *(.dynbss)
                . = ALIGN(0x10);
                _bss_end = .;
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
                *(.comment)
        }
}

