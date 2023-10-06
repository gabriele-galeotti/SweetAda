
ENTRY(_start)

MEMORY
{
        ROM   : ORIGIN = 0x00FC0000, LENGTH = 256k - 16
        ROMAV : ORIGIN = 0x00FFFFF0, LENGTH = 16
        /* CHIPRAM */
        RAM   : ORIGIN = 0x00000000, LENGTH = 1M
        /* FASTRAM */
        /* RAM   : ORIGIN = 0x00200000, LENGTH = 1M */
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
                KEEP(*(.vectors))
                _evectors = .;
                *(.startup)
                . = ALIGN(0x10);
                _eromstartup = .;
        } > ROM
        /**********************************************************************
         * IACK CYCLE for 68010                                               *
         **********************************************************************/
        .autovectors :
        {
                BYTE(0x00); BYTE(0x00);
                BYTE(0x00); BYTE(0x19);
                BYTE(0x00); BYTE(0x1A);
                BYTE(0x00); BYTE(0x1B);
                BYTE(0x00); BYTE(0x1C);
                BYTE(0x00); BYTE(0x1D);
                BYTE(0x00); BYTE(0x1E);
                BYTE(0x00); BYTE(0x1F);
        } > ROMAV
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
                . = ALIGN(0x4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(0x10);
                _etext = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        _data_start = _eromstartup + SIZEOF(.text);
        .data : AT(_data_start)
        {
                _sdata = .;
                *(.data)
                *(.data.*)
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
                . = ALIGN(0x10);
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /* DWARF 1 */
        .debug             0 : { *(.debug) }
        .line              0 : { *(.line) }
        /* GNU DWARF 1 extensions */
        .debug_srcinfo     0 : { *(.debug_srcinfo) }
        .debug_sfnames     0 : { *(.debug_sfnames) }
        /* DWARF 1.1 and DWARF 2 */
        .debug_aranges     0 : { *(.debug_aranges) }
        .debug_pubnames    0 : { *(.debug_pubnames) }
        /* DWARF 2 */
        .debug_info        0 : { *(.debug_info .gnu.linkonce.wi.*) }
        .debug_abbrev      0 : { *(.debug_abbrev) }
        .debug_line        0 : { *(.debug_line .debug_line.* .debug_line_end ) }
        .debug_frame       0 : { *(.debug_frame) }
        .debug_str         0 : { *(.debug_str) }
        .debug_loc         0 : { *(.debug_loc) }
        .debug_macinfo     0 : { *(.debug_macinfo) }
        /* SGI/MIPS DWARF 2 extensions */
        .debug_weaknames   0 : { *(.debug_weaknames) }
        .debug_funcnames   0 : { *(.debug_funcnames) }
        .debug_typenames   0 : { *(.debug_typenames) }
        .debug_varnames    0 : { *(.debug_varnames) }
        /* DWARF 3 */
        .debug_pubtypes    0 : { *(.debug_pubtypes) }
        .debug_ranges      0 : { *(.debug_ranges) }
        /* DWARF 5 */
        .debug_addr        0 : { *(.debug_addr) }
        .debug_line_str    0 : { *(.debug_line_str) }
        .debug_loclists    0 : { *(.debug_loclists) }
        .debug_macro       0 : { *(.debug_macro) }
        .debug_names       0 : { *(.debug_names) }
        .debug_rnglists    0 : { *(.debug_rnglists) }
        .debug_str_offsets 0 : { *(.debug_str_offsets) }
        .debug_sup         0 : { *(.debug_sup) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

