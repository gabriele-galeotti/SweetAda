-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rpi3.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package RPI3 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   PERIPHERALS_BASEADDRESS  : constant := 16#3F00_0000#;
   SYSTEM_TIMER_BASEADDRESS : constant := PERIPHERALS_BASEADDRESS + 16#0000_3000#;
   INTERRUPTS_BASEADDRESS   : constant := PERIPHERALS_BASEADDRESS + 16#0000_B000#;
   MAILBOX_BASEADDRESS      : constant := PERIPHERALS_BASEADDRESS + 16#0000_B880#;
   GPIO_BASEADDRESS         : constant := PERIPHERALS_BASEADDRESS + 16#0020_0000#;
   AUX_BASEADDRESS          : constant := PERIPHERALS_BASEADDRESS + 16#0021_5000#;
   EMMC_BASEADDRESS         : constant := PERIPHERALS_BASEADDRESS + 16#0030_0000#;

   ----------------------------------------------------------------------------
   -- 2.1.1 AUX registers
   ----------------------------------------------------------------------------

   type AUXENB_Type is
   record
      MiniUART_Enable : Boolean; -- If set the mini UART is enabled.
      SPI1_Enable     : Boolean; -- If set the SPI 1 module is enabled.
      SPI2_Enable     : Boolean; -- If set the SPI 2 module is enabled.
      Reserved        : Bits_29;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUXENB_Type use
   record
      MiniUART_Enable at 0 range 0 .. 0;
      SPI1_Enable     at 0 range 1 .. 1;
      SPI2_Enable     at 0 range 2 .. 2;
      Reserved        at 0 range 3 .. 31;
   end record;

   AUXENB : aliased AUXENB_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type AUX_MU_IO_Type is
   record
      DATA     : Unsigned_8; -- RX DATA, TX DATA or baud rate LSB (DLAB = 1)
      Reserved : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUX_MU_IO_Type use
   record
      DATA     at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   AUX_MU_IO_REG : aliased AUX_MU_IO_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#40#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   UART_7BIT : constant := 2#00#; -- the UART works in 7-bit mode
   UART_8BIT : constant := 2#11#; -- the UART works in 8-bit mode

   type AUX_MU_LCR_Type is
   record
      Data_Size   : Bits_2;  -- UART data size
      Reserved1   : Bits_4;
      Break       : Boolean; -- If set high the UART1_TX line is pulled low continuously.
      DLAB_Access : Boolean; -- If set the first to Mini UART register give access the the Baudrate register.
      Reserved2   : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUX_MU_LCR_Type use
   record
      Data_Size   at 0 range 0 .. 1;
      Reserved1   at 0 range 2 .. 5;
      Break       at 0 range 6 .. 6;
      DLAB_Access at 0 range 7 .. 7;
      Reserved2   at 0 range 8 .. 31;
   end record;

   AUX_MU_LCR_REG : aliased AUX_MU_LCR_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#4C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type AUX_MU_LSR_Type is
   record
      Data_Ready        : Boolean; -- This bit is set if the receive FIFO holds at least 1 symbol.
      Receiver_Overrun  : Boolean; -- This bit is set if there was a receiver overrun.
      Reserved1         : Bits_3;
      Transmitter_Empty : Boolean; -- This bit is set if the transmit FIFO can accept at least one byte.
      Transmitter_Idle  : Boolean; -- This bit is set if the transmit FIFO is empty and the transmitter is idle.
      Reserved2         : Bits_1;
      Reserved3         : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUX_MU_LSR_Type use
   record
      Data_Ready        at 0 range 0 .. 0;
      Receiver_Overrun  at 0 range 1 .. 1;
      Reserved1         at 0 range 2 .. 4;
      Transmitter_Empty at 0 range 5 .. 5;
      Transmitter_Idle  at 0 range 6 .. 6;
      Reserved2         at 0 range 7 .. 7;
      Reserved3         at 0 range 8 .. 31;
   end record;

   AUX_MU_LSR_REG : aliased AUX_MU_LSR_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#54#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type AUX_MU_MSR_Type is
   record
      Reserved1  : Bits_4;
      CTS_Status : Boolean; -- This bit is the inverse of the UART1_CTS input
      Reserved2  : Bits_3;
      Reserved3  : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUX_MU_MSR_Type use
   record
      Reserved1  at 0 range 0 .. 3;
      CTS_Status at 0 range 4 .. 4;
      Reserved2  at 0 range 5 .. 7;
      Reserved3  at 0 range 8 .. 31;
   end record;

   AUX_MU_MSR_REG : aliased AUX_MU_MSR_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#58#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   RTS_Autoflow3 : constant := 2#00#; -- De-assert RTS when the receive FIFO has 3 empty spaces left.
   RTS_Autoflow2 : constant := 2#01#; -- De-assert RTS when the receive FIFO has 2 empty spaces left.
   RTS_Autoflow1 : constant := 2#10#; -- De-assert RTS when the receive FIFO has 1 empty space left.
   RTS_Autoflow4 : constant := 2#11#; -- De-assert RTS when the receive FIFO has 4 empty spaces left.

   RTS_AutoflowP : constant := 0; -- If clear the RTS auto flow assert level is high
   RTS_AutoflowN : constant := 1; -- If set the RTS auto flow assert level is low

   CTS_AutoflowP : constant := 0; -- If clear the CTS auto flow assert level is high
   CTS_AutoflowN : constant := 1; -- If set the CTS auto flow assert level is low

   type AUX_MU_CNTL_Type is
   record
      Receiver_Enable    : Boolean; -- If this bit is set the mini UART receiver is enabled.
      Transmitter_Enable : Boolean; -- If this bit is set the mini UART transmitter is enabled.
      RTS_RX_Autoflow    : Boolean; -- If ... the RTS line will de-assert if thereceive FIFO reaches it 'auto flow' level.
      CTS_TX_Autoflow    : Boolean; -- If this bit is set the transmitter will stop if the CTS line is de-asserted.
      RTS_Autoflow_Level : Bits_2;  -- These ..  at what receiver FIFO level the RTS line is de-asserted in auto-flow mode.
      RTS_Assert_Level   : Bits_1;  -- This bit allows one to invert the RTS auto flow operation polarity.
      CTS_Assert_Level   : Bits_1;  -- This bit allows one to invert the CTS auto flow operation polarity.
      Reserved           : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUX_MU_CNTL_Type use
   record
      Receiver_Enable    at 0 range 0 .. 0;
      Transmitter_Enable at 0 range 1 .. 1;
      RTS_RX_Autoflow    at 0 range 2 .. 2;
      CTS_TX_Autoflow    at 0 range 3 .. 3;
      RTS_Autoflow_Level at 0 range 4 .. 5;
      RTS_Assert_Level   at 0 range 6 .. 6;
      CTS_Assert_Level   at 0 range 7 .. 7;
      Reserved           at 0 range 8 .. 31;
   end record;

   AUX_MU_CNTL_REG : aliased AUX_MU_CNTL_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#60#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type AUX_MU_BAUD_Type is
   record
      Baudrate : Unsigned_16; -- mini UART baudrate counter
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for AUX_MU_BAUD_Type use
   record
      Baudrate at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   AUX_MU_BAUD : aliased AUX_MU_BAUD_Type with
      Address              => To_Address (AUX_BASEADDRESS + 16#68#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 6 General Purpose I/O (GPIO)
   ----------------------------------------------------------------------------

   GPIO_INPUT  : constant := 2#000#;
   GPIO_OUTPUT : constant := 2#001#;
   GPIO_ALT0   : constant := 2#100#;
   GPIO_ALT1   : constant := 2#101#;
   GPIO_ALT2   : constant := 2#110#;
   GPIO_ALT3   : constant := 2#111#;
   GPIO_ALT4   : constant := 2#011#;
   GPIO_ALT5   : constant := 2#010#;

   type GPFSEL0_Type is
   record
      FSEL0    : Bits_3;
      FSEL1    : Bits_3;
      FSEL2    : Bits_3;
      FSEL3    : Bits_3;
      FSEL4    : Bits_3;
      FSEL5    : Bits_3;
      FSEL6    : Bits_3;
      FSEL7    : Bits_3;
      FSEL8    : Bits_3;
      FSEL9    : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL0_Type use
   record
      FSEL0    at 0 range 0 .. 2;
      FSEL1    at 0 range 3 .. 5;
      FSEL2    at 0 range 6 .. 8;
      FSEL3    at 0 range 9 .. 11;
      FSEL4    at 0 range 12 .. 14;
      FSEL5    at 0 range 15 .. 17;
      FSEL6    at 0 range 18 .. 20;
      FSEL7    at 0 range 21 .. 23;
      FSEL8    at 0 range 24 .. 26;
      FSEL9    at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL0 : aliased GPFSEL0_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL1_Type is
   record
      FSEL10   : Bits_3;
      FSEL11   : Bits_3;
      FSEL12   : Bits_3;
      FSEL13   : Bits_3;
      FSEL14   : Bits_3;
      FSEL15   : Bits_3;
      FSEL16   : Bits_3;
      FSEL17   : Bits_3;
      FSEL18   : Bits_3;
      FSEL19   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL1_Type use
   record
      FSEL10   at 0 range 0 .. 2;
      FSEL11   at 0 range 3 .. 5;
      FSEL12   at 0 range 6 .. 8;
      FSEL13   at 0 range 9 .. 11;
      FSEL14   at 0 range 12 .. 14;
      FSEL15   at 0 range 15 .. 17;
      FSEL16   at 0 range 18 .. 20;
      FSEL17   at 0 range 21 .. 23;
      FSEL18   at 0 range 24 .. 26;
      FSEL19   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL1 : aliased GPFSEL1_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL2_Type is
   record
      FSEL20   : Bits_3;
      FSEL21   : Bits_3;
      FSEL22   : Bits_3;
      FSEL23   : Bits_3;
      FSEL24   : Bits_3;
      FSEL25   : Bits_3;
      FSEL26   : Bits_3;
      FSEL27   : Bits_3;
      FSEL28   : Bits_3;
      FSEL29   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL2_Type use
   record
      FSEL20   at 0 range 0 .. 2;
      FSEL21   at 0 range 3 .. 5;
      FSEL22   at 0 range 6 .. 8;
      FSEL23   at 0 range 9 .. 11;
      FSEL24   at 0 range 12 .. 14;
      FSEL25   at 0 range 15 .. 17;
      FSEL26   at 0 range 18 .. 20;
      FSEL27   at 0 range 21 .. 23;
      FSEL28   at 0 range 24 .. 26;
      FSEL29   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL2 : aliased GPFSEL2_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#08#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL3_Type is
   record
      FSEL30   : Bits_3;
      FSEL31   : Bits_3;
      FSEL32   : Bits_3;
      FSEL33   : Bits_3;
      FSEL34   : Bits_3;
      FSEL35   : Bits_3;
      FSEL36   : Bits_3;
      FSEL37   : Bits_3;
      FSEL38   : Bits_3;
      FSEL39   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL3_Type use
   record
      FSEL30   at 0 range 0 .. 2;
      FSEL31   at 0 range 3 .. 5;
      FSEL32   at 0 range 6 .. 8;
      FSEL33   at 0 range 9 .. 11;
      FSEL34   at 0 range 12 .. 14;
      FSEL35   at 0 range 15 .. 17;
      FSEL36   at 0 range 18 .. 20;
      FSEL37   at 0 range 21 .. 23;
      FSEL38   at 0 range 24 .. 26;
      FSEL39   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL3 : aliased GPFSEL3_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#0C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL4_Type is
   record
      FSEL40   : Bits_3;
      FSEL41   : Bits_3;
      FSEL42   : Bits_3;
      FSEL43   : Bits_3;
      FSEL44   : Bits_3;
      FSEL45   : Bits_3;
      FSEL46   : Bits_3;
      FSEL47   : Bits_3;
      FSEL48   : Bits_3;
      FSEL49   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL4_Type use
   record
      FSEL40   at 0 range 0 .. 2;
      FSEL41   at 0 range 3 .. 5;
      FSEL42   at 0 range 6 .. 8;
      FSEL43   at 0 range 9 .. 11;
      FSEL44   at 0 range 12 .. 14;
      FSEL45   at 0 range 15 .. 17;
      FSEL46   at 0 range 18 .. 20;
      FSEL47   at 0 range 21 .. 23;
      FSEL48   at 0 range 24 .. 26;
      FSEL49   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL4 : aliased GPFSEL4_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#10#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL5_Type is
   record
      FSEL50   : Bits_3;
      FSEL51   : Bits_3;
      FSEL52   : Bits_3;
      FSEL53   : Bits_3;
      Reserved : Bits_20;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL5_Type use
   record
      FSEL50   at 0 range 0 .. 2;
      FSEL51   at 0 range 3 .. 5;
      FSEL52   at 0 range 6 .. 8;
      FSEL53   at 0 range 9 .. 11;
      Reserved at 0 range 12 .. 31;
   end record;

   GPFSEL5 : aliased GPFSEL5_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#14#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPSET0_Type is
   record
      SET0  : Boolean;
      SET1  : Boolean;
      SET2  : Boolean;
      SET3  : Boolean;
      SET4  : Boolean;
      SET5  : Boolean;
      SET6  : Boolean;
      SET7  : Boolean;
      SET8  : Boolean;
      SET9  : Boolean;
      SET10 : Boolean;
      SET11 : Boolean;
      SET12 : Boolean;
      SET13 : Boolean;
      SET14 : Boolean;
      SET15 : Boolean;
      SET16 : Boolean;
      SET17 : Boolean;
      SET18 : Boolean;
      SET19 : Boolean;
      SET20 : Boolean;
      SET21 : Boolean;
      SET22 : Boolean;
      SET23 : Boolean;
      SET24 : Boolean;
      SET25 : Boolean;
      SET26 : Boolean;
      SET27 : Boolean;
      SET28 : Boolean;
      SET29 : Boolean;
      SET30 : Boolean;
      SET31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPSET0_Type use
   record
      SET0  at 0 range 0 .. 0;
      SET1  at 0 range 1 .. 1;
      SET2  at 0 range 2 .. 2;
      SET3  at 0 range 3 .. 3;
      SET4  at 0 range 4 .. 4;
      SET5  at 0 range 5 .. 5;
      SET6  at 0 range 6 .. 6;
      SET7  at 0 range 7 .. 7;
      SET8  at 0 range 8 .. 8;
      SET9  at 0 range 9 .. 9;
      SET10 at 0 range 10 .. 10;
      SET11 at 0 range 11 .. 11;
      SET12 at 0 range 12 .. 12;
      SET13 at 0 range 13 .. 13;
      SET14 at 0 range 14 .. 14;
      SET15 at 0 range 15 .. 15;
      SET16 at 0 range 16 .. 16;
      SET17 at 0 range 17 .. 17;
      SET18 at 0 range 18 .. 18;
      SET19 at 0 range 19 .. 19;
      SET20 at 0 range 20 .. 20;
      SET21 at 0 range 21 .. 21;
      SET22 at 0 range 22 .. 22;
      SET23 at 0 range 23 .. 23;
      SET24 at 0 range 24 .. 24;
      SET25 at 0 range 25 .. 25;
      SET26 at 0 range 26 .. 26;
      SET27 at 0 range 27 .. 27;
      SET28 at 0 range 28 .. 28;
      SET29 at 0 range 29 .. 29;
      SET30 at 0 range 30 .. 30;
      SET31 at 0 range 31 .. 31;
   end record;

   GPSET0 : aliased GPSET0_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#1C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPSET1_Type is
   record
      SET32    : Boolean;
      SET33    : Boolean;
      SET34    : Boolean;
      SET35    : Boolean;
      SET36    : Boolean;
      SET37    : Boolean;
      SET38    : Boolean;
      SET39    : Boolean;
      SET40    : Boolean;
      SET41    : Boolean;
      SET42    : Boolean;
      SET43    : Boolean;
      SET44    : Boolean;
      SET45    : Boolean;
      SET46    : Boolean;
      SET47    : Boolean;
      SET48    : Boolean;
      SET49    : Boolean;
      SET50    : Boolean;
      SET51    : Boolean;
      SET52    : Boolean;
      SET53    : Boolean;
      Reserved : Bits_10;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPSET1_Type use
   record
      SET32    at 0 range 0 .. 0;
      SET33    at 0 range 1 .. 1;
      SET34    at 0 range 2 .. 2;
      SET35    at 0 range 3 .. 3;
      SET36    at 0 range 4 .. 4;
      SET37    at 0 range 5 .. 5;
      SET38    at 0 range 6 .. 6;
      SET39    at 0 range 7 .. 7;
      SET40    at 0 range 8 .. 8;
      SET41    at 0 range 9 .. 9;
      SET42    at 0 range 10 .. 10;
      SET43    at 0 range 11 .. 11;
      SET44    at 0 range 12 .. 12;
      SET45    at 0 range 13 .. 13;
      SET46    at 0 range 14 .. 14;
      SET47    at 0 range 15 .. 15;
      SET48    at 0 range 16 .. 16;
      SET49    at 0 range 17 .. 17;
      SET50    at 0 range 18 .. 18;
      SET51    at 0 range 19 .. 19;
      SET52    at 0 range 20 .. 20;
      SET53    at 0 range 21 .. 21;
      Reserved at 0 range 22 .. 31;
   end record;

   GPSET1 : aliased GPSET1_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#20#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPCLR0_Type is
   record
      CLR0  : Boolean;
      CLR1  : Boolean;
      CLR2  : Boolean;
      CLR3  : Boolean;
      CLR4  : Boolean;
      CLR5  : Boolean;
      CLR6  : Boolean;
      CLR7  : Boolean;
      CLR8  : Boolean;
      CLR9  : Boolean;
      CLR10 : Boolean;
      CLR11 : Boolean;
      CLR12 : Boolean;
      CLR13 : Boolean;
      CLR14 : Boolean;
      CLR15 : Boolean;
      CLR16 : Boolean;
      CLR17 : Boolean;
      CLR18 : Boolean;
      CLR19 : Boolean;
      CLR20 : Boolean;
      CLR21 : Boolean;
      CLR22 : Boolean;
      CLR23 : Boolean;
      CLR24 : Boolean;
      CLR25 : Boolean;
      CLR26 : Boolean;
      CLR27 : Boolean;
      CLR28 : Boolean;
      CLR29 : Boolean;
      CLR30 : Boolean;
      CLR31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPCLR0_Type use
   record
      CLR0  at 0 range 0 .. 0;
      CLR1  at 0 range 1 .. 1;
      CLR2  at 0 range 2 .. 2;
      CLR3  at 0 range 3 .. 3;
      CLR4  at 0 range 4 .. 4;
      CLR5  at 0 range 5 .. 5;
      CLR6  at 0 range 6 .. 6;
      CLR7  at 0 range 7 .. 7;
      CLR8  at 0 range 8 .. 8;
      CLR9  at 0 range 9 .. 9;
      CLR10 at 0 range 10 .. 10;
      CLR11 at 0 range 11 .. 11;
      CLR12 at 0 range 12 .. 12;
      CLR13 at 0 range 13 .. 13;
      CLR14 at 0 range 14 .. 14;
      CLR15 at 0 range 15 .. 15;
      CLR16 at 0 range 16 .. 16;
      CLR17 at 0 range 17 .. 17;
      CLR18 at 0 range 18 .. 18;
      CLR19 at 0 range 19 .. 19;
      CLR20 at 0 range 20 .. 20;
      CLR21 at 0 range 21 .. 21;
      CLR22 at 0 range 22 .. 22;
      CLR23 at 0 range 23 .. 23;
      CLR24 at 0 range 24 .. 24;
      CLR25 at 0 range 25 .. 25;
      CLR26 at 0 range 26 .. 26;
      CLR27 at 0 range 27 .. 27;
      CLR28 at 0 range 28 .. 28;
      CLR29 at 0 range 29 .. 29;
      CLR30 at 0 range 30 .. 30;
      CLR31 at 0 range 31 .. 31;
   end record;

   GPCLR0 : aliased GPCLR0_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#28#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPCLR1_Type is
   record
      CLR32    : Boolean;
      CLR33    : Boolean;
      CLR34    : Boolean;
      CLR35    : Boolean;
      CLR36    : Boolean;
      CLR37    : Boolean;
      CLR38    : Boolean;
      CLR39    : Boolean;
      CLR40    : Boolean;
      CLR41    : Boolean;
      CLR42    : Boolean;
      CLR43    : Boolean;
      CLR44    : Boolean;
      CLR45    : Boolean;
      CLR46    : Boolean;
      CLR47    : Boolean;
      CLR48    : Boolean;
      CLR49    : Boolean;
      CLR50    : Boolean;
      CLR51    : Boolean;
      CLR52    : Boolean;
      CLR53    : Boolean;
      Reserved : Bits_10;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPCLR1_Type use
   record
      CLR32    at 0 range 0 .. 0;
      CLR33    at 0 range 1 .. 1;
      CLR34    at 0 range 2 .. 2;
      CLR35    at 0 range 3 .. 3;
      CLR36    at 0 range 4 .. 4;
      CLR37    at 0 range 5 .. 5;
      CLR38    at 0 range 6 .. 6;
      CLR39    at 0 range 7 .. 7;
      CLR40    at 0 range 8 .. 8;
      CLR41    at 0 range 9 .. 9;
      CLR42    at 0 range 10 .. 10;
      CLR43    at 0 range 11 .. 11;
      CLR44    at 0 range 12 .. 12;
      CLR45    at 0 range 13 .. 13;
      CLR46    at 0 range 14 .. 14;
      CLR47    at 0 range 15 .. 15;
      CLR48    at 0 range 16 .. 16;
      CLR49    at 0 range 17 .. 17;
      CLR50    at 0 range 18 .. 18;
      CLR51    at 0 range 19 .. 19;
      CLR52    at 0 range 20 .. 20;
      CLR53    at 0 range 21 .. 21;
      Reserved at 0 range 22 .. 31;
   end record;

   GPCLR1 : aliased GPCLR1_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#2C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 12.1 System Timer Registers
   ----------------------------------------------------------------------------

   type CS_Type is
   record
      M0       : Boolean; -- System Timer Match 0
      M1       : Boolean; -- System Timer Match 1
      M2       : Boolean; -- System Timer Match 2
      M3       : Boolean; -- System Timer Match 3
      Reserved : Bits_28;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CS_Type use
   record
      M0       at 0 range 0 .. 0;
      M1       at 0 range 1 .. 1;
      M2       at 0 range 2 .. 2;
      M3       at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 31;
   end record;

   type System_Timer_Type is
   record
      CS  : CS_Type     with Volatile_Full_Access => True; -- System Timer Control/Status
      CLO : Unsigned_32 with Volatile_Full_Access => True; -- System Timer Counter Lower 32 bits
      CHI : Unsigned_32 with Volatile_Full_Access => True; -- System Timer Counter Higher 32 bits
      C0  : Unsigned_32 with Volatile_Full_Access => True; -- System Timer Compare 0
      C1  : Unsigned_32 with Volatile_Full_Access => True; -- System Timer Compare 1
      C2  : Unsigned_32 with Volatile_Full_Access => True; -- System Timer Compare 2
      C3  : Unsigned_32 with Volatile_Full_Access => True; -- System Timer Compare 3
   end record with
      Size => 7 * 32;
   for System_Timer_Type use
   record
      CS  at 16#00# range 0 .. 31;
      CLO at 16#04# range 0 .. 31;
      CHI at 16#08# range 0 .. 31;
      C0  at 16#0C# range 0 .. 31;
      C1  at 16#10# range 0 .. 31;
      C2  at 16#14# range 0 .. 31;
      C3  at 16#18# range 0 .. 31;
   end record;

   SYSTEM_TIMER : System_Timer_Type with
      Address    => To_Address (SYSTEM_TIMER_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- MAILBOX
   ----------------------------------------------------------------------------

   type Message_Type is
   record
      Channel : Bits.Bits_4;
      Data    : Bits.Bits_28;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Message_Type use
   record
      Channel at 0 range 0 .. 3;
      Data    at 0 range 4 .. 31;
   end record;

   type Message_Status_Type is
   record
      Reserved : Bits.Bits_30;
      Empty    : Boolean;
      Full     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Message_Status_Type use
   record
      Reserved at 0 range 0 .. 29;
      Empty    at 0 range 30 .. 30;
      Full     at 0 range 31 .. 31;
   end record;

   -- POLL   @ 0x10
   -- SENDER @ 0x14
   -- CONFIG @ 0x1C
   MAIL0_Read   : aliased Message_Type with
      Address              => To_Address (MAILBOX_BASEADDRESS + 16#00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   MAIL0_Status : aliased Message_Status_Type with
      Address              => To_Address (MAILBOX_BASEADDRESS + 16#18#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   MAIL0_Write  : aliased Message_Type with
      Address              => To_Address (MAILBOX_BASEADDRESS + 16#20#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PROPERTY_CHANNEL_ID : constant := 8;

   TAG_HW          : constant := 16#0003_0_000#;
   TAG_GET         : constant := 16#0000_0_000#;
   TAG_TEST        : constant := 16#0000_4_000#;
   TAG_SET         : constant := 16#0000_8_000#;
   TAG_CLOCK       : constant := 16#0000_0_002#;
   TAG_VOLTAGE     : constant := 16#0000_0_003#;
   TAG_TEMPERATURE : constant := 16#0000_0_006#;

   -- CLOCK
   TAG_GET_CLOCK       : constant := TAG_HW + TAG_GET + TAG_CLOCK;
   TAG_SET_CLOCK       : constant := TAG_HW + TAG_SET + TAG_CLOCK;
   CLOCK_EMMC_ID       : constant := 16#1#;
   CLOCK_UART_ID       : constant := 16#2#;
   CLOCK_ARM_ID        : constant := 16#3#;
   CLOCK_CORE_ID       : constant := 16#4#;
   CLOCK_V3D_ID        : constant := 16#5#;
   CLOCK_H264_ID       : constant := 16#6#;
   CLOCK_ISP_ID        : constant := 16#7#;
   CLOCK_SDRAM_ID      : constant := 16#8#;
   CLOCK_PIXEL_ID      : constant := 16#9#;
   CLOCK_PWM_ID        : constant := 16#A#;
   CLOCK_HEVC_ID       : constant := 16#B#;
   CLOCK_EMMC2_ID      : constant := 16#C#;
   CLOCK_M2MC_ID       : constant := 16#D#;
   CLOCK_PIXEL_BVB_ID  : constant := 16#E#;
   -- VOLTAGE
   TAG_GET_VOLTAGE     : constant := TAG_HW + TAG_GET + TAG_VOLTAGE;
   VOLTAGE_CORE_ID     : constant := 16#1#;
   VOLTAGE_SDRAMC_ID   : constant := 16#2#;
   VOLTAGE_SDRAMP_ID   : constant := 16#3#;
   VOLTAGE_SDRAMI_ID   : constant := 16#4#;
   -- TEMPERATURE
   TAG_GET_TEMPERATURE : constant := TAG_HW + TAG_GET + TAG_TEMPERATURE;
   TEMPERATURE_ID      : constant := 16#0#;

end RPI3;
