-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ vmips.ads                                                                                                 --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with MIPS;
with R3000;

package VMIPS
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

   -- R3000 Status Register IM0..7 --------------------------------------------

   -- IM0
   -- IM1
   -- IM2 Interrupt line 2 (Cause bit 0x0400) is wired to the Clock
   -- IM3 Interrupt line 3 (Cause bit 0x0800) is wired to the #1 Keyboard
   -- IM4 Interrupt line 4 (Cause bit 0x1000) is wired to the #1 Display
   -- IM5 Interrupt line 5 (Cause bit 0x2000) is wired to the #2 Keyboard
   -- IM6 Interrupt line 6 (Cause bit 0x4000) is wired to the #2 Display
   -- IM7 Interrupt line 6 (Cause bit 0x4000) is wired to the High-Resolution Clock

   -- types for devices

   type Device_Control_Type is record
      CTL_RDY : Boolean;
      CTL_IE  : Boolean;
      Unused  : Bits_30;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Device_Control_Type use record
      CTL_RDY at 0 range 0 ..  0;
      CTL_IE  at 0 range 1 ..  1;
      Unused  at 0 range 2 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (Device_Control_Type, Unsigned_32);
   function To_DCT is new Ada.Unchecked_Conversion (Unsigned_32, Device_Control_Type);

   type Device_Data_Type is record
      DATA   : Unsigned_8;
      Unused : Bits_24;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Device_Data_Type use record
      DATA   at 0 range 0 ..  7;
      Unused at 0 range 8 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (Device_Data_Type, Unsigned_32);
   function To_DDT is new Ada.Unchecked_Conversion (Unsigned_32, Device_Data_Type);

   ----------------------------------------------------------------------------
   -- 11.1 SPIM-compatible console device
   ----------------------------------------------------------------------------

   type SPIMCONSOLE_Type is record
      KEYBOARD1_CONTROL : Device_Control_Type with Volatile_Full_Access => True;
      KEYBOARD1_DATA    : Device_Data_Type    with Volatile_Full_Access => True;
      DISPLAY1_CONTROL  : Device_Control_Type with Volatile_Full_Access => True;
      DISPLAY1_DATA     : Device_Data_Type    with Volatile_Full_Access => True;
      KEYBOARD2_CONTROL : Device_Control_Type with Volatile_Full_Access => True;
      KEYBOARD2_DATA    : Device_Data_Type    with Volatile_Full_Access => True;
      DISPLAY2_CONTROL  : Device_Control_Type with Volatile_Full_Access => True;
      DISPLAY2_DATA     : Device_Data_Type    with Volatile_Full_Access => True;
      CLOCK_CONTROL     : Device_Control_Type with Volatile_Full_Access => True;
   end record
      with Size => 9 * 32;
   for SPIMCONSOLE_Type use record
      KEYBOARD1_CONTROL at 16#00# range 0 .. 31;
      KEYBOARD1_DATA    at 16#04# range 0 .. 31;
      DISPLAY1_CONTROL  at 16#08# range 0 .. 31;
      DISPLAY1_DATA     at 16#0C# range 0 .. 31;
      KEYBOARD2_CONTROL at 16#10# range 0 .. 31;
      KEYBOARD2_DATA    at 16#14# range 0 .. 31;
      DISPLAY2_CONTROL  at 16#18# range 0 .. 31;
      DISPLAY2_DATA     at 16#1C# range 0 .. 31;
      CLOCK_CONTROL     at 16#20# range 0 .. 31;
   end record;

   SPIMCONSOLE_BASEADDRESS : constant := 16#0200_0000#;

   SPIMCONSOLE : aliased SPIMCONSOLE_Type
      with Address    => System'To_Address (MIPS.KSEG1_ADDRESS + SPIMCONSOLE_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 11.2 Standard clock device

   type CLOCK_Type is record
      SECONDS_RT   : Unsigned_32         with Volatile_Full_Access => True;
      USECONDS_RT  : Unsigned_32         with Volatile_Full_Access => True;
      SECONDS_ST   : Unsigned_32         with Volatile_Full_Access => True;
      USECONDS_ST  : Unsigned_32         with Volatile_Full_Access => True;
      CONTROL_WORD : Device_Control_Type with Volatile_Full_Access => True;
   end record
      with Size => 5 * 32;
   for CLOCK_Type use record
      SECONDS_RT   at 16#00# range 0 .. 31;
      USECONDS_RT  at 16#04# range 0 .. 31;
      SECONDS_ST   at 16#08# range 0 .. 31;
      USECONDS_ST  at 16#0C# range 0 .. 31;
      CONTROL_WORD at 16#10# range 0 .. 31;
   end record;

   CLOCK_ADDRESS : constant := 16#0101_0000#;

   CLOCK : aliased CLOCK_Type
      with Address    => System'To_Address (MIPS.KSEG1_ADDRESS + CLOCK_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end VMIPS;
