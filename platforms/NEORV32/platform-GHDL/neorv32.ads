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

   ----------------------------------------------------------------------------
   -- The NEORV32 RISC-V Processor - Datasheet
   -- The NEORV32 Community and Stephan Nolting stnolting@gmail.com version v1.11.8-r78-gb29cc309
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.6. Direct Memory Access Controller (DMA)
   ----------------------------------------------------------------------------

   type DMA_CTRL_Type is record
      DMA_CTRL_EN     : Boolean; -- DMA module enable; reset module when cleared
      DMA_CTRL_START  : Boolean; -- Start programmed DMA transfer(s)
      Reserved1       : Bits_14;
      DMA_CTRL_DFIFO  : Bits_4;  -- Descriptor FIFO depth, log2(IO_DMA_DSC_FIFO)
      Reserved2       : Bits_6;
      DMA_CTRL_ACK    : Boolean; -- Write 1 to clear DMA interrupt (also clears DMA_CTRL_ERROR and DMA_CTRL_DONE)
      DMA_CTRL_DEMPTY : Boolean; -- Descriptor FIFO is empty
      DMA_CTRL_DFULL  : Boolean; -- Descriptor FIFO is full
      DMA_CTRL_ERROR  : Boolean; -- Bus access error during transfer or incomplete descriptor data
      DMA_CTRL_DONE   : Boolean; -- All transfers executed
      DMA_CTRL_BUSY   : Boolean; -- DMA transfer(s) in progress
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_CTRL_Type use record
      DMA_CTRL_EN     at 0 range  0 ..  0;
      DMA_CTRL_START  at 0 range  1 ..  1;
      Reserved1       at 0 range  2 .. 15;
      DMA_CTRL_DFIFO  at 0 range 16 .. 19;
      Reserved2       at 0 range 20 .. 25;
      DMA_CTRL_ACK    at 0 range 26 .. 26;
      DMA_CTRL_DEMPTY at 0 range 27 .. 27;
      DMA_CTRL_DFULL  at 0 range 28 .. 28;
      DMA_CTRL_ERROR  at 0 range 29 .. 29;
      DMA_CTRL_DONE   at 0 range 30 .. 30;
      DMA_CTRL_BUSY   at 0 range 31 .. 31;
   end record;

   type DMA_Type is record
      CTRL : DMA_CTRL_Type with Volatile_Full_Access => True;
      DESC : Unsigned_32   with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for DMA_Type use record
      CTRL at 0 range 0 .. 31;
      DESC at 4 range 0 .. 31;
   end record;

   DMA_BASEADDRESS : constant := 16#FFED_0000#;

   DMA : aliased DMA_Type
      with Address    => System'To_Address (DMA_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.7. Processor-External Bus Interface (XBUS)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.8. Stream Link Interface (SLINK)
   ----------------------------------------------------------------------------

   type SLINK_CTRL_Type is record
      SLINK_CTRL_EN            : Boolean := False; -- SLINK global enable
      Reserved1                : Bits_7  := 0;
      SLINK_CTRL_RX_EMPTY      : Boolean := False; -- RX FIFO empty
      SLINK_CTRL_RX_FULL       : Boolean := False; -- RX FIFO full
      SLINK_CTRL_TX_EMPTY      : Boolean := False; -- TX FIFO empty
      SLINK_CTRL_TX_FULL       : Boolean := False; -- TX FIFO full
      SLINK_CTRL_RX_LAST       : Boolean := False; -- Last word read from DATA is end-of-stream
      Reserved2                : Bits_3  := 0;
      SLINK_CTRL_IRQ_RX_NEMPTY : Boolean := False; -- Fire interrupt if RX FIFO not empty
      SLINK_CTRL_IRQ_RX_FULL   : Boolean := False; -- Fire interrupt if RX FIFO full
      SLINK_CTRL_IRQ_TX_EMPTY  : Boolean := False; -- Fire interrupt if TX FIFO empty
      SLINK_CTRL_IRQ_TX_NFULL  : Boolean := False; -- Fire interrupt if TX FIFO not full
      Reserved3                : Bits_4  := 0;
      SLINK_CTRL_RX_FIFO       : Bits_4  := 0;     -- log2(RX FIFO size)
      SLINK_CTRL_TX_FIFO       : Bits_4  := 0;     -- log2(TX FIFO size)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SLINK_CTRL_Type use record
      SLINK_CTRL_EN            at 0 range  0 ..  0;
      Reserved1                at 0 range  1 ..  7;
      SLINK_CTRL_RX_EMPTY      at 0 range  8 ..  8;
      SLINK_CTRL_RX_FULL       at 0 range  9 ..  9;
      SLINK_CTRL_TX_EMPTY      at 0 range 10 .. 10;
      SLINK_CTRL_TX_FULL       at 0 range 11 .. 11;
      SLINK_CTRL_RX_LAST       at 0 range 12 .. 12;
      Reserved2                at 0 range 13 .. 15;
      SLINK_CTRL_IRQ_RX_NEMPTY at 0 range 16 .. 16;
      SLINK_CTRL_IRQ_RX_FULL   at 0 range 17 .. 17;
      SLINK_CTRL_IRQ_TX_EMPTY  at 0 range 18 .. 18;
      SLINK_CTRL_IRQ_TX_NFULL  at 0 range 19 .. 19;
      Reserved3                at 0 range 20 .. 23;
      SLINK_CTRL_RX_FIFO       at 0 range 24 .. 27;
      SLINK_CTRL_TX_FIFO       at 0 range 28 .. 31;
   end record;

   type SLINK_ROUTE_Type is record
      ROUTE    : Bits_4  := 0; -- TX destination routing information (slink_tx_dst_o) RX source routing information (slink_rx_src_i)
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SLINK_ROUTE_Type use record
      ROUTE    at 0 range 0 ..  3;
      Reserved at 0 range 4 .. 31;
   end record;

   type SLINK_Type is record
      CTRL      : SLINK_CTRL_Type  with Volatile_Full_Access => True;
      ROUTE     : SLINK_ROUTE_Type with Volatile_Full_Access => True;
      DATA      : Unsigned_32      with Volatile_Full_Access => True;
      DATA_LAST : Unsigned_32      with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for SLINK_Type use record
      CTRL      at 16#0# range 0 .. 31;
      ROUTE     at 16#4# range 0 .. 31;
      DATA      at 16#8# range 0 .. 31;
      DATA_LAST at 16#C# range 0 .. 31;
   end record;

   SLINK_BASEADDRESS : constant := 16#FFEC_0000#;

   SLINK : aliased SLINK_Type
      with Address    => System'To_Address (SLINK_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.9. General Purpose Input and Output Port (GPIO)
   ----------------------------------------------------------------------------

   type IRQ_TYPE_Type is range 0 .. 1
      with Size => 1;

   IRQ_TYPE_LEVEL : constant IRQ_TYPE_Type := 0; -- level trigger
   IRQ_TYPE_EDGE  : constant IRQ_TYPE_Type := 1; -- edge trigger

   type IRQ_TYPE_Bitmap_32 is array (0 .. 31) of IRQ_TYPE_Type
      with Component_Size => 1,
           Size           => 32;

   type IRQ_POLARITY_Type is range 0 .. 1
      with Size => 1;

   IRQ_POLARITY_LF : constant IRQ_POLARITY_Type := 0; -- low-level/falling-edge
   IRQ_POLARITY_HR : constant IRQ_POLARITY_Type := 1; -- high-level/rising-edge

   type IRQ_POLARITY_Bitmap_32 is array (0 .. 31) of IRQ_POLARITY_Type
      with Component_Size => 1,
           Size           => 32;

   type GPIO_Type is record
      PORT_IN      : Bitmap_32              with Volatile_Full_Access => True;
      PORT_OUT     : Bitmap_32              with Volatile_Full_Access => True;
      Reserved1    : Bits_32                with Volatile_Full_Access => True;
      Reserved2    : Bits_32                with Volatile_Full_Access => True;
      IRQ_TYPE     : IRQ_TYPE_Bitmap_32     with Volatile_Full_Access => True;
      IRQ_POLARITY : IRQ_POLARITY_Bitmap_32 with Volatile_Full_Access => True;
      IRQ_ENABLE   : Bitmap_32              with Volatile_Full_Access => True;
      IRQ_PENDING  : Bitmap_32              with Volatile_Full_Access => True;
   end record
      with Size => 8 * 32;
   for GPIO_Type use record
      PORT_IN      at 16#00# range 0 .. 31;
      PORT_OUT     at 16#04# range 0 .. 31;
      Reserved1    at 16#08# range 0 .. 31;
      Reserved2    at 16#0C# range 0 .. 31;
      IRQ_TYPE     at 16#10# range 0 .. 31;
      IRQ_POLARITY at 16#14# range 0 .. 31;
      IRQ_ENABLE   at 16#18# range 0 .. 31;
      IRQ_PENDING  at 16#1C# range 0 .. 31;
   end record;

   GPIO_BASEADDRESS : constant := 16#FFFC_0000#;

   GPIO : aliased GPIO_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.10. Watchdog Timer (WDT)
   ----------------------------------------------------------------------------

    type WDT_CTRL_RCAUSE_Type is new Bits_2;

    WDT_RCAUSE_EXT : constant WDT_CTRL_RCAUSE_Type := 2#00#; -- Reset caused by external reset signal pin
    WDT_RCAUSE_OCD : constant WDT_CTRL_RCAUSE_Type := 2#01#; -- Reset caused by on-chip debugger
    WDT_RCAUSE_TMO : constant WDT_CTRL_RCAUSE_Type := 2#10#; -- Reset caused by watchdog timeout
    WDT_RCAUSE_ACC : constant WDT_CTRL_RCAUSE_Type := 2#11#; -- Reset caused by illegal watchdog access

   type WDT_CTRL_Type is record
      WDT_CTRL_EN      : Boolean              := False;          -- Watchdog enable
      WDT_CTRL_LOCK    : Boolean              := False;          -- Lock configuration when set, clears only on system reset, can only be set if enable bit is set already
      WDT_CTRL_RCAUSE  : WDT_CTRL_RCAUSE_Type := WDT_RCAUSE_EXT; -- Cause of last system reset
      Reserved         : Bits_4               := 0;
      WDT_CTRL_TIMEOUT : Bits_24              := 0;              -- Timeout value (24-bit)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for WDT_CTRL_Type use record
      WDT_CTRL_EN      at 0 range 0 ..  0;
      WDT_CTRL_LOCK    at 0 range 1 ..  1;
      WDT_CTRL_RCAUSE  at 0 range 2 ..  3;
      Reserved         at 0 range 4 ..  7;
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

   WDT_BASEADDRESS : constant := 16#FFFB_0000#;

   WDT : aliased WDT_Type
      with Address    => System'To_Address (WDT_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.11. Core Local Interruptor (CLINT)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.12. Primary Universal Asynchronous Receiver and Transmitter (UART0)
   -- 2.8.13. Secondary Universal Asynchronous Receiver and Transmitter (UART1)
   ----------------------------------------------------------------------------

   UART_CTRL_PRSC_DIV2    : constant := 2#000#; -- Resulting clock_prescaler = 2
   UART_CTRL_PRSC_DIV4    : constant := 2#001#; -- Resulting clock_prescaler = 4
   UART_CTRL_PRSC_DIV8    : constant := 2#010#; -- Resulting clock_prescaler = 8
   UART_CTRL_PRSC_DIV64   : constant := 2#011#; -- Resulting clock_prescaler = 64
   UART_CTRL_PRSC_DIV128  : constant := 2#100#; -- Resulting clock_prescaler = 128
   UART_CTRL_PRSC_DIV1024 : constant := 2#101#; -- Resulting clock_prescaler = 1024
   UART_CTRL_PRSC_DIV2048 : constant := 2#110#; -- Resulting clock_prescaler = 2048
   UART_CTRL_PRSC_DIV4096 : constant := 2#111#; -- Resulting clock_prescaler = 4096

   type UART_CTRL_Type is record
      UART_CTRL_EN            : Boolean; -- UART enable
      UART_CTRL_SIM_MODE      : Boolean; -- enable simulation mode
      UART_CTRL_HWFC_EN       : Boolean; -- enable RTS/CTS hardware flow-control
      UART_CTRL_PRSC          : Bits_3;  -- Baud rate clock prescaler select
      UART_CTRL_BAUD          : Bits_10; -- 12-bit Baud value configuration value
      UART_CTRL_RX_NEMPTY     : Boolean; -- RX FIFO not empty
      UART_CTRL_RX_HALF       : Boolean; -- RX FIFO at least half-full
      UART_CTRL_RX_FULL       : Boolean; -- RX FIFO full
      UART_CTRL_TX_EMPTY      : Boolean; -- TX FIFO empty
      UART_CTRL_TX_NHALF      : Boolean; -- TX FIFO not at least half-full
      UART_CTRL_TX_NFULL      : Boolean; -- TX FIFO not full
      UART_CTRL_IRQ_RX_NEMPTY : Boolean; -- fire RX-IRQ if RX FIFO not empty
      UART_CTRL_IRQ_RX_HALF   : Boolean; -- fire RX-IRQ if RX FIFO at least half full
      UART_CTRL_IRQ_RX_FULL   : Boolean; -- fire RX-IRQ if RX FIFO full
      UART_CTRL_IRQ_TX_EMPTY  : Boolean; -- fire TX-IRQ if TX FIFO empty
      UART_CTRL_IRQ_TX_NHALF  : Boolean; -- fire TX-IRQ if TX FIFO not at least half full
      UART_CTRL_IRQ_TX_NFULL  : Boolean; -- fire TX-IRQ if TX not full
      UART_CTRL_RX_CLR        : Boolean; -- Clear RX FIFO, flag auto-clears
      UART_CTRL_TX_CLR        : Boolean; -- Clear TX FIFO, flag auto-clears
      UART_CTRL_RX_OVER       : Boolean; -- RX FIFO overflow; cleared by disabling the module
      UART_CTRL_TX_BUSY       : Boolean; -- TX busy or TX FIFO not empty
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
      UART_CTRL_TX_NFULL      at 0 range 21 .. 21;
      UART_CTRL_IRQ_RX_NEMPTY at 0 range 22 .. 22;
      UART_CTRL_IRQ_RX_HALF   at 0 range 23 .. 23;
      UART_CTRL_IRQ_RX_FULL   at 0 range 24 .. 24;
      UART_CTRL_IRQ_TX_EMPTY  at 0 range 25 .. 25;
      UART_CTRL_IRQ_TX_NHALF  at 0 range 26 .. 26;
      UART_CTRL_IRQ_TX_NFULL  at 0 range 27 .. 27;
      UART_CTRL_RX_CLR        at 0 range 28 .. 28;
      UART_CTRL_TX_CLR        at 0 range 29 .. 29;
      UART_CTRL_RX_OVER       at 0 range 30 .. 30;
      UART_CTRL_TX_BUSY       at 0 range 31 .. 31;
   end record;

   type UART_DATA_Type is record
      UART_DATA_RTX          : Unsigned_8;      -- receive/transmit data
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

   UART0_BASEADDRESS : constant := 16#FFF5_0000#;

   UART0 : aliased UART_Type
      with Address    => System'To_Address (UART0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART1_BASEADDRESS : constant := 16#FFF6_0000#;

   UART1 : aliased UART_Type
      with Address    => System'To_Address (UART1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.14. Serial Peripheral Interface Controller (SPI)
   ----------------------------------------------------------------------------

   SPI_CTRL_CPHA_LEAD  : constant := 0; -- data sampled when clock becomes active
   SPI_CTRL_CPHA_TRAIL : constant := 1; -- data sampled when clock becomes inactive

   SPI_CTRL_CPOL_LOW  : constant := 0; -- clock inactive is logic LOW
   SPI_CTRL_CPOL_HIGH : constant := 1; -- clock inactive is logic HIGH

   SPI_CTRL_PRSC_2    : constant := 2#000#; -- Resulting clock_prescaler = 2
   SPI_CTRL_PRSC_4    : constant := 2#001#; -- Resulting clock_prescaler = 4
   SPI_CTRL_PRSC_8    : constant := 2#010#; -- Resulting clock_prescaler = 8
   SPI_CTRL_PRSC_64   : constant := 2#011#; -- Resulting clock_prescaler = 64
   SPI_CTRL_PRSC_128  : constant := 2#100#; -- Resulting clock_prescaler = 128
   SPI_CTRL_PRSC_1024 : constant := 2#101#; -- Resulting clock_prescaler = 1024
   SPI_CTRL_PRSC_2048 : constant := 2#110#; -- Resulting clock_prescaler = 2048
   SPI_CTRL_PRSC_4096 : constant := 2#111#; -- Resulting clock_prescaler = 4096

   type SPI_CTRL_Type is record
      SPI_CTRL_EN       : Boolean := False;              -- SPI module enable
      SPI_CTRL_CPHA     : Bits_1  := SPI_CTRL_CPHA_LEAD; -- clock phase
      SPI_CTRL_CPOL     : Bits_1  := SPI_CTRL_CPOL_LOW;  -- clock polarity
      SPI_CTRL_PRSC     : Bits_3  := SPI_CTRL_PRSC_2;    -- 3-bit clock prescaler select
      SPI_CTRL_CDIV     : Bits_4  := 0;                  -- 4-bit clock divider for fine-tuning
      Reserved1         : Bits_6  := 0;
      SPI_CTRL_RX_AVAIL : Boolean := False;              -- RX FIFO data available (RX FIFO not empty)
      SPI_CTRL_TX_EMPTY : Boolean := False;              -- TX FIFO empty
      SPI_CTRL_TX_FULL  : Boolean := False;              -- TX FIFO full
      Reserved2         : Bits_5  := 0;
      SPI_CTRL_FIFO     : Bits_4  := 0;                  -- FIFO depth; log2(IO_SPI_FIFO)
      Reserved3         : Bits_2  := 0;
      SPI_CS_ACTIVE     : Boolean := False;              -- Set if any chip-select line is active
      SPI_CTRL_BUSY     : Boolean := False;              -- SPI module busy when set (serial engine operation in progress and TX FIFO not empty yet)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPI_CTRL_Type use record
      SPI_CTRL_EN       at 0 range  0 ..  0;
      SPI_CTRL_CPHA     at 0 range  1 ..  1;
      SPI_CTRL_CPOL     at 0 range  2 ..  2;
      SPI_CTRL_PRSC     at 0 range  3 ..  5;
      SPI_CTRL_CDIV     at 0 range  6 ..  9;
      Reserved1         at 0 range 10 .. 15;
      SPI_CTRL_RX_AVAIL at 0 range 16 .. 16;
      SPI_CTRL_TX_EMPTY at 0 range 17 .. 17;
      SPI_CTRL_TX_FULL  at 0 range 18 .. 18;
      Reserved2         at 0 range 19 .. 23;
      SPI_CTRL_FIFO     at 0 range 24 .. 27;
      Reserved3         at 0 range 28 .. 29;
      SPI_CS_ACTIVE     at 0 range 30 .. 30;
      SPI_CTRL_BUSY     at 0 range 31 .. 31;
   end record;

   type SPI_DATA_Type is record
      SPI_DATA     : Unsigned_8;          -- receive/transmit data (FIFO), only for data mode (SPI_DATA_CMD = 0) chip-select-enable (bit 3) and chip-select (bit 2:0), only for command mode (SPI_DATA_CMD = 1)
      Reserved     : Bits_23    := 0;
      SPI_DATA_CMD : Boolean    := False; -- 0 = data, 1 = chip-select-command
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPI_DATA_Type use record
      SPI_DATA     at 0 range  0 ..  7;
      Reserved     at 0 range  8 .. 30;
      SPI_DATA_CMD at 0 range 31 .. 31;
   end record;

   type SPI_Type is record
      CTRL : SPI_CTRL_Type with Volatile_Full_Access => True;
      DATA : SPI_DATA_Type with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for SPI_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   SPI_BASEADDRESS : constant := 16#FFF8_0000#;

   SPI : aliased SPI_Type
      with Address    => System'To_Address (SPI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   subtype SPI_CS_Type is Unsigned_8 range 2#000# .. 2#111#;

   SPI_CS0 : constant SPI_CS_Type := 2#000#;
   SPI_CS1 : constant SPI_CS_Type := 2#001#;
   SPI_CS2 : constant SPI_CS_Type := 2#010#;
   SPI_CS3 : constant SPI_CS_Type := 2#011#;
   SPI_CS4 : constant SPI_CS_Type := 2#100#;
   SPI_CS5 : constant SPI_CS_Type := 2#101#;
   SPI_CS6 : constant SPI_CS_Type := 2#110#;
   SPI_CS7 : constant SPI_CS_Type := 2#111#;

   -- assemble the DATA register CS bit pattern when SPI_DATA_CMD = True
   function SPI_CS
      (Enable : Boolean;
       CS     : SPI_CS_Type := SPI_CS0)
      return Unsigned_8
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 2.8.15. Serial Data Interface Controller (SDI)
   ----------------------------------------------------------------------------

   type SDI_CTRL_Type is record
      SDI_CTRL_EN            : Boolean := False; -- SDI module enable
      -- NOTE: documented as SDR_CTRL_CLR_RX
      SDI_CTRL_CLR_RX        : Boolean := False; -- clear RX FIFO, flag auto-clears
      -- NOTE: documented as SDR_CTRL_CLR_TX
      SDI_CTRL_CLR_TX        : Boolean := False; -- clear TX FIFO, flag auto-clears
      Reserved1              : Bits_1  := 0;
      SDI_CTRL_FIFO          : Bits_4  := 0;     -- FIFO depth; log2(IO_SDI_FIFO)
      Reserved2              : Bits_8  := 0;
      SDI_CTRL_IRQ_RX_NEMPTY : Boolean := False; -- fire interrupt if RX FIFO is not empty
      SDI_CTRL_IRQ_RX_FULL   : Boolean := False; -- fire interrupt if if RX FIFO is full
      SDI_CTRL_IRQ_TX_EMPTY  : Boolean := False; -- fire interrupt if TX FIFO is empty
      Reserved3              : Bits_5  := 0;
      SDI_CTRL_RX_EMPTY      : Boolean := False; -- RX FIFO empty
      SDI_CTRL_RX_FULL       : Boolean := False; -- RX FIFO full
      SDI_CTRL_TX_EMPTY      : Boolean := False; -- TX FIFO empty
      SDI_CTRL_TX_FULL       : Boolean := False; -- TX FIFO full
      Reserved4              : Bits_3  := 0;
      SDI_CTRL_CS_ACTIVE     : Boolean := False; -- Chip-select is active when set
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SDI_CTRL_Type use record
      SDI_CTRL_EN            at 0 range  0 ..  0;
      SDI_CTRL_CLR_RX        at 0 range  1 ..  1;
      SDI_CTRL_CLR_TX        at 0 range  2 ..  2;
      Reserved1              at 0 range  3 ..  3;
      SDI_CTRL_FIFO          at 0 range  4 ..  7;
      Reserved2              at 0 range  8 .. 15;
      SDI_CTRL_IRQ_RX_NEMPTY at 0 range 16 .. 16;
      SDI_CTRL_IRQ_RX_FULL   at 0 range 17 .. 17;
      SDI_CTRL_IRQ_TX_EMPTY  at 0 range 18 .. 18;
      Reserved3              at 0 range 19 .. 23;
      SDI_CTRL_RX_EMPTY      at 0 range 24 .. 24;
      SDI_CTRL_RX_FULL       at 0 range 25 .. 25;
      SDI_CTRL_TX_EMPTY      at 0 range 26 .. 26;
      SDI_CTRL_TX_FULL       at 0 range 27 .. 27;
      Reserved4              at 0 range 28 .. 30;
      SDI_CTRL_CS_ACTIVE     at 0 range 31 .. 31;
   end record;

   type SDI_DATA_Type is record
      -- NOTE: documentation does not name this field
      SDI_DATA : Unsigned_8;      -- receive/transmit data (FIFO)
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SDI_DATA_Type use record
      SDI_DATA at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   type SDI_Type is record
      CTRL : SDI_CTRL_Type with Volatile_Full_Access => True;
      DATA : SDI_DATA_Type with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for SDI_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   SDI_BASEADDRESS : constant := 16#FFF7_0000#;

   SDI : aliased SDI_Type
      with Address    => System'To_Address (SDI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.16. Two-Wire Serial Interface Controller (TWI)
   ----------------------------------------------------------------------------

   type TWI_Type is record
      CTRL : Unsigned_32 with Volatile_Full_Access => True;
      DCMD : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for TWI_Type use record
      CTRL at 0 range 0 .. 31;
      DCMD at 4 range 0 .. 31;
   end record;

   TWI_BASEADDRESS : constant := 16#FFF9_0000#;

   TWI : aliased TWI_Type
      with Address    => System'To_Address (TWI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.17. Two-Wire Serial Device Controller (TWD)
   ----------------------------------------------------------------------------

   type TWD_Type is record
      CTRL : Unsigned_32 with Volatile_Full_Access => True;
      DATA : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for TWD_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   TWD_BASEADDRESS : constant := 16#FFEA_0000#;

   TWD : aliased TWD_Type
      with Address    => System'To_Address (TWD_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.18. One-Wire Serial Interface Controller (ONEWIRE)
   ----------------------------------------------------------------------------

   type ONEWIRE_Type is record
      CTRL : Unsigned_32 with Volatile_Full_Access => True;
      DCMD : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for ONEWIRE_Type use record
      CTRL at 0 range 0 .. 31;
      DCMD at 4 range 0 .. 31;
   end record;

   ONEWIRE_BASEADDRESS : constant := 16#FFF2_0000#;

   ONEWIRE : aliased ONEWIRE_Type
      with Address    => System'To_Address (ONEWIRE_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.19. Pulse-Width Modulation Controller (PWM)
   ----------------------------------------------------------------------------

   type PWM_Channel_Type is new Unsigned_32
      with Size                 => 32,
           Volatile_Full_Access => True;

   type PWM_Type is array (0 .. 15) of PWM_Channel_Type
      with Pack => True;

   PWM_BASEADDRESS : constant := 16#FFF0_0000#;

   PWM : aliased PWM_Type
      with Address    => System'To_Address (PWM_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.20. True Random-Number Generator (TRNG)
   ----------------------------------------------------------------------------

   type TRNG_CTRL_Type is record
      TRNG_CTRL_EN       : Boolean := False; -- enable
      TRNG_CTRL_FIFO_CLR : Boolean := False; -- flush random data FIFO when set; auto-clears
      TRNG_CTRL_FIFO     : Bits_4  := 0;     -- depth, log2(IO_TRNG_FIFO)
      TRNG_CTRL_SIM_MODE : Boolean := False; -- simulation mode (PRNG!)
      TRNG_CTRL_AVAIL    : Boolean := False; -- random data available when set
      Reserved           : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TRNG_CTRL_Type use record
      TRNG_CTRL_EN       at 0 range 0 ..  0;
      TRNG_CTRL_FIFO_CLR at 0 range 1 ..  1;
      TRNG_CTRL_FIFO     at 0 range 2 ..  5;
      TRNG_CTRL_SIM_MODE at 0 range 6 ..  6;
      TRNG_CTRL_AVAIL    at 0 range 7 ..  7;
      Reserved           at 0 range 8 .. 31;
   end record;

   type TRNG_DATA_Type is record
      TRNG_DATA : Unsigned_8;      -- random data byte
      Reserved  : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TRNG_DATA_Type use record
      TRNG_DATA at 0 range 0 ..  7;
      Reserved  at 0 range 8 .. 31;
   end record;

   type TRNG_Type is record
      CTRL : TRNG_CTRL_Type with Volatile_Full_Access => True;
      DATA : TRNG_DATA_Type with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for TRNG_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   TRNG_BASEADDRESS : constant := 16#FFFA_0000#;

   TRNG : aliased TRNG_Type
      with Address    => System'To_Address (TRNG_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.21. Custom Functions Subsystem (CFS)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.22. Smart LED Interface (NEOLED)
   ----------------------------------------------------------------------------

   type NEOLED_Type is record
      CTRL : Unsigned_32 with Volatile_Full_Access => True;
      DATA : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 2 * 32;
   for NEOLED_Type use record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   NEOLED_BASEADDRESS : constant := 16#FFFD_0000#;

   NEOLED : aliased NEOLED_Type
      with Address    => System'To_Address (NEOLED_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.23. General Purpose Timer (GPTMR)
   ----------------------------------------------------------------------------

   type GPTMR_Type is record
      CTRL  : Unsigned_32 with Volatile_Full_Access => True;
      THRES : Unsigned_32 with Volatile_Full_Access => True;
      COUNT : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 3 * 32;
   for GPTMR_Type use record
      CTRL  at 0 range 0 .. 31;
      THRES at 4 range 0 .. 31;
      COUNT at 8 range 0 .. 31;
   end record;

   GPTMR_BASEADDRESS : constant := 16#FFF1_0000#;

   GPTMR : aliased GPTMR_Type
      with Address    => System'To_Address (GPTMR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.24. Execution Trace Buffer (TRACER)
   ----------------------------------------------------------------------------

   type TRACER_Type is record
      CTRL      : Unsigned_32 with Volatile_Full_Access => True;
      STOP_ADDR : Unsigned_32 with Volatile_Full_Access => True;
      DELTA_SRC : Unsigned_32 with Volatile_Full_Access => True;
      DELTA_DST : Unsigned_32 with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for TRACER_Type use record
      CTRL      at 16#0# range 0 .. 31;
      STOP_ADDR at 16#4# range 0 .. 31;
      DELTA_SRC at 16#8# range 0 .. 31;
      DELTA_DST at 16#C# range 0 .. 31;
   end record;

   TRACER_BASEADDRESS : constant := 16#FFF3_0000#;

   TRACER : aliased TRACER_Type
      with Address    => System'To_Address (TRACER_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 2.8.25. System Configuration Information Memory (SYSINFO)
   ----------------------------------------------------------------------------

   -- Table 41. SYSINFO MEM Bits

   SYSINFO_MISC_BOOT_Bootloader     : constant := 0; -- (default) Base of internal BOOTROM Implement the processor-internal Bootloader ROM (BOOTROM) as pre-initialized ROM and boot from there.
   SYSINFO_MISC_BOOT_Custom_Address : constant := 1; -- BOOT_ADDR_CUSTOM generic           Start booting at user-defined address (BOOT_ADDR_CUSTOM top generic).
   SYSINFO_MISC_BOOT_IMEM_Image     : constant := 2; -- Base of internal IMEM              Implement the processor-internal Instruction Memory (IMEM) as pre-initialized ROM and boot from there.

   type MEM_Type is record
      SYSINFO_MISC_IMEM : Unsigned_8; -- log2(internal IMEM size in bytes), via top’s IMEM_SIZE generic
      SYSINFO_MISC_DMEM : Unsigned_8; -- log2(internal DMEM size in bytes), via top’s DMEM_SIZE generic
      SYSINFO_MISC_HART : Bits_4;     -- number of physical CPU cores ("harts")
      SYSINFO_MISC_BOOT : Bits_4;     -- boot mode configuration, via top’s BOOT_MODE_SELECT generic (see Boot Configuration))
      SYSINFO_MISC_BTMO : Unsigned_8; -- log2(bus timeout cycles), see Bus Monitor and Timeout
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MEM_Type use record
      SYSINFO_MISC_IMEM at 0 range  0 ..  7;
      SYSINFO_MISC_DMEM at 0 range  8 .. 15;
      SYSINFO_MISC_HART at 0 range 16 .. 19;
      SYSINFO_MISC_BOOT at 0 range 20 .. 23;
      SYSINFO_MISC_BTMO at 0 range 24 .. 31;
   end record;

   -- Table 42. SYSINFO SOC Bits

   type SOC_Type is record
      SYSINFO_SOC_BOOTLOADER : Boolean; -- set if processor-internal bootloader is implemented (via top’s BOOT_MODE_SELECT generic; see Boot Configuration)
      SYSINFO_SOC_XBUS       : Boolean; -- set if external bus interface is implemented (via top’s XBUS_EN generic)
      SYSINFO_SOC_IMEM       : Boolean; -- set if processor-internal DMEM is implemented (via top’s IMEM_EN generic)
      SYSINFO_SOC_DMEM       : Boolean; -- set if processor-internal IMEM is implemented (via top’s DMEM_EN generic)
      SYSINFO_SOC_OCD        : Boolean; -- set if on-chip debugger is implemented (via top’s OCD_EN generic)
      SYSINFO_SOC_ICACHE     : Boolean; -- set if processor-internal instruction cache is implemented (via top’s ICACHE_EN generic)
      SYSINFO_SOC_DCACHE     : Boolean; -- set if processor-internal data cache is implemented (via top’s DCACHE_EN generic)
      Reserved1              : Bits_1;
      Reserved2              : Bits_1;
      Reserved3              : Bits_1;
      Reserved4              : Bits_1;
      SYSINFO_SOC_OCD_AUTH   : Boolean; -- set if on-chip debugger authentication is implemented (via top’s OCD_AUTHENTICATION generic)
      SYSINFO_SOC_IMEM_ROM   : Boolean; -- set if processor-internal IMEM is implemented as pre-initialized ROM (via top’s BOOT_MODE_SELECT generic; see Boot Configuration)
      SYSINFO_SOC_IO_TWD     : Boolean; -- set if TWD is implemented (via top’s IO_TWD_EN generic)
      SYSINFO_SOC_IO_DMA     : Boolean; -- set if direct memory access controller is implemented (via top’s IO_DMA_EN generic)
      SYSINFO_SOC_IO_GPIO    : Boolean; -- set if GPIO is implemented (via top’s IO_GPIO_EN generic)
      SYSINFO_SOC_IO_CLINT   : Boolean; -- set if CLINT is implemented (via top’s IO_CLINT_EN generic)
      SYSINFO_SOC_IO_UART0   : Boolean; -- set if primary UART0 is implemented (via top’s IO_UART0_EN generic)
      SYSINFO_SOC_IO_SPI     : Boolean; -- set if SPI is implemented (via top’s IO_SPI_EN generic)
      SYSINFO_SOC_IO_TWI     : Boolean; -- set if TWI is implemented (via top’s IO_TWI_EN generic)
      SYSINFO_SOC_IO_PWM     : Boolean; -- set if PWM is implemented (via top’s IO_PWM_NUM_CH generic)
      SYSINFO_SOC_IO_WDT     : Boolean; -- set if WDT is implemented (via top’s IO_WDT_EN generic)
      SYSINFO_SOC_IO_CFS     : Boolean; -- set if custom functions subsystem is implemented (via top’s IO_CFS_EN generic)
      SYSINFO_SOC_IO_TRNG    : Boolean; -- set if TRNG is implemented (via top’s IO_TRNG_EN generic)
      SYSINFO_SOC_IO_SDI     : Boolean; -- set if SDI is implemented (via top’s IO_SDI_EN generic)
      SYSINFO_SOC_IO_UART1   : Boolean; -- set if secondary UART1 is implemented (via top’s IO_UART1_EN generic)
      SYSINFO_SOC_IO_NEOLED  : Boolean; -- set if smart LED interface is implemented (via top’s IO_NEOLED_EN generic)
      SYSINFO_SOC_IO_TRACER  : Boolean; -- set if execution tracer is implemented (via top’s IO_TRACER_EN generic)
      SYSINFO_SOC_IO_GPTMR   : Boolean; -- set if GPTMR is implemented (via top’s IO_GPTMR_EN generic)
      SYSINFO_SOC_IO_SLINK   : Boolean; -- set if stream link interface is implemented (via top’s IO_SLINK_EN generic)
      SYSINFO_SOC_IO_ONEWIRE : Boolean; -- set if ONEWIRE interface is implemented (via top’s IO_ONEWIRE_EN generic)
      Reserved5              : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SOC_Type use record
      SYSINFO_SOC_BOOTLOADER at 0 range  0 ..  0;
      SYSINFO_SOC_XBUS       at 0 range  1 ..  1;
      SYSINFO_SOC_IMEM       at 0 range  2 ..  2;
      SYSINFO_SOC_DMEM       at 0 range  3 ..  3;
      SYSINFO_SOC_OCD        at 0 range  4 ..  4;
      SYSINFO_SOC_ICACHE     at 0 range  5 ..  5;
      SYSINFO_SOC_DCACHE     at 0 range  6 ..  6;
      Reserved1              at 0 range  7 ..  7;
      Reserved2              at 0 range  8 ..  8;
      Reserved3              at 0 range  9 ..  9;
      Reserved4              at 0 range 10 .. 10;
      SYSINFO_SOC_OCD_AUTH   at 0 range 11 .. 11;
      SYSINFO_SOC_IMEM_ROM   at 0 range 12 .. 12;
      SYSINFO_SOC_IO_TWD     at 0 range 13 .. 13;
      SYSINFO_SOC_IO_DMA     at 0 range 14 .. 14;
      SYSINFO_SOC_IO_GPIO    at 0 range 15 .. 15;
      SYSINFO_SOC_IO_CLINT   at 0 range 16 .. 16;
      SYSINFO_SOC_IO_UART0   at 0 range 17 .. 17;
      SYSINFO_SOC_IO_SPI     at 0 range 18 .. 18;
      SYSINFO_SOC_IO_TWI     at 0 range 19 .. 19;
      SYSINFO_SOC_IO_PWM     at 0 range 20 .. 20;
      SYSINFO_SOC_IO_WDT     at 0 range 21 .. 21;
      SYSINFO_SOC_IO_CFS     at 0 range 22 .. 22;
      SYSINFO_SOC_IO_TRNG    at 0 range 23 .. 23;
      SYSINFO_SOC_IO_SDI     at 0 range 24 .. 24;
      SYSINFO_SOC_IO_UART1   at 0 range 25 .. 25;
      SYSINFO_SOC_IO_NEOLED  at 0 range 26 .. 26;
      SYSINFO_SOC_IO_TRACER  at 0 range 27 .. 27;
      SYSINFO_SOC_IO_GPTMR   at 0 range 28 .. 28;
      SYSINFO_SOC_IO_SLINK   at 0 range 29 .. 29;
      SYSINFO_SOC_IO_ONEWIRE at 0 range 30 .. 30;
      Reserved5              at 0 range 31 .. 31;
   end record;

   -- Table 43. SYSINFO CACHE Bits

   type CACHE_Type is record
      SYSINFO_CACHE_INST_BLOCK_SIZE : Bits_4;  -- log2(i-cache block size in bytes), via top’s ICACHE_BLOCK_SIZE generic
      SYSINFO_CACHE_INST_NUM_BLOCKS : Bits_4;  -- log2(i-cache number of cache blocks), via top’s ICACHE_NUM_BLOCKS generic
      SYSINFO_CACHE_DATA_BLOCK_SIZE : Bits_4;  -- log2(d-cache block size in bytes), via top’s DCACHE_BLOCK_SIZE generic
      SYSINFO_CACHE_DATA_NUM_BLOCKS : Bits_4;  -- log2(d-cache number of cache blocks), via top’s DCACHE_NUM_BLOCKS generic
      SYSINFO_CACHE_INST_BURSTS_EN  : Boolean; -- i-cache burst transfers enabled, via top’s CACHE_BURSTS_EN generic
      Reserved1                     : Bits_7;
      SYSINFO_CACHE_DATA_BURSTS_EN  : Boolean; -- d-cache burst transfers enabled, via top’s CACHE_BURSTS_EN generic
      Reserved2                     : Bits_7;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CACHE_Type use record
      SYSINFO_CACHE_INST_BLOCK_SIZE at 0 range  0 ..  3;
      SYSINFO_CACHE_INST_NUM_BLOCKS at 0 range  4 ..  7;
      SYSINFO_CACHE_DATA_BLOCK_SIZE at 0 range  8 .. 11;
      SYSINFO_CACHE_DATA_NUM_BLOCKS at 0 range 12 .. 15;
      SYSINFO_CACHE_INST_BURSTS_EN  at 0 range 16 .. 16;
      Reserved1                     at 0 range 17 .. 23;
      SYSINFO_CACHE_DATA_BURSTS_EN  at 0 range 24 .. 24;
      Reserved2                     at 0 range 25 .. 31;
   end record;

   type SYSINFO_Type is record
      CLK   : Unsigned_32 with Volatile_Full_Access => True;
      MEM   : MEM_Type    with Volatile_Full_Access => True;
      SOC   : SOC_Type    with Volatile_Full_Access => True;
      CACHE : CACHE_Type  with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for SYSINFO_Type use record
      CLK   at 16#0# range 0 .. 31;
      MEM   at 16#4# range 0 .. 31;
      SOC   at 16#8# range 0 .. 31;
      CACHE at 16#C# range 0 .. 31;
   end record;

   SYSINFO_BASEADDRESS : constant := 16#FFFE_0000#;

   SYSINFO : aliased SYSINFO_Type
      with Address    => System'To_Address (SYSINFO_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end NEORV32;
