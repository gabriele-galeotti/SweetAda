
ENTRY(_start)

MEMORY
{
        /*
         * From dBUG, "User code may start at address 0x00020000", but we
         * start at 1st MiB boundary due to vector table and VBR issues.
         * dBUG commands:
         * dBUG> dl 100000
         * dBUG> go 100400
         */
        SDRAM  : ORIGIN = 0x00100000, LENGTH = (16M - 1M)
        RAMBAR : ORIGIN = 0x80000000, LENGTH = 32K
        ROM    : ORIGIN = 0xFFE00000, LENGTH = 2M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        __FLASHROM      = 0xFFE00000;
        __FLASHROM_SIZE = 0x00200000;
        __SDRAM         = 0x00000000;
        __SDRAM_SIZE    = 0x01000000;
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
                *(.gnu.linkonce.t.*)
                *(.gnu.linkonce.r.*)
                . = ALIGN(0x10);
                _etext = .;
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data :
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.gnu.linkonce.d.*)
                *(.gcc_except_table)
                . = ALIGN(0x10);
                _edata = .;
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _bss_start = .;
                *(.bss)
                *(.bss.*)
                *(COMMON)
                *(.gnu.linkonce.b.*)
                . = ALIGN(0x10);
                _end = .;
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(.comment)
        }
}

