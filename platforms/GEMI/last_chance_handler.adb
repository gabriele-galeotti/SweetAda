-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ last_chance_handler.adb                                                                                   --
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

with Interfaces;
with SH;
with GEMI;

package body Last_Chance_Handler is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Last_Chance_Handler
   ----------------------------------------------------------------------------
   procedure Last_Chance_Handler (Source_Location : in System.Address; Line : in Integer) is
      pragma Unreferenced (Source_Location);
      pragma Unreferenced (Line);
      Delay_Count : constant := 30_000;
      Value       : Unsigned_8 := 16#F0#;
   begin
      loop
         GEMI.LEDPORT := Value;
         for Delay_Loop_Count in 1 .. Delay_Count loop
            SH.NOP;
         end loop;
         Value := Value xor 16#10#;
      end loop;
   end Last_Chance_Handler;

end Last_Chance_Handler;
