-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ vmips.ads                                                                                                 --
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
with MIPS;
with R3000;

package VMIPS is

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

   -- R3000 Status Register IM0..7 --------------------------------------------

   -- IM0
   -- IM1
   -- IM2 Interrupt line 2 (Cause bit 0x0400) is wired to the Clock
   -- IM3 Interrupt line 3 (Cause bit 0x0800) is wired to the #1 Keyboard
   -- IM4 Interrupt line 4 (Cause bit 0x1000) is wired to the #1 Display
   -- IM5 Interrupt line 5 (Cause bit 0x2000) is wired to the #2 Keyboard
   -- IM6 Interrupt line 6 (Cause bit 0x4000) is wired to the #2 Display
   -- IM7

   ----------------------------------------------------------------------------
   -- 11.1 SPIM-compatible console device
   ----------------------------------------------------------------------------

   type Device_Control_Type is
   record
      CTL_RDY : Boolean;
      CTL_IE  : Boolean;
      Unused  : Bits_30;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Device_Control_Type use
   record
      CTL_RDY at 0 range 0 .. 0;
      CTL_IE  at 0 range 1 .. 1;
      Unused  at 0 range 2 .. 31;
   end record;

   type Device_Data_Type is
   record
      DATA   : Unsigned_8;
      Unused : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Device_Data_Type use
   record
      DATA   at 0 range 0 .. 7;
      Unused at 0 range 8 .. 31;
   end record;

   type SPIMCONSOLE_Type is
   record
      KEYBOARD1_CONTROL : Device_Control_Type;
      KEYBOARD1_DATA    : Device_Data_Type;
      DISPLAY1_CONTROL  : Device_Control_Type;
      DISPLAY1_DATA     : Device_Data_Type;
   end record with
      Size => 4 * 32;
   for SPIMCONSOLE_Type use
   record
      KEYBOARD1_CONTROL at 0  range 0 .. 31;
      KEYBOARD1_DATA    at 4  range 0 .. 31;
      DISPLAY1_CONTROL  at 8  range 0 .. 31;
      DISPLAY1_DATA     at 12 range 0 .. 31;
   end record;

   SPIMCONSOLE_BASEADDRESS : constant := 16#0200_0000#;

   SPIMCONSOLE : SPIMCONSOLE_Type with
      Address    => To_Address (MIPS.KSEG1_ADDRESS + SPIMCONSOLE_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end VMIPS;
