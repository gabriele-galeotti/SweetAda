-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rtc.adb                                                                                                   --
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

with Ada.Unchecked_Conversion;

package body RTC
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

   procedure Read_Clock
      (TM : out TM_Time)
      is
pragma Warnings (Off);
      function To_N is new Ada.Unchecked_Conversion (Bits_1, Natural);
      function To_N is new Ada.Unchecked_Conversion (Bits_2, Natural);
      function To_N is new Ada.Unchecked_Conversion (Bits_3, Natural);
      function To_N is new Ada.Unchecked_Conversion (Bits_4, Natural);
pragma Warnings (On);
   begin
      TM.Sec   := To_N (MSM6242B.S10.DATA) * 10 + To_N (MSM6242B.S1.DATA);
      TM.Min   := To_N (MSM6242B.MI10.DATA) * 10 + To_N (MSM6242B.MI1.DATA);
      TM.Hour  := To_N (MSM6242B.H10.H) * 10 + To_N (MSM6242B.H1.DATA);
      TM.MDay  := To_N (MSM6242B.D10.D) * 10 + To_N (MSM6242B.D1.DATA);
      TM.Mon   := To_N (MSM6242B.MO10.M) * 10 + To_N (MSM6242B.MO1.DATA);
      TM.Year  := To_N (MSM6242B.Y10.DATA) * 10 + To_N (MSM6242B.Y1.DATA);
      TM.WDay  := To_N (MSM6242B.W.DATA);
      TM.YDay  := 0;
      TM.IsDST := 0;
   end Read_Clock;

end RTC;
