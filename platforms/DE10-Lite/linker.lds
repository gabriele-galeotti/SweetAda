
ENTRY(_start)

MEMORY
{
        RAM : ORIGIN = 0x00000000, LENGTH = 64k
        ROM : ORIGIN = 0x00010000, LENGTH = 64k
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .romstartup :
        {
                _sromstartup = .;
                _svectors = .;
                *(.vectors)
                _evectors = .;
                *(.startup)
                . = ALIGN(0x10);
                _eromstartup = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        _text_start = _eromstartup;
        .text : AT(_text_start)
        {
                _stext = .;
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                . = ALIGN(0x10);
                _etext = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        _data_start = _text_start + SIZEOF(.text);
        .data : AT(_data_start)
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.sdata)
                *(.sdata.*)
                . = ALIGN(0x10);
                _edata = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /* __FIX__ */
        _gp = ALIGN(16) + 0x7FF0;
        PROVIDE(gp = _gp);
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(COMMON)
                . = ALIGN(0x10);
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

