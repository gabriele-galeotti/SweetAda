-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.adb                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
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

   Days_Per_Month : constant array (Natural range 1 .. 12) of Natural :=
      [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

   Days_In_Year : constant array (Natural range 1 .. 13) of Natural :=
      [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];

   function Is_Leap_Year
      (Year : Natural)
      return Boolean;

   function Leap_Days
      (Year : Natural)
      return Natural;

   function Leap_Days_since1970
      (Year : Natural)
      return Natural;

   function Days_In_Month
      (Month : Natural;
       Year  : Natural)
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
      (Year : Natural)
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
      (Year : Natural)
      return Natural
      is
   begin
      return Year / 4 - Year / 100 + Year / 400;
   end Leap_Days;

   ----------------------------------------------------------------------------
   -- Return the number of leap days since 1970-01-01.
   ----------------------------------------------------------------------------
   function Leap_Days_since1970
      (Year : Natural)
      return Natural
      is
      Leap_Days_until1970 : constant := 477;
   begin
      return Leap_Days (Year) - Leap_Days_until1970;
   end Leap_Days_since1970;

   ----------------------------------------------------------------------------
   -- Days_In_Month
   ----------------------------------------------------------------------------
   function Days_In_Month
      (Month : Natural;
       Year  : Natural)
      return Natural
      is
      February_29 : Natural range 0 .. 1;
   begin
      February_29 := (if Is_Leap_Year (Year) and then Month = 2 then 1 else 0);
      return Days_Per_Month (Month) + February_29;
   end Days_In_Month;

   ----------------------------------------------------------------------------
   -- Date2Days
   ----------------------------------------------------------------------------
   function Date2Days
      (D : Natural;
       M : Natural;
       Y : Natural)
      return Natural
      is
   begin
      return
         (Y - 1_970) * 365  +
         Leap_Days_since1970 (Y - 1) +
         Days_In_Year (M) +
         D - 1 +
         (if Is_Leap_Year (Y) and then M > 2 then 1 else 0)
         ;
   end Date2Days;

   ----------------------------------------------------------------------------
   -- NDay_Of_Week
   ----------------------------------------------------------------------------
   function NDay_Of_Week
      (D : Natural;
       M : Natural;
       Y : Natural)
      return Natural
      is
   begin
      return (Date2Days (D, M, Y) + 3) mod 7 + 1;
   end NDay_Of_Week;

   ----------------------------------------------------------------------------
   -- Make_Time
   ----------------------------------------------------------------------------
   function Make_Time
      (Year : Positive;
       Mon  : Positive;
       Day  : Positive;
       Hour : Natural;
       Min  : Natural;
       Sec  : Natural)
      return Natural
      is
   begin
      return Date2Days (Day, Mon, Year) * 86_400 + Hour * 3_600 + Min * 60 + Sec;
   end Make_Time;

   ----------------------------------------------------------------------------
   -- Make_Time
   ----------------------------------------------------------------------------
   procedure Make_Time
      (T  : in     Unsigned_32;
       TM :    out TM_Time)
      is
      Seconds        : Natural := Natural (T);
      Days           : Integer;
      Year_minus1970 : Natural;
      Year           : Natural;
   begin
      Days := Seconds / 86_400;
      Seconds := @ - Days * 86_400;
      TM.WDay := (Days + 4) mod 7;
      Year_minus1970 := Days / 365;
      Year := Year_minus1970 + 1_970;
      Days := @ - (Year_minus1970 * 365 + Leap_Days_since1970 (Year - 1));
      if Days < 0 then
         Year := @ - 1;
         Days := @ + 365 + (if Is_Leap_Year (Year) then 1 else 0);
      end if;
      TM.Year := Year - 1_900;
      TM.YDay := Days;
      TM.Mon := 0;
      for Month in 1 .. 12 loop
         declare
            TDays : Integer;
         begin
            TDays := Days - Days_In_Month (Month, Year);
            if TDays < 0 then
               TM.Mon := Month - 1;
               exit;
            end if;
            Days := TDays;
         end;
      end loop;
      TM.MDay := Days + 1;
      TM.Hour := Seconds / 3_600;
      Seconds := @ - TM.Hour * 3_600;
      TM.Min := Seconds / 60;
      TM.Sec := Seconds - TM.Min * 60;
      TM.IsDST := -1;
   end Make_Time;

end Time;
