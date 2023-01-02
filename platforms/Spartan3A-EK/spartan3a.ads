-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ spartan3a.ads                                                                                             --
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

package Spartan3A is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   LEDS_IO_BASEADDRESS : constant := 16#8142_0000# + 3;
   LEDS_TS_BASEADDRESS : constant := 16#8142_0004# + 3;

   -- LEDs
   LEDs_IO : Unsigned_8 with
      Address    => To_Address (LEDS_IO_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   LEDs_TS : Unsigned_8 with
      Address    => To_Address (LEDS_TS_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end Spartan3A;
