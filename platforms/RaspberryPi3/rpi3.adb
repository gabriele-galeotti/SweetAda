-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rpi3.adb                                                                                                  --
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

package body RPI3 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Timer_Constant : constant := 2_000_000 / 1_000;
   Timer_Count    : Unsigned_32;

   ----------------------------------------------------------------------------
   -- Timer_Init
   ----------------------------------------------------------------------------
   procedure Timer_Init is
   begin
      Timer_Count := SYSTEM_TIMER.CLO;
   end Timer_Init;

   ----------------------------------------------------------------------------
   -- Timer_Reload
   ----------------------------------------------------------------------------
   procedure Timer_Reload is
   begin
      Timer_Count := Timer_Count + Timer_Constant;
      SYSTEM_TIMER.C1 := Timer_Count;
   end Timer_Reload;

end RPI3;
