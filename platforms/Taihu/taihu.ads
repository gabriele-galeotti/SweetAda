-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ taihu.ads                                                                                                 --
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

with System; use System;
with System.Storage_Elements; use System.Storage_Elements;
with Interfaces; use Interfaces;

package Taihu is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   CPLD_BASEADDRESS  : constant := 16#5010_0000#;
   UART1_BASEADDRESS : constant := 16#EF60_0300#;
   UART2_BASEADDRESS : constant := 16#EF60_0400#;
   IOEMU_BASEADDRESS : constant := 16#5010_0800#;

   ----------------------------------------------------------------------------
   -- IOEMU
   ----------------------------------------------------------------------------

   IOEMU_IO0 : aliased Unsigned_8 with
      Address    => To_Address (IOEMU_BASEADDRESS + 0),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO1 : aliased Unsigned_8 with
      Address    => To_Address (IOEMU_BASEADDRESS + 1),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   IOEMU_IO2 : aliased Unsigned_8 with
      Address    => To_Address (IOEMU_BASEADDRESS + 2),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure Tclk_Init;

end Taihu;
