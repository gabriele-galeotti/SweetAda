-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ power8.ads                                                                                                   --
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

package POWER8
   with Pure => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- 3.6.3.2 Processor ID Register (PIR)

   type PIR_Type is record
      Reserved : Bits_22;
      ChID     : Bits_3;  -- Chip ID
      CoID     : Bits_4;  -- Core number
      TID      : Bits_3;  -- Thread ID
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for PIR_Type use record
      Reserved at 0 range  0 .. 21;
      ChID     at 0 range 22 .. 24;
      CoID     at 0 range 25 .. 28;
      TID      at 0 range 29 .. 31;
   end record;

end CPU;
