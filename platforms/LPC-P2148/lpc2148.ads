-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lpc2148.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Definitions;
with Bits;

package LPC2148
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
   use Definitions;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- UM10139
   -- LPC214x User manual
   -- Rev. 4 — 23 April 2012
   ----------------------------------------------------------------------------

   IO0SET : aliased Bitmap_32
      with Address              => To_Address (16#E002_8004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IO0DIR : aliased Bitmap_32
      with Address              => To_Address (16#E002_8008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IO0CLR : aliased Bitmap_32
      with Address              => To_Address (16#E002_800C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

pragma Style_Checks (On);

end LPC2148;
