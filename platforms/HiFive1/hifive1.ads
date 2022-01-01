-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ hifive1.ads                                                                                               --
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

package HiFive1 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   GPIO_ADDRESS : constant := 16#1001_2000#;

   LEDs_OEN : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#08#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   LEDs_PORT : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#0C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   LEDs_IOF : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#3C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end HiFive1;
