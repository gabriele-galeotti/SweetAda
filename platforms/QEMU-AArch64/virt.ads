-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ virt.ads                                                                                                  --
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
with Bits;
with GIC;

package Virt is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;
   use GIC;

   GIC_BASEADDRESS : constant := 16#0800_0000#;

   GICD_CTLR      : aliased GICD_CTLR_Type with
      Address              => To_Address (GIC_BASEADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICD_ISENABLER : aliased Bitmap_32 with
      Address              => To_Address (GIC_BASEADDRESS + 16#0000_0100#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICD_ICPENDR   : aliased Bitmap_32 with
      Address              => To_Address (GIC_BASEADDRESS + 16#0000_0280#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICC_CTLR      : aliased GICC_CTLR_Type with
      Address              => To_Address (GIC_BASEADDRESS + 16#0001_0000#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICC_PMR       : aliased GICC_PMR_Type with
      Address              => To_Address (GIC_BASEADDRESS + 16#0001_0004#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PL011_UART0_BASEADDRESS : constant := 16#0900_0000#;

   procedure Timer_Reload;

end Virt;
