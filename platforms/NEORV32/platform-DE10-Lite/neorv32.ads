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

   GPIO_ADDRESS : constant := 16#FFFF_FFC0#;

   GPIO : aliased GPIO_Type
      with Address    => System'To_Address (GPIO_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.10. Cyclic Redundancy Check (CRC)

   -- CRC_MODE_CRC8  : constant := 2#00#; -- CRC8
   -- CRC_MODE_CRC16 : constant := 2#01#; -- CRC16
   -- CRC_MODE_CRC32 : constant := 2#10#; -- CRC32

   -- type CRC_CTRL_Type is record
   --    MODE     : Bits_2;       -- CRC mode select
   --    Reserved : Bits_30 := 0;
   -- end record
   --    with Bit_Order => Low_Order_First,
   --         Size      => 32;
   -- for CRC_CTRL_Type use record
   --    MODE     at 0 range 0 ..  1;
   --    Reserved at 0 range 2 .. 31;
   -- end record;

   -- type CRC_DATA_Type is record
   --    DATA     : Unsigned_8;   -- data input
   --    Reserved : Bits_24 := 0;
   -- end record
   --    with Bit_Order => Low_Order_First,
   --         Size      => 32;
   -- for CRC_DATA_Type use record
   --    DATA     at 0 range 0 ..  7;
   --    Reserved at 0 range 8 .. 31;
   -- end record;

   -- type CRC_Type is record
   --    CTRL : CRC_CTRL_Type with Volatile_Full_Access => True;
   --    POLY : Unsigned_32   with Volatile_Full_Access => True;
   --    DATA : CRC_DATA_Type with Volatile_Full_Access => True;
   --    SREG : Unsigned_32   with Volatile_Full_Access => True;
   -- end record
   --    with Size => 4 * 32;
   -- for CRC_Type use record
   --    CTRL at 16#0# range 0 .. 31;
   --    POLY at 16#4# range 0 .. 31;
   --    DATA at 16#8# range 0 .. 31;
   --    SREG at 16#C# range 0 .. 31;
   -- end record;

   -- CRC_BASEADDRESS : constant := 16#FFFF_EE00#;

   -- CRC : aliased CRC_Type
   --    with Address    => System'To_Address (CRC_BASEADDRESS),
   --         Volatile   => True,
   --         Import     => True,
   --         Convention => Ada;

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

   WDT_ADDRESS : constant := 16#FFFF_FFBC#;

   WDT : aliased WDT_Type
      with Address    => System'To_Address (WDT_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 2.7.13. Primary Universal Asynchronous Receiver and Transmitter (UART0)
   -- 2.7.14. Secondary Universal Asynchronous Receiver and Transmitter (UART1)

   UART_CTRL_PRSC_DIV2    : constant := 2#000#; -- Resulting clock_prescaler = 2
   UART_CTRL_PRSC_DIV4    : constant := 2#001#; -- Resulting clock_prescaler = 4
   UART_CTRL_PRSC_DIV8    : constant := 2#010#; -- Resulting clock_prescaler = 8
   UART_CTRL_PRSC_DIV64   : constant := 2#011#; -- Resulting clock_prescaler = 64
   UART_CTRL_PRSC_DIV128  : constant := 2#100#; -- Resulting clock_prescaler = 128
   UART_CTRL_PRSC_DIV1024 : constant := 2#101#; -- Resulting clock_prescaler = 1024
   UART_CTRL_PRSC_DIV2048 : constant := 2#110#; -- Resulting clock_prescaler = 2048
   UART_CTRL_PRSC_DIV4096 : constant := 2#111#; -- Resulting clock_prescaler = 4096

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

   UART0_BASEADDRESS : constant := 16#FFFF_FFA0#;

   UART0 : aliased UART_Type
      with Address    => System'To_Address (UART0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART1_BASEADDRESS : constant := 16#FFFF_FFD0#;

   UART1 : aliased UART_Type
      with Address    => System'To_Address (UART1_BASEADDRESS),
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

   EIE_ADDRESS : constant := 16#FFFF_FF80#;

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

   EIP_ADDRESS : constant := 16#FFFF_FF84#;

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

   ESC_ADDRESS : constant := 16#FFFF_FF88#;

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

end NEORV32;
