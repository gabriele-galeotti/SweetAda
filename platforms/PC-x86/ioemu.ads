-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ioemu.ads                                                                                                 --
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

package IOEMU
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- GPIO IO0..IO7 0x0270..0x0277
   IO0_ADDRESS : constant := 16#0270#;
   IO1_ADDRESS : constant := 16#0271#;
   IO2_ADDRESS : constant := 16#0272#;
   IO3_ADDRESS : constant := 16#0273#;
   IO4_ADDRESS : constant := 16#0274#;
   IO5_ADDRESS : constant := 16#0275#;
   IO6_ADDRESS : constant := 16#0276#;
   IO7_ADDRESS : constant := 16#0277#;

end IOEMU;
