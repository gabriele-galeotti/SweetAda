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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- Embedded Peripherals IP User Guide
   -- ID 683130 Date 12/13/2021 Version 21.4
   ----------------------------------------------------------------------------

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
   -- 12. JTAG UART Core
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

   ----------------------------------------------------------------------------
   -- 23. Interval Timer Core
   ----------------------------------------------------------------------------

   type ITC_status_Type is record
      TO       : Boolean;      -- The TO (timeout) bit is set to 1 when the internal counter reaches zero.
      RUN      : Boolean;      -- The RUN bit reads as 1 when the internal counter is running; otherwise this bit reads as 0.
      Reserved : Bits_14 := 0;
   end record
      with Size => 16;
   for ITC_status_Type use record
      TO       at 0 range  0 ..  0;
      RUN      at 0 range  1 ..  1;
      Reserved at 0 range  2 .. 15;
   end record;

   type ITC_control_Type is record
      ITO      : Boolean;      -- If the ITO bit is 1, the interval timer core generates an IRQ when the status register’s TO bit is 1. When the ITO bit is 0, the timer does not generate IRQs.
      CONT     : Boolean;      -- The CONT (continuous) bit determines how the internal counter behaves when it reaches zero.
      START    : Boolean;      -- Writing a 1 to the START bit starts the internal counter running (counting down).
      STOP     : Boolean;      -- Writing a 1 to the STOP bit stops the internal counter.
      Reserved : Bits_12 := 0;
   end record
      with Size => 16;
   for ITC_control_Type use record
      ITO      at 0 range  0 ..  0;
      CONT     at 0 range  1 ..  1;
      START    at 0 range  2 ..  2;
      STOP     at 0 range  3 ..  3;
      Reserved at 0 range  4 .. 15;
   end record;

   type Interval_Timer32_Type is record
      status  : ITC_status_Type  with Volatile_Full_Access => True;
      control : ITC_control_Type with Volatile_Full_Access => True;
      periodl : Unsigned_16      with Volatile_Full_Access => True;
      periodh : Unsigned_16      with Volatile_Full_Access => True;
      snapl   : Unsigned_16      with Volatile_Full_Access => True;
      snaph   : Unsigned_16      with Volatile_Full_Access => True;
   end record
      with Size => 5 * 32 + 16;
   for Interval_Timer32_Type use record
      status  at 16#00# range 0 .. 15;
      control at 16#04# range 0 .. 15;
      periodl at 16#08# range 0 .. 15;
      periodh at 16#0C# range 0 .. 15;
      snapl   at 16#10# range 0 .. 15;
      snaph   at 16#14# range 0 .. 15;
   end record;

   Timer : aliased Interval_Timer32_Type
      with Address    => To_Address (timer_0_s1_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end DE10Lite;
