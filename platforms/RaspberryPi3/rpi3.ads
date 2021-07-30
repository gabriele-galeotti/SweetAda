-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rpi3.ads                                                                                                  --
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

with System;
with System.Storage_Elements;
with Interfaces;

package RPI3 is

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

   CORE0_MBOX3_SET_BASEADDRESS : constant := 16#4000_008C#;

   PERIPHERALS_BASEADDRESS : constant := 16#3F00_0000#;
   GPIO_BASEADDRESS        : constant := 16#3F00_0000# + 16#0020_0000#;

   GPIO0 : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#00#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIO1 : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#04#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   LEDON : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#1C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   LEDOFF : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#28#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end RPI3;
