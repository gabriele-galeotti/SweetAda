-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with Spartan3E;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      declare
         Delay_Count : constant := 5000000;
      begin
         Spartan3E.LEDs_TS := 16#00#;
         loop
            Spartan3E.LEDs_IO := 16#FF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            Spartan3E.LEDs_IO := 16#0#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
