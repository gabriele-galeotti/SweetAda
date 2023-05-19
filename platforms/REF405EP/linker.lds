
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
                . = ALIGN(4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
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

