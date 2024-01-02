-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ghrd.adb                                                                                                  --
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

package body GHRD is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init
      is
      Period : constant Unsigned_32 :=
         (Configure.TIMER_SYSCLK + Configure.TICK_FREQUENCY / 2) /
         Configure.TICK_FREQUENCY
         - 1;
   begin
      GHRD.Timer.Control := (
         STOP   => True,
         others => <>
         );
      GHRD.Timer.PeriodH := Period / 2**16;
      GHRD.Timer.PeriodL := Period mod 2**16;
      GHRD.Timer.Control := (
         ITO    => True,
         CONT   => True,
         START  => True,
         others => <>
         );
   end Tclk_Init;

end GHRD;
