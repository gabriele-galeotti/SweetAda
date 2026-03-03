-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ msim.ads                                                                                                  --
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

package MSIM
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
   -- MSIM
   ----------------------------------------------------------------------------

   -- Character output device dprinter

   -- __INF__ use "charact3r" instead of "character"
   type dprinter_Type is record
      charact3r : Unsigned_8;      -- Character to be printed on the standard output of MSIM
      Unused    : Bits_24    := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for dprinter_Type use record
      charact3r at 0 range 0 ..  7;
      Unused    at 0 range 8 .. 31;
   end record;

   dprinter_ADDRESS : constant := 16#1000_0000#;

   dprinter : aliased dprinter_Type
      with Address              => System'To_Address (dprinter_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Character input device dkeyboard

   type dkeyboard_Type is record
      keycode : Unsigned_8;      -- Key code of the pressed key (any read operation deasserts the pending interrupt)
      Unused  : Bits_24    := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for dkeyboard_Type use record
      keycode at 0 range 0 ..  7;
      Unused  at 0 range 8 .. 31;
   end record;

   dkeyboard_ADDRESS : constant := 16#1000_0000#;

   dkeyboard : aliased dkeyboard_Type
      with Address              => System'To_Address (dkeyboard_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- LCD display dlcd

   type dlcd_Type is record
      Data     : Unsigned_8 with Volatile_Full_Access => True; -- Write a character/command to the display
      RS       : Unsigned_8 with Volatile_Full_Access => True; -- Selects the purpose of the data register: 0: command register, 1: data register
      RW       : Unsigned_8 with Volatile_Full_Access => True; -- 0 = write to the display, 1 = read from the display (not supported)
      E        : Unsigned_8 with Volatile_Full_Access => True; -- Causes the display to process the data written to the data register. This happens on a falling edge.
      Reserved : Pad_B5;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16 * 8;
   for dlcd_Type use record
      Data     at 0  range 0 .. 7;
      RS       at 8  range 0 .. 7;
      RW       at 9  range 0 .. 7;
      E        at 10 range 0 .. 7;
      Reserved at 11 range 0 .. PAD_B5_SIZE - 1;
   end record;

   dlcd_ADDRESS : constant := 16#1000_0010#;

   dcld : aliased dlcd_Type
      with Address    => System'To_Address (dlcd_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end MSIM;
