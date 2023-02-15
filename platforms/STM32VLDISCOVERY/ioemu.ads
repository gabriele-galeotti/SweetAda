-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ioemu.ads                                                                                                 --
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

with System.Storage_Elements;
with Interfaces;

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

   IOEMU_BASEADDRESS : constant := 16#4003_0000#;

   IO0 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 0),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO1 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 1),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO2 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 2),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO3 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 3),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO4 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 4),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO5 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 5),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO6 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 6),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   IO7 : aliased Unsigned_8 with
      Address              => To_Address (IOEMU_BASEADDRESS + 7),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end IOEMU;
