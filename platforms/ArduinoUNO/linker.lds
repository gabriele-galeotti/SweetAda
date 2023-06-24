
ENTRY(_start)

MEMORY
{
        ROM : ORIGIN = 0x0000, LENGTH = 0x8000
        RAM : ORIGIN = 0x800100, LENGTH = 0x0800
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = .;
                *(.vectors)
                *(.startup)
                *(.text)
                *(.text.*)
                /* *(.rodata) */
                /* *(.rodata.*) */
                *(.eh_frame)
                . = ALIGN(0x2);
                _etext = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data : AT(_etext)
        {
                _sdata = .;
                *(.rodata)
                *(.rodata.*)
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
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(.sbss)
                *(.sbss.*)
                *(.dynbss)
                *(COMMON)
                *(.scommon)
                . = ALIGN(0x10);
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     0 : { *(.debug_info) }
        .debug_abbrev   0 : { *(.debug_abbrev) }
        .debug_aranges  0 : { obj/startup.o(.debug_aranges) *(.debug_aranges) }
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

