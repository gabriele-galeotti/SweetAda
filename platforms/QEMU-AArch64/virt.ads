-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ virt.ads                                                                                                  --
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

with System;
with GICv2;

package Virt
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use GICv2;

   GIC_BASEADDRESS : constant := 16#0800_0000#;

   GICD : aliased GICD_Type
      with Address    => System'To_Address (GIC_BASEADDRESS),
           Import     => True,
           Convention => Ada;

   GICC : aliased GICC_Type
      with Address    => System'To_Address (GIC_BASEADDRESS + 16#0001_0000#),
           Import     => True,
           Convention => Ada;

   PL011_UART0_BASEADDRESS : constant := 16#0900_0000#;

end Virt;
