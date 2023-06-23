
ENTRY(_start)

MEMORY
{
        /* RAM @ 0x08000000, memory aliased @ 0xC0000000 */
        RAM (RWX) : ORIGIN = 0xC8000000, LENGTH = 128M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text : ALIGN(4)
        {
                _stext = .;
                KEEP(*(.vectors))
                *(.startup)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                . = ALIGN(4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(16);
                _etext = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data : ALIGN(16)
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.sdata)
                PROVIDE(_gp = ALIGN(4) + 0x7FF0);
                *(.sdata.*)
                . = ALIGN(16);
                _edata = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) : ALIGN(16)
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
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

