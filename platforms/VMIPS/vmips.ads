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

   type SPIMCONSOLE_Type is
   record
      KEYBOARD1_CONTROL : Device_Control_Type;
      KEYBOARD1_DATA    : Unsigned_32;
      DISPLAY1_CONTROL  : Device_Control_Type;
      DISPLAY1_DATA     : Unsigned_32;
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
