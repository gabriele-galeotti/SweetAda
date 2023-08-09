-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ neorv32.ads                                                                                               --
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

package NEORV32 is

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

   type CTRL_Type is
   record
      EN            : Boolean;     -- UART global enable
      SIM_MODE      : Boolean;     -- Simulation output override enable
      HWFC_EN       : Boolean;     -- Enable RTS/CTS hardware flow-control
      PRSC          : Bits_3;      -- clock prescaler select
      BAUD          : Bits_10;     -- BAUD rate divisor
      RX_NEMPTY     : Boolean;     -- RX FIFO not empty
      RX_HALF       : Boolean;     -- RX FIFO at least half-full
      RX_FULL       : Boolean;     -- RX FIFO full
      TX_EMPTY      : Boolean;     -- TX FIFO empty
      TX_NHALF      : Boolean;     -- TX FIFO not at least half-full
      TX_FULL       : Boolean;     -- TX FIFO full
      IRQ_RX_NEMPTY : Boolean;     -- Fire IRQ if RX FIFO not empty
      IRQ_RX_HALF   : Boolean;     -- Fire IRQ if RX FIFO at least half-full
      IRQ_RX_FULL   : Boolean;     -- Fire IRQ if RX FIFO full
      IRQ_TX_EMPTY  : Boolean;     -- Fire IRQ if TX FIFO empty
      IRQ_TX_NHALF  : Boolean;     -- Fire IRQ if TX FIFO not at least half-full
      Reserved      : Bits_3 := 0;
      RX_OVER       : Boolean;     -- RX FIFO overflow
      TX_BUSY       : Boolean;     -- Transmitter busy or TX FIFO not empty
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CTRL_Type use
   record
      EN            at 0 range 0 .. 0;
      SIM_MODE      at 0 range 1 .. 1;
      HWFC_EN       at 0 range 2 .. 2;
      PRSC          at 0 range 3 .. 5;
      BAUD          at 0 range 6 .. 15;
      RX_NEMPTY     at 0 range 16 .. 16;
      RX_HALF       at 0 range 17 .. 17;
      RX_FULL       at 0 range 18 .. 18;
      TX_EMPTY      at 0 range 19 .. 19;
      TX_NHALF      at 0 range 20 .. 20;
      TX_FULL       at 0 range 21 .. 21;
      IRQ_RX_NEMPTY at 0 range 22 .. 22;
      IRQ_RX_HALF   at 0 range 23 .. 23;
      IRQ_RX_FULL   at 0 range 24 .. 24;
      IRQ_TX_EMPTY  at 0 range 25 .. 25;
      IRQ_TX_NHALF  at 0 range 26 .. 26;
      Reserved      at 0 range 27 .. 29;
      RX_OVER       at 0 range 30 .. 30;
      TX_BUSY       at 0 range 31 .. 31;
   end record;

   type DATA_Type is
   record
      RTX          : Unsigned_8;   -- UART receive/transmit data
      RX_FIFO_SIZE : Bits_4 := 0;  -- log2(RX FIFO size)
      TX_FIFO_SIZE : Bits_4 := 0;  -- log2(TX FIFO size)
      Reserved     : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DATA_Type use
   record
      RTX          at 0 range 0 .. 7;
      RX_FIFO_SIZE at 0 range 8 .. 11;
      TX_FIFO_SIZE at 0 range 12 .. 15;
      Reserved     at 0 range 16 .. 31;
   end record;

   type UART_Type is
   record
      CTRL : CTRL_Type with Volatile => True;
      DATA : DATA_Type with Volatile => True;
   end record
      with Size => 2 * 32;
   for UART_Type use
   record
      CTRL at 0 range 0 .. 31;
      DATA at 4 range 0 .. 31;
   end record;

   UART0_BASEADDRESS : constant := 16#FFFF_F500#;

   UART0 : aliased UART_Type
      with Address    => To_Address (UART0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end NEORV32;
