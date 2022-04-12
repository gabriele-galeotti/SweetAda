-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zoom.ads                                                                                                  --
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

with System;
with System.Storage_Elements;
with Interfaces;

package ZOOM is

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

   ----------------------------------------------------------------------------
   -- The MCF5373-10 CARD ENGINE has a latch (U7) connected to CS1 @
   -- 0x1000_0000, activated by addressing the offset 0x0008_0000.
   -- In order to use the LEDs on the ZOOM, it must be enabled (/2OE active
   -- low) by lowering the MFP9 - TIN3/TOUT3 pin on the GPIO module, which is
   -- normally assigned to the DMA timers.
   ----------------------------------------------------------------------------
   LED : aliased Unsigned_16 with
      Address    => To_Address (16#1008_0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end ZOOM;
