
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
                /* *(.gnu.linkonce.t.*) */
                /* *(.gnu.linkonce.r.*) */
                *(.eh_frame)
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
                /* *(.gnu.linkonce.d.*) */
                /* *(.gcc_except_table) */
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
                /* *(.gnu.linkonce.b.*) */
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
                *(.comment)
        }
}

