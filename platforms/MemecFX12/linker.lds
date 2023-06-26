
ENTRY(_start)

MEMORY
{
        SDRAM : ORIGIN = 0x00000000, LENGTH = 64M
        BRAM  : ORIGIN = 0xFFFFE000, LENGTH = 8k /* xps_bram_if_cntlr_1 */
}

PROVIDE(_brk_end = 16K) ;

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = .;
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.sdata*)
                _etext = .;
                . = 0x1FFC;
                *(.reset)
                . = ALIGN(0x10);
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data (NOLOAD) :
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                . = ALIGN(0x10);
                _edata = .;
        } > SDRAM
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
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
/*
        .rela.dyn (NOLOAD) :
        {
                *(.rela.init)
                . = ALIGN(0x10);
        }
*/
/*
        .text :
        {
                _stext = .;
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.sdata*)
                _etext = .;
                . = 0x1FFC;
                *(.reset)
                . = ALIGN(0x10);
        } > BRAM
*/
/*
        .reset 0xFFFFFFFC :
        {
                *(.reset)
        }
*/
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

