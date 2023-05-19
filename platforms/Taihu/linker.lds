
ENTRY(_start)

MEMORY
{
        RAM       : ORIGIN = 0x00000000, LENGTH = 128M
        ROM       : ORIGIN = 0xFFE00000, LENGTH = 2M - 4
        ROM_RESET : ORIGIN = 0xFFFFFFFC, LENGTH = 4
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .reset :
        {
                KEEP(*(.ppc405reset))
        } > ROM_RESET
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .romstartup :
        {
                _sromstartup = .;
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
                *(.got1)
                *(.got2)
                *(.eh_frame)
                . = ALIGN(0x10);
                _etext = .;
        } > RAM
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
                _sdata2 = .;
                *(.sdata2)
                *(.got.plt)
                *(.got)
                . = ALIGN(0x10);
                _edata = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(COMMON)
                *(.sbss)
                *(.sbss.*)
                /* *(.scommon) */
                /* *(.dynbss) */
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

