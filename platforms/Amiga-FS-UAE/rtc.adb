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

   procedure Time_Read
      (T : out TM_Time)
   is
   begin
      T.Sec   := TM_Sec_Type (MSM6242B.S10.DATA) * 10 + TM_Sec_Type (MSM6242B.S1.DATA);
      T.Min   := TM_Min_Type (MSM6242B.MI10.DATA) * 10 + TM_Min_Type (MSM6242B.MI1.DATA);
      T.Hour  := TM_Hour_Type (MSM6242B.H10.H) * 10 + TM_Hour_Type (MSM6242B.H1.DATA);
      T.MDay  := TM_MDay_Type (MSM6242B.D10.D) * 10 + TM_MDay_Type (MSM6242B.D1.DATA);
      T.Mon   := TM_Mon_Type (MSM6242B.MO10.M) * 10 + TM_Mon_Type (MSM6242B.MO1.DATA);
      T.Year  := TM_Year_Type (MSM6242B.Y10.DATA) * 10 + TM_Year_Type (MSM6242B.Y1.DATA);
      T.Year  := @ + (if @ < 70 then 100 else 0);
      T.WDay  := TM_WDay_Type (MSM6242B.W.DATA);
      T.YDay  := 0;
      T.IsDST := 0;
   end Time_Read;

end RTC;
