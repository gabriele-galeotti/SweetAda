-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32vldiscovery.ads                                                                                      --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
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

package STM32VLDISCOVERY is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Warnings (Off);

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- 23 Universal synchronous asynchronous receiver transmitter (USART)
   ----------------------------------------------------------------------------

   -- 23.6.1 Status register (USART_SR)

   type USART_SR_Type is
   record
      PE       : Boolean := False;       -- Parity error
      FE       : Boolean := False;       -- Framing error
      NF       : Boolean := False;       -- Noise detected flag
      ORE      : Boolean := False;       -- Overrun error
      IDLE     : Boolean := False;       -- IDLE line detected
      RXNE     : Boolean := True;        -- Read data register not empty
      TC       : Boolean := True;        -- Transmission complete
      TXE      : Boolean := False;       -- Transmit data register empty
      LBD      : Boolean := True;        -- LIN break detection flag
      CTS      : Boolean := True;        -- CTS flag
      Reserved : Bits_22 := 16#00_3000#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_SR_Type use
   record
      PE       at 0 range  0 ..  0;
      FE       at 0 range  1 ..  1;
      NF       at 0 range  2 ..  2;
      ORE      at 0 range  3 ..  3;
      IDLE     at 0 range  4 ..  4;
      RXNE     at 0 range  5 ..  5;
      TC       at 0 range  6 ..  6;
      TXE      at 0 range  7 ..  7;
      LBD      at 0 range  8 ..  8;
      CTS      at 0 range  9 ..  9;
      Reserved at 0 range 10 .. 31;
   end record;

   -- 23.6.2 Data register (USART_DR)

   type USART_DR_Type is
   record
      DR       : Unsigned_8; -- Data value
      DR8      : Bits_1;     -- 9th bit
      Reserved : Bits_23;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_DR_Type use
   record
      DR       at 0 range 0 ..  7;
      DR8      at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- 23.6.4 Control register 1 (USART_CR1)

   PS_EVEN : constant := 0; -- Even parity
   PS_ODD  : constant := 1; -- Odd parity

   WAKE_IDLE : constant := 0; -- Idle line
   WAKE_ADDR : constant := 1; -- Address mark

   M_8N1 : constant := 0; -- 1 Start bit, 8 Data bits, n Stop bit
   M_9N1 : constant := 1; -- 1 Start bit, 9 Data bits, n Stop bit

   OVER8_16 : constant := 0; -- Oversampling by 16
   OVER8_8  : constant := 1; -- Oversampling by 8

   type USART_CR1_Type is
   record
      SM        : Boolean;      -- Send break
      RWU       : Boolean;      -- Receiver wakeup
      RE        : Boolean;      -- Receiver enable
      TE        : Boolean;      -- Transmitter enable
      IDLEIE    : Boolean;      -- IDLE interrupt enable
      RXNEIE    : Boolean;      -- RXNE interrupt enable
      TCIE      : Boolean;      -- Transmission complete interrupt enable
      TXEIE     : Boolean;      -- interrupt enable
      PEIE      : Boolean;      -- PE interrupt enable
      PS        : Bits_1;       -- Parity selection
      PCE       : Boolean;      -- Parity control enable
      WAKE      : Bits_1;       -- Receiver wakeup method
      M         : Bits_1;       -- Word length
      UE        : Boolean;      -- USART enable
      Reserved1 : Bits_1 := 0;
      OVER8     : Bits_1;       -- Oversampling mode
      Reserved2 : Bits_16 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_CR1_Type use
   record
      SM        at 0 range  0 ..  0;
      RWU       at 0 range  1 ..  1;
      RE        at 0 range  2 ..  2;
      TE        at 0 range  3 ..  3;
      IDLEIE    at 0 range  4 ..  4;
      RXNEIE    at 0 range  5 ..  5;
      TCIE      at 0 range  6 ..  6;
      TXEIE     at 0 range  7 ..  7;
      PEIE      at 0 range  8 ..  8;
      PS        at 0 range  9 ..  9;
      PCE       at 0 range 10 .. 10;
      WAKE      at 0 range 11 .. 11;
      M         at 0 range 12 .. 12;
      UE        at 0 range 13 .. 13;
      Reserved1 at 0 range 14 .. 14;
      OVER8     at 0 range 15 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- 23.6.8 USART register map

   type USART_Type is
   record
      USART_SR  : USART_SR_Type  with Volatile_Full_Access => True;
      USART_DR  : USART_DR_Type;
      USART_CR1 : USART_CR1_Type with Volatile_Full_Access => True;
   end record with
      Size                    => 16#1C# * 8,
      Suppress_Initialization => True;
   for USART_Type use
   record
      USART_SR  at 16#00# range 0 .. 31;
      USART_DR  at 16#04# range 0 .. 31;
      USART_CR1 at 16#0C# range 0 .. 31;
   end record;

   USART1_BASEADDRESS : constant := 16#4001_3800#;

   USART1 : aliased USART_Type with
      Address    => To_Address (USART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32VLDISCOVERY;
