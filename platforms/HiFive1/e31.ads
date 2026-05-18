-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ e31.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;

package E31
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- SiFive E31 Manual v19.08p0
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Chapter 8 Custom Instructions
   ----------------------------------------------------------------------------

   -- 8.1 CFLUSH.D.L1

   procedure CFLUSH_D_L1
      (VAddress : in Integer_Address)
      with Inline => True;

   -- 8.2 CDISCARD.D.L1

   procedure CDISCARD_D_L1
      (VAddress : in Integer_Address)
      with Inline => True;

pragma Style_Checks (On);

end E31;
