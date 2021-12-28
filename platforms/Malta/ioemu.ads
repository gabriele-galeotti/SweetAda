-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ioemu.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Interfaces;
with MIPS;

package IOEMU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use MIPS;

   IOEMU_IO0 : Unsigned_8 with
      Address    => To_Address (KSEG1_ADDRESS + 16#1F10_0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO1 : Unsigned_8 with
      Address    => To_Address (KSEG1_ADDRESS + 16#1F10_0001#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO2 : Unsigned_8 with
      Address    => To_Address (KSEG1_ADDRESS + 16#1F10_0002#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO3 : Unsigned_8 with
      Address    => To_Address (KSEG1_ADDRESS + 16#1F10_0003#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end IOEMU;
