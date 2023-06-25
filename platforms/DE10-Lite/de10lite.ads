-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ de10lite.ads                                                                                              --
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
with Quartus;

package DE10Lite is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   -- LEDs Avalon Memory Mapped Slave
   LEDs_IO : aliased Unsigned_32 with
      Address    => To_Address (Quartus.leds_s1_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   LEDs_Dir : aliased Unsigned_32 with
      Address    => To_Address (Quartus.leds_s1_ADDRESS + 4),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end DE10Lite;
