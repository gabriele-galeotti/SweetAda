-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ spartan3a.ads                                                                                             --
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
with Interfaces;
with Bits;

package Spartan3A
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

   type GPIO_Type is record
      GPIO_DATA  : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_TRI   : Bitmap_32 with Volatile_Full_Access => True;
      GPIO2_DATA : Bitmap_32 with Volatile_Full_Access => True;
      GPIO2_TRI  : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Bit_Order => High_Order_First,
           Size      => 16 * 8;
   for GPIO_Type use record
      GPIO_DATA  at 16#00# range 0 .. 31;
      GPIO_TRI   at 16#04# range 0 .. 31;
      GPIO2_DATA at 16#08# range 0 .. 31;
      GPIO2_TRI  at 16#0C# range 0 .. 31;
   end record;

   LEDs_BASEADDRESS : constant := 16#8142_0000#;

   LEDs : aliased GPIO_Type
      with Address    => System'To_Address (LEDs_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end Spartan3A;
