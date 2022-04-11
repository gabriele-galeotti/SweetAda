-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sun4m.adb                                                                                                 --
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

package body Sun4m is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- System_Timer_ClearLR
   ----------------------------------------------------------------------------
   -- pp. 6-41 Counter-Timers
   -- "The interrupt is cleared and the limit bits reset by reading the
   -- appropriate limit register."
   ----------------------------------------------------------------------------
   procedure System_Timer_ClearLR is
      Unused : Slavio_Timer_Limit_Type with Unreferenced => True;
   begin
      Unused := System_Timer.Limit;
   end System_Timer_ClearLR;

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
   begin
      System_Timer.Limit.Limit := 16#0020_0000#;
   end Tclk_Init;

end Sun4m;
