-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mpc603e.adb                                                                                               --
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

pragma Restrictions (No_Elaboration_Code);
pragma Warnings (Off, "* is not referenced");
pragma Style_Checks (Off);

package body MPC603e
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function HID0_Read return HID0_Type is function SPR_Read is new MFSPR (HID0, HID0_Type); begin return SPR_Read; end HID0_Read;
   procedure HID0_Write (Value : in HID0_Type) is procedure SPR_Write is new MTSPR (HID0, HID0_Type); begin SPR_Write (Value); end HID0_Write;

   function HID1_Read return HID1_Type is function SPR_Read is new MFSPR (HID1, HID1_Type); begin return SPR_Read; end HID1_Read;
   -- procedure HID1_Write (Value : in HID1_Type) is procedure SPR_Write is new MTSPR (HID1, HID1_Type); begin SPR_Write (Value); end HID1_Write;

end MPC603e;
