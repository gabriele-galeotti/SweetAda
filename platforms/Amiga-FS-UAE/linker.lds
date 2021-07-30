
ENTRY(_start)

MEMORY
{
        /* RAM: 1 MiB total ("chip memory") */
        RAM   : ORIGIN = 0x00000000, LENGTH = 512K
        VIDEO : ORIGIN = 0x00080000, LENGTH = 512K
        ROM   : ORIGIN = 0x00FC0000, LENGTH = 256K - 16
        ROMAV : ORIGIN = 0x00FFFFF0, LENGTH = 16
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
                /* *(.gnu.linkonce.t.*) */
                /* *(.gnu.linkonce.r.*) */
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
                /* *(.gnu.linkonce.d.*) */
                /* *(.gcc_except_table) */
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
                /* *(.gnu.linkonce.b.*) */
                . = ALIGN(0x10);
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(.comment)
                *(.eh_frame)
        }
}

