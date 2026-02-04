-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rtc.adb                                                                                                   --
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

with S5D9;

package body RTC
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use S5D9;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      -- Sub-Clock Oscillator -------------------------------------------------
      SOSCCR.SOSTP := True;            -- SOSC = stopped
      SOMCR.SODRV1 := SODRV1_STANDARD; -- standard drive
      SOSCCR.SOSTP := False;           -- SOSC = operating
      -- Clock and Count Mode Setting Procedure -------------------------------
      RCR4.RCKSEL := RCKSEL_SOSC;
      -- supply 6 clocks of the clock selected by the RCR4.RCKSEL bit
      RCR2 := (
         START  => False,
         CNTMD  => CNTMD_CALENDAR,
         others => <>
         );
      loop exit when not RCR2.START; end loop;
      RCR2.RESET := True;
      loop exit when not RCR2.RESET; end loop;
      -- Setting the Time
      RSECCNT := (SEC1 => 0, SEC10 => 0, others => <>);
      RMINCNT := (MIN1 => 0, MIN10 => 0, others => <>);
      RHRCNT := (HR1 => 0, HR10 => 0, others => <>);
      RCR2.START := True;
      loop exit when RCR2.START; end loop;
   end Init;

end RTC;
