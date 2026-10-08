-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.adb                                                                                                  --
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

package body Time
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- time in seconds
   MINUTE2S : constant := 60;           -- 60
   HOUR2S   : constant := 60 * 60;      -- 3_600
   DAY2S    : constant := 24 * 60 * 60; -- 86_400

   type Month_Idx_Type is range 1 .. MONTH_PER_YEAR + 1;

   Days_In_Month : constant array (Mon_Type) of Natural :=
      [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

   Days_In_Year : constant array (Month_Idx_Type) of Natural :=
      [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, DAYS_PER_YEAR];

   function Is_Leap_Year
      (Year : Year_Type)
      return Boolean;

   function Leap_Days
      (Year : Year_Type)
      return Natural;

   function Leap_Days_since1970
      (Year : Year_Type)
      return Natural;

   function Days_Of_YearMonth
      (Year  : Year_Type;
       Month : Mon_Type)
      return Natural;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Return whether year is a leap year.
   ----------------------------------------------------------------------------
   function Is_Leap_Year
      (Year : Year_Type)
      return Boolean
      is
   begin
      return
         (Year mod 4 = 0 and then Year mod 100 /= 0)
         or else
         Year mod 400 = 0;
   end Is_Leap_Year;

   ----------------------------------------------------------------------------
   -- Return the number of leap days.
   ----------------------------------------------------------------------------
   function Leap_Days
      (Year : Year_Type)
      return Natural
      is
   begin
      return Natural (Year / 4 - Year / 100 + Year / 400);
   end Leap_Days;

   ----------------------------------------------------------------------------
   -- Return the number of leap days since 1970-01-01.
   ----------------------------------------------------------------------------
   function Leap_Days_since1970
      (Year : Year_Type)
      return Natural
      is
      Leap_Days_until1970 : constant := 477;
   begin
      return Leap_Days (Year) - Leap_Days_until1970;
   end Leap_Days_since1970;

   ----------------------------------------------------------------------------
   -- Days_Of_YearMonth
   ----------------------------------------------------------------------------
   function Days_Of_YearMonth
      (Year  : Year_Type;
       Month : Mon_Type)
      return Natural
      is
      February_29 : Natural range 0 .. 1;
   begin
      February_29 := (if Is_Leap_Year (Year) and then Month = 2 then 1 else 0);
      return Days_In_Month (Month) + February_29;
   end Days_Of_YearMonth;

   ----------------------------------------------------------------------------
   -- Date2Days
   ----------------------------------------------------------------------------
   function Date2Days
      (D : MDay_Type;
       M : Mon_Type;
       Y : Year_Type)
      return Natural
      is
   begin
      return
         Natural (Y - 1_970) * DAYS_PER_YEAR                +
         Leap_Days_since1970 (Y - 1)                        +
         Days_In_Year (Month_Idx_Type (M))                  +
         Natural (D) - 1                                    +
         (if Is_Leap_Year (Y) and then M > 2 then 1 else 0)
         ;
   end Date2Days;

   ----------------------------------------------------------------------------
   -- NDay_Of_Week
   ----------------------------------------------------------------------------
   function NDay_Of_Week
      (D : MDay_Type;
       M : Mon_Type;
       Y : Year_Type)
      return Natural
      is
   begin
      -- 1970-01-01 = Thursday
      return (Date2Days (D, M, Y) + 3) mod DAYS_PER_WEEK + 1;
   end NDay_Of_Week;

   ----------------------------------------------------------------------------
   -- Make_Time
   ----------------------------------------------------------------------------
   function Make_Time
      (Year : Year_Type;
       Mon  : Mon_Type;
       Day  : MDay_Type;
       Hour : Hour_Type;
       Min  : Min_Type;
       Sec  : Sec_Type)
      return Natural
      is
   begin
      return Date2Days (Day, Mon, Year) * DAY2S +
             Natural (Hour) * HOUR2S            +
             Natural (Min) * MINUTE2S           +
             Natural (Sec);
   end Make_Time;

   ----------------------------------------------------------------------------
   -- Make_Time
   ----------------------------------------------------------------------------
   procedure Make_Time
      (T  : in     Unsigned_32;
       TM :    out TM_Time)
      is
      Seconds        : Natural := Natural (T);
      Minutes        : Natural;
      Hours          : Natural;
      Days           : Natural;
      Months         : Natural;
      Year_minus1970 : Year_Type;
      Year           : Year_Type;
   begin
      Days := Seconds / DAY2S;
      Seconds := @ - Days * DAY2S;
      TM.WDay := TM_WDay_Type ((Days + 4) mod DAYS_PER_WEEK);
      Year_minus1970 := Year_Type (Days / DAYS_PER_YEAR);
      Year := Year_minus1970 + 1_970;
      Days := @ - (Natural (Year_minus1970) * DAYS_PER_YEAR + Leap_Days_since1970 (Year - 1));
      if Days < 0 then
         Year := @ - 1;
         Days := @ + DAYS_PER_YEAR + (if Is_Leap_Year (Year) then 1 else 0);
      end if;
      TM.Year := TM_Year_Type (Year - 1_900);
      TM.YDay := TM_YDay_Type (Days);
      Months := 0;
      for Month in Mon_Type'Range loop
         declare
            TDays : Integer;
         begin
            TDays := Days - Days_Of_YearMonth (Year, Month);
            if TDays < 0 then
               Months := Natural (Month) - 1;
               exit;
            end if;
            Days := TDays;
         end;
      end loop;
      TM.Mon := TM_Mon_Type (Months);
      TM.MDay := TM_MDay_Type (Days + 1);
      Hours := Seconds / HOUR2S;
      TM.Hour := TM_Hour_Type (Seconds / HOUR2S);
      Seconds := @ - Hours * HOUR2S;
      Minutes := Seconds / MINUTE2S;
      TM.Min := TM_Min_Type (Minutes);
      TM.Sec := TM_Sec_Type (Seconds - Minutes * MINUTE2S);
      TM.IsDST := -1;
   end Make_Time;

end Time;
