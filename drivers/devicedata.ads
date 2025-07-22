-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ devicedata.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package Devicedata
   with Pure => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- STM29W160EB Flash ROM
   STM29W160EB_Manufacturer : constant := 16#0020#;
   STM29W160EB_DeviceCode   : constant := 16#2249#;

   -- National DP83484I EPLT
   DP83484I_ID : constant := 16#2000_5C90#;

   -- Micrel KS8721BL/SL MII PLT
   KS8721BLSL_ID : constant := 16#0022_1619#;

   -- Micrel KSZ8081RNA/RND
   KS8081RNAD_ID_REVA2 : constant := 16#0022_1560#;
   KS8081RNAD_ID_REVA3 : constant := 16#0022_1561#;

end Devicedata;
