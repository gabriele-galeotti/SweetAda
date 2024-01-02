-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ de10lite.ads                                                                                              --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
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
with Quartus;

package DE10Lite
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
   use Quartus;

   ----------------------------------------------------------------------------
   -- LEDs Avalon Memory Mapped Slave
   ----------------------------------------------------------------------------

   LEDs_IO : aliased Unsigned_32
      with Address    => To_Address (leds_s1_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   LEDs_Dir : aliased Unsigned_32
      with Address    => To_Address (leds_s1_ADDRESS + 4),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- JTAG UART
   ----------------------------------------------------------------------------

   -- 12.4.4.1. Data Register

   type JTAG_UART_data_Type is record
      DATA     : Unsigned_8 := 0;  -- The value to transfer to/from the JTAG core.
      Reserved : Bits_7 := 0;
      RVALID   : Boolean := False; -- Indicates whether the DATA field is valid.
      RAVAIL   : Unsigned_16 := 0; -- The number of characters remaining in the read FIFO (after the current read).
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for JTAG_UART_data_Type use record
      DATA     at 0 range  0 ..  7;
      Reserved at 0 range  8 .. 14;
      RVALID   at 0 range 15 .. 15;
      RAVAIL   at 0 range 16 .. 31;
   end record;

   -- 12.4.4.2. Control Register

   type JTAG_UART_control_Type is record
      RE        : Boolean := False; -- Interrupt-enable bit for read interrupts.
      WE        : Boolean := False; -- Interrupt-enable bit for write interrupts.
      Reserved1 : Bits_6 := 0;
      RI        : Boolean := False; -- Indicates that the read interrupt is pending.
      WI        : Boolean := False; -- Indicates that the write interrupt is pending.
      AC        : Boolean := False; -- Indicates that there has been JTAG activity since the bit was cleared.
      Reserved2 : Bits_5 := 0;
      WSPACE    : Unsigned_16 := 0; -- The number of spaces available in the write FIFO.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for JTAG_UART_control_Type use record
      RE        at 0 range  0 ..  0;
      WE        at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  7;
      RI        at 0 range  8 ..  8;
      WI        at 0 range  9 ..  9;
      AC        at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 15;
      WSPACE    at 0 range 16 .. 31;
   end record;

   -- 12.4.4. Register Map

   type JTAG_UART_Type is record
      data    : JTAG_UART_data_Type    with Volatile_Full_Access => True;
      control : JTAG_UART_control_Type with Volatile_Full_Access => True;
   end record
      with Size => 8 * 8;
   for JTAG_UART_Type use record
      data    at 0 range 0 .. 31;
      control at 4 range 0 .. 31;
   end record;

   JTAG_UART : aliased JTAG_UART_Type
      with Address    => To_Address (jtag_uart_0_avalon_jtag_slave_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end DE10Lite;
