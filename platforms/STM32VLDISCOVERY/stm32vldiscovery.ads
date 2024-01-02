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

package STM32VLDISCOVERY
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
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- 23 Universal synchronous asynchronous receiver transmitter (USART)
   ----------------------------------------------------------------------------

   -- 23.6.1 Status register (USART_SR)

   type USART_SR_Type is record
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
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_SR_Type use record
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

   type USART_DR_Type is record
      DR       : Unsigned_8;   -- Data value
      DR8      : Bits_1;       -- 9th bit
      Reserved : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_DR_Type use record
      DR       at 0 range 0 ..  7;
      DR8      at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- 23.6.3 Baud rate register (USART_BRR)

   type USART_BRR_Type is record
      DIV_Fraction : Bits_4;       -- fraction of USARTDIV
      DIV_Mantissa : Bits_12;      -- mantissa of USARTDIV
      Reserved     : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_BRR_Type use record
      DIV_Fraction at 0 range  0 ..  3;
      DIV_Mantissa at 0 range  4 .. 15;
      Reserved     at 0 range 16 .. 31;
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

   type USART_CR1_Type is record
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
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_CR1_Type use record
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

   -- 23.6.5 Control register 2 (USART_CR2)

   LBDL_10 : constant := 0; -- 10-bit break detection
   LBDL_11 : constant := 1; -- 11-bit break detection

   CPHA_1ST : constant := 0; -- The first clock transition is the first data capture edge
   CPHA_2ND : constant := 1; -- The second clock transition is the first data capture edge

   CPOL_LOW  : constant := 0; -- Steady low value on CK pin outside transmission window
   CPOL_HIGH : constant := 1; -- Steady high value on CK pin outside transmission window

   STOP_1  : constant := 2#00#; -- 1 stop bit
   STOP_05 : constant := 2#01#; -- 0.5 stop bit
   STOP_2  : constant := 2#10#; -- 2 stop bits
   STOP_15 : constant := 2#11#; -- 1.5 stop bits

   type USART_CR2_Type is record
      ADD       : Bits_4;       -- Address of the USART node
      Reserved1 : Bits_1 := 0;
      LBDL      : Bits_1;       -- lin break detection length
      LBDIE     : Boolean;      -- LIN break detection interrupt enable
      Reserved2 : Bits_1 := 0;
      LBCL      : Boolean;      -- Last bit clock pulse
      CPHA      : Bits_1;       -- Clock phase
      CPOL      : Bits_1;       -- Clock polarity
      CLKEN     : Boolean;      -- Clock enable
      STOP      : Bits_2;       -- STOP bits
      LINEN     : Boolean;      -- LIN mode enable
      Reserved3 : Bits_17 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_CR2_Type use record
      ADD       at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  4;
      LBDL      at 0 range  5 ..  5;
      LBDIE     at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      LBCL      at 0 range  8 ..  8;
      CPHA      at 0 range  9 ..  9;
      CPOL      at 0 range 10 .. 10;
      CLKEN     at 0 range 11 .. 11;
      STOP      at 0 range 12 .. 13;
      LINEN     at 0 range 14 .. 14;
      Reserved3 at 0 range 15 .. 31;
   end record;

   -- 23.6.6 Control register 3 (USART_CR3)

   type USART_CR3_Type is record
      EIE      : Boolean;      -- Error interrupt enable
      IREN     : Boolean;      -- IrDA mode enable
      IRLP     : Boolean;      -- IrDA low-power
      HDSEL    : Boolean;      -- Half-duplex selection
      NACK     : Boolean;      -- Smartcard NACK enable
      SCEN     : Boolean;      -- Smartcard mode enable
      DMAR     : Boolean;      -- DMA enable receiver
      DMAT     : Boolean;      -- DMA enable transmitter
      RTSE     : Boolean;      -- RTS enable
      CTSE     : Boolean;      -- CTS enable
      CTSIE    : Boolean;      -- CTS interrupt enable
      ONEBIT   : Boolean;      -- One sample bit method enable
      Reserved : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_CR3_Type use record
      EIE      at 0 range  0 ..  0;
      IREN     at 0 range  1 ..  1;
      IRLP     at 0 range  2 ..  2;
      HDSEL    at 0 range  3 ..  3;
      NACK     at 0 range  4 ..  4;
      SCEN     at 0 range  5 ..  5;
      DMAR     at 0 range  6 ..  6;
      DMAT     at 0 range  7 ..  7;
      RTSE     at 0 range  8 ..  8;
      CTSE     at 0 range  9 ..  9;
      CTSIE    at 0 range 10 .. 10;
      ONEBIT   at 0 range 11 .. 11;
      Reserved at 0 range 12 .. 31;
   end record;

   -- 23.6.7 Guard time and prescaler register (USART_GTPR)

   type USART_GTPR_Type is record
      PSC      : Unsigned_8;   -- Prescaler value
      GT       : Unsigned_8;   -- Guard time value
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for USART_GTPR_Type use record
      PSC      at 0 range  0 ..  7;
      GT       at 0 range  8 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 23.6.8 USART register map

   type USART_Type is record
      USART_SR   : USART_SR_Type   with Volatile_Full_Access => True;
      USART_DR   : USART_DR_Type;
      USART_BRR  : USART_BRR_Type  with Volatile_Full_Access => True;
      USART_CR1  : USART_CR1_Type  with Volatile_Full_Access => True;
      USART_CR2  : USART_CR2_Type  with Volatile_Full_Access => True;
      USART_CR3  : USART_CR3_Type  with Volatile_Full_Access => True;
      USART_GTPR : USART_GTPR_Type with Volatile_Full_Access => True;
   end record
      with Size                    => 16#1C# * 8,
           Suppress_Initialization => True;
   for USART_Type use record
      USART_SR   at 16#00# range 0 .. 31;
      USART_DR   at 16#04# range 0 .. 31;
      USART_BRR  at 16#08# range 0 .. 31;
      USART_CR1  at 16#0C# range 0 .. 31;
      USART_CR2  at 16#10# range 0 .. 31;
      USART_CR3  at 16#14# range 0 .. 31;
      USART_GTPR at 16#18# range 0 .. 31;
   end record;

   USART1_BASEADDRESS : constant := 16#4001_3800#;

   USART1 : aliased USART_Type
      with Address    => To_Address (USART1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end STM32VLDISCOVERY;
