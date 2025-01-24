-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ neorv32.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package NEORV32
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   -- 2.7.9. General Purpose Input and Output Port (GPIO)

   type GPIO_Type is record
      INPUT_LO  : Bitmap_32 with Volatile_Full_Access => True;
      INPUT_HI  : Bitmap_32 with Volatile_Full_Access => True;
      OUTPUT_LO : Bitmap_32 with Volatile_Full_Access => True;
      OUTPUT_HI : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for GPIO_Type use record
      INPUT_LO  at 16#0# range 0 .. 31;
      INPUT_HI  at 16#4# range 0 .. 31;
      OUTPUT_LO at 16#8# range 0 .. 31;
      OUTPUT_HI at 16#C# range 0 .. 31;
   end record;

   GPIO_ADDRESS : constant := 16#FFFF_FC00#;

   GPIO : aliased GPIO_Type
      with Address    => System'To_Address (GPIO_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.10. Cyclic Redundancy Check (CRC)

   CRC_MODE_CRC8  : constant := 2#00#; -- CRC8
   CRC_MODE_CRC16 : constant := 2#01#; -- CRC16
   CRC_MODE_CRC32 : constant := 2#10#; -- CRC32

   type CRC_CTRL_Type is record
      MODE     : Bits_2;       -- CRC mode select
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CRC_CTRL_Type use record
      MODE     at 0 range 0 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   type CRC_DATA_Type is record
      DATA     : Unsigned_8;      -- data input
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CRC_DATA_Type use record
      DATA     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   type CRC_Type is record
      CTRL : CRC_CTRL_Type with Volatile_Full_Access => True;
      POLY : Unsigned_32   with Volatile_Full_Access => True;
      DATA : CRC_DATA_Type with Volatile_Full_Access => True;
      SREG : Unsigned_32   with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for CRC_Type use record
      CTRL at 16#0# range 0 .. 31;
      POLY at 16#4# range 0 .. 31;
      DATA at 16#8# range 0 .. 31;
      SREG at 16#C# range 0 .. 31;
   end record;

   CRC_BASEADDRESS : constant := 16#FFFF_EE00#;

   CRC : aliased CRC_Type
      with Address    => System'To_Address (CRC_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.11. Watchdog Timer (WDT)

   WDT_CTRL_RCAUSE_EXTRST : constant := 2#00#; -- external reset
   WDT_CTRL_RCAUSE_OCDRST : constant := 2#01#; -- ocd-reset
   WDT_CTRL_RCAUSE_WDTRST : constant := 2#10#; -- watchdog reset

   type WDT_CTRL_Type is record
      WDT_CTRL_EN      : Boolean;      -- watchdog enable
      WDT_CTRL_LOCK    : Boolean;      -- lock configuration
      WDT_CTRL_DBEN    : Boolean;      -- set to allow WDT to continue operation even when CPU is in debug mode
      WDT_CTRL_SEN     : Boolean;      -- set to allow WDT to continue operation even when CPU is in sleep mode
      WDT_CTRL_STRICT  : Boolean;      -- set to enable strict mode
      WDT_CTRL_RCAUSE  : Bits_2;       -- cause of last system reset
      Reserved         : Bits_1  := 0;
      WDT_CTRL_TIMEOUT : Bits_24;      -- 24-bit watchdog timeout value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for WDT_CTRL_Type use record
      WDT_CTRL_EN      at 0 range 0 ..  0;
      WDT_CTRL_LOCK    at 0 range 1 ..  1;
      WDT_CTRL_DBEN    at 0 range 2 ..  2;
      WDT_CTRL_SEN     at 0 range 3 ..  3;
      WDT_CTRL_STRICT  at 0 range 4 ..  4;
      WDT_CTRL_RCAUSE  at 0 range 5 ..  6;
      Reserved         at 0 range 7 ..  7;
      WDT_CTRL_TIMEOUT at 0 range 8 .. 31;
   end record;

   WDT_RESET_PASSWORD : constant := 16#709D_1AB3#;

   type WDT_Type is record
      CTRL  : WDT_CTRL_Type with Volatile_Full_Access => True;
      RESET : Unsigned_32   with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for WDT_Type use record
      CTRL  at 0 range 0 .. 31;
      RESET at 4 range 0 .. 31;
   end record;

   WDT_ADDRESS : constant := 16#FFFF_FB00#;

   WDT : aliased WDT_Type
      with Address    => System'To_Address (WDT_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.13. Primary Universal Asynchronous Receiver and Transmitter (UART0)
   -- 2.7.14. Secondary Universal Asynchronous Receiver and Transmitter (UART1)

   type UART_CTRL_Type is record
      UART_CTRL_EN            : Boolean;      -- UART global enable
      UART_CTRL_SIM_MODE      : Boolean;      -- Simulation output override enable
      UART_CTRL_HWFC_EN       : Boolean;      -- Enable RTS/CTS hardware flow-control
      UART_CTRL_PRSC          : Bits_3;       -- clock prescaler select
      UART_CTRL_BAUD          : Bits_10;      -- BAUD rate divisor
      UART_CTRL_RX_NEMPTY     : Boolean;      -- RX FIFO not empty
      UART_CTRL_RX_HALF       : Boolean;      -- RX FIFO at least half-full
      UART_CTRL_RX_FULL       : Boolean;      -- RX FIFO full
      UART_CTRL_TX_EMPTY      : Boolean;      -- TX FIFO empty
      UART_CTRL_TX_NHALF      : Boolean;      -- TX FIFO not at least half-full
      UART_CTRL_TX_FULL       : Boolean;      -- TX FIFO full
      UART_CTRL_IRQ_RX_NEMPTY : Boolean;      -- Fire IRQ if RX FIFO not empty
      UART_CTRL_IRQ_RX_HALF   : Boolean;      -- Fire IRQ if RX FIFO at least half-full
      UART_CTRL_IRQ_RX_FULL   : Boolean;      -- Fire IRQ if RX FIFO full
      UART_CTRL_IRQ_TX_EMPTY  : Boolean;      -- Fire IRQ if TX FIFO empty
      UART_CTRL_IRQ_TX_NHALF  : Boolean;      -- Fire IRQ if TX FIFO not at least half-full
      Reserved                : Bits_3  := 0;
      UART_CTRL_RX_OVER       : Boolean;      -- RX FIFO overflow
      UART_CTRL_TX_BUSY       : Boolean;      -- Transmitter busy or TX FIFO not empty
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for UART_CTRL_Type use record
      UART_CTRL_EN            at 0 range  0 ..  0;
      UART_CTRL_SIM_MODE      at 0 range  1 ..  1;
      UART_CTRL_HWFC_EN       at 0 range  2 ..  2;
      UART_CTRL_PRSC          at 0 range  3 ..  5;
      UART_CTRL_BAUD          at 0 range  6 .. 15;
      UART_CTRL_RX_NEMPTY     at 0 range 16 .. 16;
      UART_CTRL_RX_HALF       at 0 range 17 .. 17;
      UART_CTRL_RX_FULL       at 0 range 18 .. 18;
      UART_CTRL_TX_EMPTY      at 0 range 19 .. 19;
      UART_CTRL_TX_NHALF      at 0 range 20 .. 20;
      UART_CTRL_TX_FULL       at 0 range 21 .. 21;
      UART_CTRL_IRQ_RX_NEMPTY at 0 range 22 .. 22;
      UART_CTRL_IRQ_RX_HALF   at 0 range 23 .. 23;
      UART_CTRL_IRQ_RX_FULL   at 0 range 24 .. 24;
      UART_CTRL_IRQ_TX_EMPTY  at 0 range 25 .. 25;
      UART_CTRL_IRQ_TX_NHALF  at 0 range 26 .. 26;
      Reserved                at 0 range 27 .. 29;
      UART_CTRL_RX_OVER       at 0 range 30 .. 30;
      UART_CTRL_TX_BUSY       at 0 range 31 .. 31;
   end record;

   type UART_DATA_Type is record
      UART_DATA_RTX          : Unsigned_8;      -- UART receive/transmit data
      UART_DATA_RX_FIFO_SIZE : Bits_4     := 0; -- log2(RX FIFO size)
      UART_DATA_TX_FIFO_SIZE : Bits_4     := 0; -- log2(TX FIFO size)
      Reserved               : Bits_16    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for UART_DATA_Type use record
      UART_DATA_RTX          at 0 range  0 ..  7;
      UART_DATA_RX_FIFO_SIZE at 0 range  8 .. 11;
      UART_DATA_TX_FIFO_SIZE at 0 range 12 .. 15;
      Reserved               at 0 range 16 .. 31;
   end record;

   type UART_Type is record
      CTRL : UART_CTRL_Type with Volatile_Full_Access => True;
      DATA : UART_DATA_Type with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for UART_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   UART0_BASEADDRESS : constant := 16#FFFF_F500#;

   UART0 : aliased UART_Type
      with Address    => System'To_Address (UART0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART1_BASEADDRESS : constant := 16#FFFF_F600#;

   UART1 : aliased UART_Type
      with Address    => System'To_Address (UART1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.15. Serial Peripheral Interface Controller (SPI)

   SPI_CTRL_CPHA_1ST : constant := 0; -- the first clock transition is the first data capture edge
   SPI_CTRL_CPHA_2ND : constant := 1; -- the second clock transition is the first data capture edge

   SPI_CTRL_CPOL_LO : constant := 0; -- steady low value on CLK pin outside transmission window
   SPI_CTRL_CPOL_HI : constant := 1; -- steady high value on CLK pin outside transmission window

   SPI_CTRL_CS_SEL_0 : constant := 0; -- dedicated chip select #0
   SPI_CTRL_CS_SEL_1 : constant := 1; -- dedicated chip select #1
   SPI_CTRL_CS_SEL_2 : constant := 2; -- dedicated chip select #2
   SPI_CTRL_CS_SEL_3 : constant := 3; -- dedicated chip select #3
   SPI_CTRL_CS_SEL_4 : constant := 4; -- dedicated chip select #4
   SPI_CTRL_CS_SEL_5 : constant := 5; -- dedicated chip select #5
   SPI_CTRL_CS_SEL_6 : constant := 6; -- dedicated chip select #6
   SPI_CTRL_CS_SEL_7 : constant := 7; -- dedicated chip select #7

   SPI_CTRL_PRSC_2   : constant := 2#000#; -- Resulting clock_prescaler = 2
   SPI_CTRL_PRSC_4   : constant := 2#001#; -- Resulting clock_prescaler = 4
   SPI_CTRL_PRSC_8   : constant := 2#010#; -- Resulting clock_prescaler = 8
   SPI_CTRL_PRSC_64  : constant := 2#011#; -- Resulting clock_prescaler = 64
   SPI_CTRL_PRSC_128 : constant := 2#100#; -- Resulting clock_prescaler = 128
   SPI_CTRL_PRSC_1k  : constant := 2#101#; -- Resulting clock_prescaler = 1024
   SPI_CTRL_PRSC_2k  : constant := 2#110#; -- Resulting clock_prescaler = 2048
   SPI_CTRL_PRSC_4k  : constant := 2#111#; -- Resulting clock_prescaler = 4096

   type SPI_CTRL_Type is record
      SPI_CTRL_EN           : Boolean;          -- SPI module enable
      SPI_CTRL_CPHA         : Bits_1;           -- clock phase
      SPI_CTRL_CPOL         : Bits_1;           -- clock polarity
      SPI_CTRL_CS_SEL       : Bits_3;           -- Direct chip-select 0..7
      SPI_CTRL_CS_EN        : Boolean;          -- Direct chip-select enable
      SPI_CTRL_PRSC         : Bits_3;           -- 3-bit clock prescaler select
      SPI_CTRL_CDIV         : Bits_4;           -- 4-bit clock divider for fine-tuning
      SPI_CTRL_HIGHSPEED    : Boolean;          -- high-speed mode enable (overriding SPI_CTRL_PRSC)
      Reserved1             : Bits_1  := 0;
      SPI_CTRL_RX_AVAIL     : Boolean := False; -- RX FIFO data available (RX FIFO not empty)
      SPI_CTRL_TX_EMPTY     : Boolean := False; -- TX FIFO empty
      SPI_CTRL_TX_NHALF     : Boolean := False; -- TX FIFO not at least half full
      SPI_CTRL_TX_FULL      : Boolean := False; -- TX FIFO full
      SPI_CTRL_IRQ_RX_AVAIL : Boolean;          -- Trigger IRQ if RX FIFO not empty
      SPI_CTRL_IRQ_TX_EMPTY : Boolean;          -- Trigger IRQ if TX FIFO empty
      SPI_CTRL_IRQ_TX_NHALF : Boolean;          -- Trigger IRQ if TX FIFO not at least half full
      SPI_CTRL_IRQ_IDLE     : Boolean;          -- Trigger IRQ if TX FIFO is empty and SPI bus engine is idle
      SPI_CTRL_FIFO         : Bits_4  := 0;     -- FIFO depth; log2(IO_SPI_FIFO)
      Reserved2             : Bits_3  := 0;
      SPI_CTRL_BUSY         : Boolean := False; -- SPI module busy when set
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPI_CTRL_Type use record
      SPI_CTRL_EN           at 0 range  0 ..  0;
      SPI_CTRL_CPHA         at 0 range  1 ..  1;
      SPI_CTRL_CPOL         at 0 range  2 ..  2;
      SPI_CTRL_CS_SEL       at 0 range  3 ..  5;
      SPI_CTRL_CS_EN        at 0 range  6 ..  6;
      SPI_CTRL_PRSC         at 0 range  7 ..  9;
      SPI_CTRL_CDIV         at 0 range 10 .. 13;
      SPI_CTRL_HIGHSPEED    at 0 range 14 .. 14;
      Reserved1             at 0 range 15 .. 15;
      SPI_CTRL_RX_AVAIL     at 0 range 16 .. 16;
      SPI_CTRL_TX_EMPTY     at 0 range 17 .. 17;
      SPI_CTRL_TX_NHALF     at 0 range 18 .. 18;
      SPI_CTRL_TX_FULL      at 0 range 19 .. 19;
      SPI_CTRL_IRQ_RX_AVAIL at 0 range 20 .. 20;
      SPI_CTRL_IRQ_TX_EMPTY at 0 range 21 .. 21;
      SPI_CTRL_IRQ_TX_NHALF at 0 range 22 .. 22;
      SPI_CTRL_IRQ_IDLE     at 0 range 23 .. 23;
      SPI_CTRL_FIFO         at 0 range 24 .. 27;
      Reserved2             at 0 range 28 .. 30;
      SPI_CTRL_BUSY         at 0 range 31 .. 31;
   end record;

   type SPI_Type is record
      CTRL : UART_CTRL_Type with Volatile_Full_Access => True;
      DATA : Unsigned_8     with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for SPI_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 ..  7;
   end record;

   SPI_BASEADDRESS : constant := 16#FFFF_F800#;

   SPI : aliased SPI_Type
      with Address    => System'To_Address (SPI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.23. External Interrupt Controller (XIRQ)

   XIRQ_NONE : constant := 0;
   XIRQ_CH0  : constant := 2**0;
   XIRQ_CH1  : constant := 2**1;
   XIRQ_CH2  : constant := 2**2;
   XIRQ_CH3  : constant := 2**3;
   XIRQ_CH4  : constant := 2**4;
   XIRQ_CH5  : constant := 2**5;
   XIRQ_CH6  : constant := 2**6;
   XIRQ_CH7  : constant := 2**7;
   XIRQ_CH8  : constant := 2**8;
   XIRQ_CH9  : constant := 2**9;
   XIRQ_CH10 : constant := 2**10;
   XIRQ_CH11 : constant := 2**11;
   XIRQ_CH12 : constant := 2**12;
   XIRQ_CH13 : constant := 2**13;
   XIRQ_CH14 : constant := 2**14;
   XIRQ_CH15 : constant := 2**15;
   XIRQ_CH16 : constant := 2**16;
   XIRQ_CH17 : constant := 2**17;
   XIRQ_CH18 : constant := 2**18;
   XIRQ_CH19 : constant := 2**19;
   XIRQ_CH20 : constant := 2**20;
   XIRQ_CH21 : constant := 2**21;
   XIRQ_CH22 : constant := 2**22;
   XIRQ_CH23 : constant := 2**23;
   XIRQ_CH24 : constant := 2**24;
   XIRQ_CH25 : constant := 2**25;
   XIRQ_CH26 : constant := 2**26;
   XIRQ_CH27 : constant := 2**27;
   XIRQ_CH28 : constant := 2**28;
   XIRQ_CH29 : constant := 2**29;
   XIRQ_CH30 : constant := 2**30;
   XIRQ_CH31 : constant := 2**31;
   XIRQ_ALL  : constant := 16#FFFF_FFFF#;

   -- EIE External interrupt enable register

   EIE_ADDRESS : constant := 16#FFFF_F300#;

   EIE : aliased Bits_32
      with Address              => System'To_Address (EIE_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   procedure EIE_Read
      (XIRQ_CH : out Bits_32)
      with Inline => True;

   procedure EIE_Enable
      (XIRQ_CH : in Bits_32)
      with Inline => True;

   procedure EIE_Disable
      (XIRQ_CH : in Bits_32)
      with Inline => True;

   -- EIP External interrupt pending register

   EIP_ADDRESS : constant := 16#FFFF_F304#;

   EIP : aliased Bits_32
      with Address              => System'To_Address (EIP_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   procedure EIP_Read
      (XIRQ_CH : out Bits_32)
      with Inline => True;

   procedure EIP_Clear
      (XIRQ_CH : in Bits_32)
      with Inline => True;

   -- ESC Interrupt source ID

   ESC_ADDRESS : constant := 16#FFFF_F308#;

   ESC : aliased Bits_32
      with Address              => System'To_Address (ESC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   procedure ESC_Read
      (XIRQ_CH : out Bits_32)
      with Inline => True;

   procedure ESC_Ack
      (XIRQ_CH : in Bits_32)
      with Inline => True;

   -- 2.7.26. System Configuration Information Memory (SYSINFO)

   type SYSINFO_MEM_Type is record
      IMEM     : Unsigned_8; -- log2(internal IMEM size in bytes), via top’s MEM_INT_IMEM_SIZE generic
      DMEM     : Unsigned_8; -- log2(internal DMEM size in bytes), via top’s MEM_INT_DMEM_SIZE generic
      Reserved : Bits_8;
      RVSG     : Unsigned_8; -- log2(reservation set size granularity in bytes), via top’s AMO_RVS_GRANULARITY generic
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSINFO_MEM_Type use record
      IMEM     at 0 range  0 ..  7;
      DMEM     at 0 range  8 .. 15;
      Reserved at 0 range 16 .. 23;
      RVSG     at 0 range 24 .. 31;
   end record;

   type SYSINFO_SOC_Type is record
      SYSINFO_SOC_BOOTLOADER   : Boolean; -- set if processor-internal bootloader is implemented (via top’s INT_BOOTLOADER_EN generic)
      SYSINFO_SOC_XBUS         : Boolean; -- set if external Wishbone bus interface is implemented (via top’s XBUS_EN generic)
      SYSINFO_SOC_MEM_INT_IMEM : Boolean; -- set if processor-internal DMEM implemented (via top’s MEM_INT_DMEM_EN generic)
      SYSINFO_SOC_MEM_INT_DMEM : Boolean; -- set if processor-internal IMEM is implemented (via top’s MEM_INT_IMEM_EN generic)
      SYSINFO_SOC_OCD          : Boolean; -- set if on-chip debugger is implemented (via top’s ON_CHIP_DEBUGGER_EN generic)
      SYSINFO_SOC_ICACHE       : Boolean; -- set if processor-internal instruction cache is implemented (via top’s ICACHE_EN generic)
      SYSINFO_SOC_DCACHE       : Boolean; -- set if processor-internal data cache is implemented (via top’s DCACHE_EN generic)
      SYSINFO_SOC_CLOCK_GATING : Boolean; -- set if CPU clock gating is implemented (via top’s CLOCK_GATING_EN generic)
      SYSINFO_SOC_XBUS_CACHE   : Boolean; -- set if external bus interface cache is implemented (via top’s XBUS_CACHE_EN generic)
      SYSINFO_SOC_XIP          : Boolean; -- set if XIP module is implemented (via top’s XIP_EN generic)
      SYSINFO_SOC_XIP_CACHE    : Boolean; -- set if XIP cache is implemented (via top’s XIP_CACHE_EN generic)
      Reserved                 : Bits_3;
      SYSINFO_SOC_IO_DMA       : Boolean; -- set if direct memory access controller is implemented (via top’s IO_DMA_EN generic)
      SYSINFO_SOC_IO_GPIO      : Boolean; -- set if GPIO is implemented (via top’s IO_GPIO_EN generic)
      SYSINFO_SOC_IO_MTIME     : Boolean; -- set if MTIME is implemented (via top’s IO_MTIME_EN generic)
      SYSINFO_SOC_IO_UART0     : Boolean; -- set if primary UART0 is implemented (via top’s IO_UART0_EN generic)
      SYSINFO_SOC_IO_SPI       : Boolean; -- set if SPI is implemented (via top’s IO_SPI_EN generic)
      SYSINFO_SOC_IO_TWI       : Boolean; -- set if TWI is implemented (via top’s IO_TWI_EN generic)
      SYSINFO_SOC_IO_PWM       : Boolean; -- set if PWM is implemented (via top’s IO_PWM_NUM_CH generic)
      SYSINFO_SOC_IO_WDT       : Boolean; -- set if WDT is implemented (via top’s IO_WDT_EN generic)
      SYSINFO_SOC_IO_CFS       : Boolean; -- set if custom functions subsystem is implemented (via top’s IO_CFS_EN generic)
      SYSINFO_SOC_IO_TRNG      : Boolean; -- set if TRNG is implemented (via top’s IO_TRNG_EN generic)
      SYSINFO_SOC_IO_SDI       : Boolean; -- set if SDI is implemented (via top’s IO_SDI_EN generic)
      SYSINFO_SOC_IO_UART1     : Boolean; -- set if secondary UART1 is implemented (via top’s IO_UART1_EN generic)
      SYSINFO_SOC_IO_NEOLED    : Boolean; -- set if NEOLED is implemented (via top’s IO_NEOLED_EN generic)
      SYSINFO_SOC_IO_XIRQ      : Boolean; -- set if XIRQ is implemented (via top’s XIRQ_NUM_CH generic)
      SYSINFO_SOC_IO_GPTMR     : Boolean; -- set if GPTMR is implemented (via top’s IO_GPTMR_EN generic)
      SYSINFO_SOC_IO_SLINK     : Boolean; -- set if stream link interface is implemented (via top’s IO_SLINK_EN generic)
      SYSINFO_SOC_IO_ONEWIRE   : Boolean; -- set if ONEWIRE interface is implemented (via top’s IO_ONEWIRE_EN generic)
      SYSINFO_SOC_IO_CRC       : Boolean; -- set if cyclic redundancy check unit is implemented (via top’s IO_CRC_EN generic)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSINFO_SOC_Type use record
      SYSINFO_SOC_BOOTLOADER   at 0 range  0 ..  0;
      SYSINFO_SOC_XBUS         at 0 range  1 ..  1;
      SYSINFO_SOC_MEM_INT_IMEM at 0 range  2 ..  2;
      SYSINFO_SOC_MEM_INT_DMEM at 0 range  3 ..  3;
      SYSINFO_SOC_OCD          at 0 range  4 ..  4;
      SYSINFO_SOC_ICACHE       at 0 range  5 ..  5;
      SYSINFO_SOC_DCACHE       at 0 range  6 ..  6;
      SYSINFO_SOC_CLOCK_GATING at 0 range  7 ..  7;
      SYSINFO_SOC_XBUS_CACHE   at 0 range  8 ..  8;
      SYSINFO_SOC_XIP          at 0 range  9 ..  9;
      SYSINFO_SOC_XIP_CACHE    at 0 range 10 .. 10;
      Reserved                 at 0 range 11 .. 13;
      SYSINFO_SOC_IO_DMA       at 0 range 14 .. 14;
      SYSINFO_SOC_IO_GPIO      at 0 range 15 .. 15;
      SYSINFO_SOC_IO_MTIME     at 0 range 16 .. 16;
      SYSINFO_SOC_IO_UART0     at 0 range 17 .. 17;
      SYSINFO_SOC_IO_SPI       at 0 range 18 .. 18;
      SYSINFO_SOC_IO_TWI       at 0 range 19 .. 19;
      SYSINFO_SOC_IO_PWM       at 0 range 20 .. 20;
      SYSINFO_SOC_IO_WDT       at 0 range 21 .. 21;
      SYSINFO_SOC_IO_CFS       at 0 range 22 .. 22;
      SYSINFO_SOC_IO_TRNG      at 0 range 23 .. 23;
      SYSINFO_SOC_IO_SDI       at 0 range 24 .. 24;
      SYSINFO_SOC_IO_UART1     at 0 range 25 .. 25;
      SYSINFO_SOC_IO_NEOLED    at 0 range 26 .. 26;
      SYSINFO_SOC_IO_XIRQ      at 0 range 27 .. 27;
      SYSINFO_SOC_IO_GPTMR     at 0 range 28 .. 28;
      SYSINFO_SOC_IO_SLINK     at 0 range 29 .. 29;
      SYSINFO_SOC_IO_ONEWIRE   at 0 range 30 .. 30;
      SYSINFO_SOC_IO_CRC       at 0 range 31 .. 31;
   end record;

   type SYSINFO_CACHE_Type is record
      SYSINFO_CACHE_INST_BLOCK_SIZE : Bits_4; -- log2(i-cache block size in bytes), via top’s ICACHE_BLOCK_SIZE generic
      SYSINFO_CACHE_INST_NUM_BLOCKS : Bits_4; -- log2(i-cache number of cache blocks), via top’s ICACHE_NUM_BLOCKS generic
      SYSINFO_CACHE_DATA_BLOCK_SIZE : Bits_4; -- log2(d-cache block size in bytes), via top’s DCACHE_BLOCK_SIZE generic
      SYSINFO_CACHE_DATA_NUM_BLOCKS : Bits_4; -- log2(d-cache number of cache blocks), via top’s DCACHE_NUM_BLOCKS generic
      SYSINFO_CACHE_XIP_BLOCK_SIZE  : Bits_4; -- log2(xip-cache block size in bytes), via top’s XIP_CACHE_BLOCK_SIZE generic
      SYSINFO_CACHE_XIP_NUM_BLOCKS  : Bits_4; -- log2(xip-cache number of cache blocks), via top’s XIP_CACHE_NUM_BLOCKS generic
      SYSINFO_CACHE_XBUS_BLOCK_SIZE : Bits_4; -- log2(xbus-cache block size in bytes), via top’s XBUS_CACHE_BLOCK_SIZE generic
      SYSINFO_CACHE_XBUS_NUM_BLOCKS : Bits_4; -- log2(xbus-cache number of cache blocks), via top’s XBUS_CACHE_NUM_BLOCKS generic
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYSINFO_CACHE_Type use record
      SYSINFO_CACHE_INST_BLOCK_SIZE at 0 range  0 ..  3;
      SYSINFO_CACHE_INST_NUM_BLOCKS at 0 range  4 ..  7;
      SYSINFO_CACHE_DATA_BLOCK_SIZE at 0 range  8 .. 11;
      SYSINFO_CACHE_DATA_NUM_BLOCKS at 0 range 12 .. 15;
      SYSINFO_CACHE_XIP_BLOCK_SIZE  at 0 range 16 .. 19;
      SYSINFO_CACHE_XIP_NUM_BLOCKS  at 0 range 20 .. 23;
      SYSINFO_CACHE_XBUS_BLOCK_SIZE at 0 range 24 .. 27;
      SYSINFO_CACHE_XBUS_NUM_BLOCKS at 0 range 28 .. 31;
   end record;

   type SYSINFO_Type is record
      CLK   : Unsigned_32      with Volatile_Full_Access => True;
      MEM   : SYSINFO_MEM_Type with Volatile_Full_Access => True;
      SOC   : SYSINFO_SOC_Type with Volatile_Full_Access => True;
      CACHE : SYSINFO_MEM_Type with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for SYSINFO_Type use record
      CLK   at 16#0# range 0 .. 31;
      MEM   at 16#4# range 0 .. 31;
      SOC   at 16#8# range 0 .. 31;
      CACHE at 16#C# range 0 .. 31;
   end record;

   SYSINFO_BASEADDRESS : constant := 16#FFFF_FE00#;

   SYSINFO : aliased SYSINFO_Type
      with Address    => System'To_Address (SYSINFO_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end NEORV32;
