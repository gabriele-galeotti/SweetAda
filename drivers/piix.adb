-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ piix.adb                                                                                                  --
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

package body PIIX is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   function Probe
      return Boolean
      is
      Success       : Boolean;
      Device_Number : Device_Number_Type with Unreferenced => True;
   begin
      Cfg_Find_Device_By_Id (
         BUS0,
         VENDOR_ID_INTEL,
         DEVICE_ID_PIIX3,
         Device_Number,
         Success
         );
      return Success;
   end Probe;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Pirqc : constant PIRQC_Type := (
                          IRQROUTE   => IRQROUTE_RESERVED1,
                          IRQROUTEEN => NFalse,
                          others     => <>
                          );
   begin
      -- Bus_Number, Device_Number, Function_Number, Register_Number, Value
      Cfg_Write (BUS0, 1, 0, PIRQRCA, To_U8 (Pirqc));
      Cfg_Write (BUS0, 1, 0, PIRQRCB, To_U8 (Pirqc));
      Cfg_Write (BUS0, 1, 0, PIRQRCC, To_U8 (Pirqc));
      Cfg_Write (BUS0, 1, 0, PIRQRCD, To_U8 (Pirqc));
   end Init;

end PIIX;
