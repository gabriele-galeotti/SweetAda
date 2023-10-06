
ENTRY(_start)

MEMORY
{
/*
 * With dBUG, user code may start at 0x40020000 (as dBUG "help" command
 * output says), but we start at 0x40100000 (MiB-boundary for VBR alignment
 * reasons).
 */
        /* vectorarea (RWX) : ORIGIN = 0x40100000, LENGTH = 0x00000400 */
        /* code       (RWX) : ORIGIN = 0x40100400, LENGTH = 0x00003C00 */
        SDRAM  (RWX) : ORIGIN = 0x40100000, LENGTH = 0x00100000 /* 32M - 0x100000 */
        RAMBAR (RWX) : ORIGIN = 0x80000000, LENGTH = 32k
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /* dummy initializations
        .vectorarea: { } > vectorarea
        .code:       { } > code
        .sdram:      { } > SDRAM
        */
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /*
        .vectors :
        {
                *(.vectors)
                . = ALIGN(0x10);
        } > SDRAM
        */
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                *(.vectors)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                . = ALIGN(0x10);
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data :
        {
                *(.data)
                *(.data.*)
                . = ALIGN(0x10);
                *(.sdata)
                . = ALIGN(0x10);
                __SDA_BASE = .;
                . = ALIGN(0x10);
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss :
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

