-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32.ads                                                                                                 --
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
with Interfaces;
with Bits;

package STM32 is

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

   ----------------------------------------------------------------------------
   -- USART
   ----------------------------------------------------------------------------

   package USART is

      --- STM32VLDISCOVERY: 23.6.1 Status register (USART_SR)

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
         PE       at 0 range 0 .. 0;
         FE       at 0 range 1 .. 1;
         NF       at 0 range 2 .. 2;
         ORE      at 0 range 3 .. 3;
         IDLE     at 0 range 4 .. 4;
         RXNE     at 0 range 5 .. 5;
         TC       at 0 range 6 .. 6;
         TXE      at 0 range 7 .. 7;
         LBD      at 0 range 8 .. 8;
         CTS      at 0 range 9 .. 9;
         Reserved at 0 range 10 .. 31;
      end record;

      -- STM32VLDISCOVERY: 23.6.2 Data register (USART_DR)
      -- STM32F769I: 34.8.10 Receive data register (USART_RDR)
      -- STM32F769I: 34.8.11 Transmit data register (USART_TDR)

      type USART_DR_Type is
      record
         DR       : Unsigned_8;
         DR8      : Bits_1;
         Reserved : Bits_23;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for USART_DR_Type use
      record
         DR       at 0 range 0 .. 7;
         DR8      at 0 range 8 .. 8;
         Reserved at 0 range 9 .. 31;
      end record;

      -- STM32VLDISCOVERY: 23.6.4 Control register 1 (USART_CR1)

      type USART_CR1_F100_Type is
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
      for USART_CR1_F100_Type use
      record
         SM        at 0 range 0 .. 0;
         RWU       at 0 range 1 .. 1;
         RE        at 0 range 2 .. 2;
         TE        at 0 range 3 .. 3;
         IDLEIE    at 0 range 4 .. 4;
         RXNEIE    at 0 range 5 .. 5;
         TCIE      at 0 range 6 .. 6;
         TXEIE     at 0 range 7 .. 7;
         PEIE      at 0 range 8 .. 8;
         PS        at 0 range 9 .. 9;
         PCE       at 0 range 10 .. 10;
         WAKE      at 0 range 11 .. 11;
         M         at 0 range 12 .. 12;
         UE        at 0 range 13 .. 13;
         Reserved1 at 0 range 14 .. 14;
         OVER8     at 0 range 15 .. 15;
         Reserved2 at 0 range 16 .. 31;
      end record;

      -- STM32F769I: 34.8.1 Control register 1 (USART_CR1)

      type USART_CR1_F769I_Type is
      record
         UE       : Boolean;     -- USART enable
         UESM     : Boolean;     -- USART enable in Stop mode
         RE       : Boolean;     -- Receiver enable
         TE       : Boolean;     -- Transmitter enable
         IDLEIE   : Boolean;     -- IDLE interrupt enable
         RXNEIE   : Boolean;     -- RXNE interrupt enable
         TCIE     : Boolean;     -- Transmission complete interrupt enable
         TXEIE    : Boolean;     -- interrupt enable
         PEIE     : Boolean;     -- PE interrupt enable
         PS       : Bits_1;      -- Parity selection
         PCE      : Boolean;     -- Parity control enable
         WAKE     : Bits_1;      -- Receiver wakeup method
         M0       : Bits_1;      -- Word length
         MME      : Boolean;     -- Mute mode enable
         CMIE     : Boolean;     -- Character match interrupt enable
         OVER8    : Bits_1;      -- Oversampling mode
         DEDT     : Bits_5;      -- Driver Enable de-assertion time
         DEAT     : Bits_5;      -- Driver Enable assertion time
         RTOIE    : Boolean;     -- Receiver timeout interrupt enable
         EOBIE    : Boolean;     -- End of Block interrupt enable
         M1       : Bits_1;      -- Word length
         Reserved : Bits_3 := 0;
      end record with
         Bit_Order => Low_Order_First,
         Size      => 32;
      for USART_CR1_F769I_Type use
      record
         UE       at 0 range 0 .. 0;
         UESM     at 0 range 1 .. 1;
         RE       at 0 range 2 .. 2;
         TE       at 0 range 3 .. 3;
         IDLEIE   at 0 range 4 .. 4;
         RXNEIE   at 0 range 5 .. 5;
         TCIE     at 0 range 6 .. 6;
         TXEIE    at 0 range 7 .. 7;
         PEIE     at 0 range 8 .. 8;
         PS       at 0 range 9 .. 9;
         PCE      at 0 range 10 .. 10;
         WAKE     at 0 range 11 .. 11;
         M0       at 0 range 12 .. 12;
         MME      at 0 range 13 .. 13;
         CMIE     at 0 range 14 .. 14;
         OVER8    at 0 range 15 .. 15;
         DEDT     at 0 range 16 .. 20;
         DEAT     at 0 range 21 .. 25;
         RTOIE    at 0 range 26 .. 26;
         EOBIE    at 0 range 27 .. 27;
         M1       at 0 range 28 .. 28;
         Reserved at 0 range 29 .. 31;
      end record;

   end USART;

end STM32;
