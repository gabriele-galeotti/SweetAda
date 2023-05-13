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

   SPIMCONSOLE_KEYBOARD1_CONTROL : Unsigned_32 with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + 16#0200_0000#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   SPIMCONSOLE_KEYBOARD1_DATA : Unsigned_32 with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + 16#0200_0004#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   SPIMCONSOLE_DISPLAY1_CONTROL : Unsigned_32 with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + 16#0200_0008#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   SPIMCONSOLE_DISPLAY1_DATA : Unsigned_32 with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + 16#0200_000C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end VMIPS;
