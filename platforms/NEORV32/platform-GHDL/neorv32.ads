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

   ----------------------------------------------------------------------------
   -- 2.8.8. Stream Link Interface (SLINK)
   ----------------------------------------------------------------------------

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

   GPIO_ADDRESS : constant := 16#FFFC_0000#;

   GPIO : aliased GPIO_Type
      with Address    => System'To_Address (GPIO_ADDRESS),
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

   WDT_ADDRESS : constant := 16#FFFB_0000#;

   WDT : aliased WDT_Type
      with Address    => System'To_Address (WDT_ADDRESS),
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

   type UART_CTRL_Type is record
      UART_CTRL_EN            : Boolean;      -- UART enable
      UART_CTRL_SIM_MODE      : Boolean;      -- enable simulation mode
      UART_CTRL_HWFC_EN       : Boolean;      -- enable RTS/CTS hardware flow-control
      UART_CTRL_PRSC          : Bits_3;       -- Baud rate clock prescaler select
      UART_CTRL_BAUD          : Bits_10;      -- 12-bit Baud value configuration value
      UART_CTRL_RX_NEMPTY     : Boolean;      -- RX FIFO not empty
      UART_CTRL_RX_HALF       : Boolean;      -- RX FIFO at least half-full
      UART_CTRL_RX_FULL       : Boolean;      -- RX FIFO full
      UART_CTRL_TX_EMPTY      : Boolean;      -- TX FIFO empty
      UART_CTRL_TX_NHALF      : Boolean;      -- TX FIFO not at least half-full
      UART_CTRL_TX_NFULL      : Boolean;      -- TX FIFO not full
      UART_CTRL_IRQ_RX_NEMPTY : Boolean;      -- fire RX-IRQ if RX FIFO not empty
      UART_CTRL_IRQ_RX_HALF   : Boolean;      -- fire RX-IRQ if RX FIFO at least half full
      UART_CTRL_IRQ_RX_FULL   : Boolean;      -- fire RX-IRQ if RX FIFO full
      UART_CTRL_IRQ_TX_EMPTY  : Boolean;      -- fire TX-IRQ if TX FIFO empty
      UART_CTRL_IRQ_TX_NHALF  : Boolean;      -- fire TX-IRQ if TX FIFO not at least half full
      UART_CTRL_IRQ_TX_NFULL  : Boolean;      -- fire TX-IRQ if TX not full
      UART_CTRL_RX_CLR        : Boolean;      -- Clear RX FIFO, flag auto-clears
      UART_CTRL_TX_CLR        : Boolean;      -- Clear TX FIFO, flag auto-clears
      UART_CTRL_RX_OVER       : Boolean;      -- RX FIFO overflow; cleared by disabling the module
      UART_CTRL_TX_BUSY       : Boolean;      -- TX busy or TX FIFO not empty
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

   type SPI_Type is record
      CTRL : Unsigned_32 with Volatile_Full_Access => True;
      DATA : Unsigned_32 with Volatile_Full_Access => True;
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

   ----------------------------------------------------------------------------
   -- 2.8.15. Serial Data Interface Controller (SDI)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.16. Two-Wire Serial Interface Controller (TWI)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.17. Two-Wire Serial Device Controller (TWD)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.18. One-Wire Serial Interface Controller (ONEWIRE)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.19. Pulse-Width Modulation Controller (PWM)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.20. True Random-Number Generator (TRNG)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.21. Custom Functions Subsystem (CFS)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.22. Smart LED Interface (NEOLED)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.23. General Purpose Timer (GPTMR)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.24. Execution Trace Buffer (TRACER)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 2.8.25. System Configuration Information Memory (SYSINFO)
   ----------------------------------------------------------------------------

   type SYSINFO_Type is record
      CLK   : Unsigned_32 with Volatile_Full_Access => True;
      MEM   : Unsigned_32 with Volatile_Full_Access => True;
      SOC   : Unsigned_32 with Volatile_Full_Access => True;
      CACHE : Unsigned_32 with Volatile_Full_Access => True;
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
