
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
                *(.startup)
                *(.text)
                *(.text.*)
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
        .debug_aranges  : { obj/startup.o(.debug_aranges) *(.debug_aranges) }
        .debug_line     : { *(.debug_line) }
        .debug_line_str : { *(.debug_line_str) }
        .debug_info     : { *(.debug_info) }
        .debug_abbrev   : { *(.debug_abbrev) }
        .debug_str      : { *(.debug_str) }
        .debug_loclists : { *(.debug_loclists) }
        .debug_rnglists : { *(.debug_rnglists) }
        .debug_frame    : { *(.debug_frame) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(.comment)
        }
}

