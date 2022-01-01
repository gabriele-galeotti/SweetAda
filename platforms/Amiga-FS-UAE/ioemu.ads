-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ioemu.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Interfaces;
with Amiga;

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

   IOEMU_CIA_BASEADDRESS         : constant := Amiga.CIAB_BASEADDRESS + 16#80#;
   IOEMU_SERIALPORT1_BASEADDRESS : constant := Amiga.CIAB_BASEADDRESS + 16#C0#;
   IOEMU_SERIALPORT2_BASEADDRESS : constant := Amiga.CIAB_BASEADDRESS + 16#E0#;

   -- IO0 @ 0x00BFD080
   IOEMU_CIA_IO0 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#00#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO1 @ 0x00BFD084
   IOEMU_CIA_IO1 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#04#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO2 @ 0x00BFD088
   IOEMU_CIA_IO2 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#08#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO3 @ 0x00BFD08C
   IOEMU_CIA_IO3 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#0C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO4 @ 0x00BFD090
   IOEMU_CIA_IO4 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#10#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO5 @ 0x00BFD094
   IOEMU_CIA_IO5 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#14#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO6 @ 0x00BFD098
   IOEMU_CIA_IO6 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#18#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO7 @ 0x00BFD09C
   IOEMU_CIA_IO7 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#1C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end IOEMU;
