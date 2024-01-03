-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ioemu.ads                                                                                                 --
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

with System.Storage_Elements;
with Interfaces;

package IOEMU
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   IOEMU_ASIC_BASEADDRESS : constant := 16#005F_6900#;

   -- IO0 0x005F6940 8-bit wide port
   IO0 : Unsigned_8
      with Address    => To_Address (IOEMU_ASIC_BASEADDRESS + 16#40#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- IO1 0x005F6944 8-bit wide port
   IO1 : Unsigned_8
      with Address    => To_Address (IOEMU_ASIC_BASEADDRESS + 16#44#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- IO2 0x005F6948 8-bit wide port
   IO2 : Unsigned_8
      with Address    => To_Address (IOEMU_ASIC_BASEADDRESS + 16#48#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end IOEMU;
