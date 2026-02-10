-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ulx3s.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package ULX3S
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
   -- LiteX SoC Project
   ----------------------------------------------------------------------------

   -- LEDS

   -- __INF__ use "ou7" instead of "out"
   type LEDS_OUT_Type is record
      ou7      : Bitmap_8;      -- Led Output(s) Control.
      Reserved : Bits_24  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for LEDS_OUT_Type use record
      ou7      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   LEDS_OUT_ADDRESS : constant := 16#F000_1000#;

   LEDS_OUT : aliased LEDS_OUT_Type
      with Address              => System'To_Address (LEDS_OUT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- UART

   type UART_RXTX_Type is record
      rxtx     : Unsigned_8;
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_RXTX_Type use record
      rxtx     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   type UART_TXFULL_Type is record
      txfull   : Boolean; -- TX FIFO Full.
      Reserved : Bits_31;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_TXFULL_Type use record
      txfull   at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   type UART_RXEMPTY_Type is record
      rxempty  : Boolean; -- RX FIFO Empty.
      Reserved : Bits_31;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_RXEMPTY_Type use record
      rxempty  at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   type UART_EV_STATUS_Type is record
      tx       : Boolean; -- Level of the tx event
      rx       : Boolean; -- Level of the rx event
      Reserved : Bits_30;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_EV_STATUS_Type use record
      tx       at 0 range 0 ..  0;
      rx       at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   type UART_EV_PENDING_Type is record
      tx       : Boolean := False; -- 1 if a tx event occurred. This Event is level triggered when the signal is high.
      rx       : Boolean := False; -- 1 if a rx event occurred. This Event is level triggered when the signal is high.
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_EV_PENDING_Type use record
      tx       at 0 range 0 ..  0;
      rx       at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   type UART_EV_ENABLE_Type is record
      tx       : Boolean := False; -- Write a 1 to enable the tx Event
      rx       : Boolean := False; -- Write a 1 to enable the rx Event
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_EV_ENABLE_Type use record
      tx       at 0 range 0 ..  0;
      rx       at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   type UART_TXEMPTY_Type is record
      txempty  : Boolean; -- TX FIFO Empty.
      Reserved : Bits_31;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_TXEMPTY_Type use record
      txempty  at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   type UART_RXFULL_Type is record
      rxfull   : Boolean; -- RX FIFO Full.
      Reserved : Bits_31;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for UART_RXFULL_Type use record
      rxfull   at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   type UART_Type is record
      RXTX       : UART_RXTX_Type       with Volatile_Full_Access => True;
      TXFULL     : UART_TXFULL_Type     with Volatile_Full_Access => True;
      RXEMPTY    : UART_RXEMPTY_Type    with Volatile_Full_Access => True;
      EV_STATUS  : UART_EV_STATUS_Type  with Volatile_Full_Access => True;
      EV_PENDING : UART_EV_PENDING_Type with Volatile_Full_Access => True;
      EV_ENABLE  : UART_EV_ENABLE_Type  with Volatile_Full_Access => True;
      TXEMPTY    : UART_TXEMPTY_Type    with Volatile_Full_Access => True;
      RXFULL     : UART_RXFULL_Type     with Volatile_Full_Access => True;
   end record
      with Object_Size => 8 * 32;
   for UART_Type use record
      RXTX       at 16#00# range 0 .. 31;
      TXFULL     at 16#04# range 0 .. 31;
      RXEMPTY    at 16#08# range 0 .. 31;
      EV_STATUS  at 16#0C# range 0 .. 31;
      EV_PENDING at 16#10# range 0 .. 31;
      EV_ENABLE  at 16#14# range 0 .. 31;
      TXEMPTY    at 16#18# range 0 .. 31;
      RXFULL     at 16#1C# range 0 .. 31;
   end record;

   UART_BASEADDRESS : constant := 16#F000_2800#;

   UART : aliased UART_Type
      with Address    => System'To_Address (UART_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end ULX3S;
