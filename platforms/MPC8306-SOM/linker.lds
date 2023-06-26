
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
                *(.sbss)
                *(.sbss.*)
                *(.dynbss)
                *(.scommon)
                *(COMMON)
                . = ALIGN(0x10);
                _bss_end = .;
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

