-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.adb                                                                                                  --
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

package body Time is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   NSECONDS_1970_2000 : constant := 946_684_800; -- Sat Jan 1 00:00:00 UTC 2000

   function Date2Days (
                       D : Natural;
                       M : Natural;
                       Y : Natural
                      ) return Natural;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Make_Time
   ----------------------------------------------------------------------------
   -- Taken from the analogous function in Linux kernel 2.0.
   -- Converts Gregorian date to seconds since 1970-01-01 00:00:00.
   -- Assumes input in normal date format, i.e. 1980-12-31 23:59:59
   -- => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
   ----------------------------------------------------------------------------
   function Make_Time (
                       Year   : Positive;
                       Month  : Positive;
                       Day    : Positive;
                       Hour   : Natural;
                       Minute : Natural;
                       Second : Natural
                      ) return Natural is
      Y : Natural := Year;
      M : Natural := Month;
   begin
      if M <= 2 then
         M := @ + 10;
         Y := @ - 1;
      else
         M := @ - 2;
      end if;
      return ((((Y / 4 - Y / 100 + Y / 400 + 367 * M / 12 + Day) + Y * 365 - 719_499) * 24 + Hour) * 60 + Minute) * 60 + Second;
   end Make_Time;

   ----------------------------------------------------------------------------
   -- Make_Time
   ----------------------------------------------------------------------------
   -- Converts number of seconds since 1970-01-01 00:00:00 to date.
   ----------------------------------------------------------------------------
   procedure Make_Time (
                        T  : in  Unsigned_32;
                        SS : out Natural;
                        MM : out Natural;
                        HH : out Natural;
                        D  : out Natural;
                        M  : out Natural;
                        Y  : out Natural
                       ) is
      TT       : Unsigned_32 := T;
      Y_Offset : Natural;
      Y_Leap   : Boolean;
      DPM      : Natural;
   begin
      TT := @ - NSECONDS_1970_2000;
      SS := Natural (TT mod 60);
      TT := @ / 60;
      MM := Natural (TT mod 60);
      TT := @ / 60;
      HH := Natural (TT mod 24);
      D  := Natural (TT / 24);
      Y_Offset := 0;
      while True loop
         Y_Leap := (Y_Offset mod 4) = 0;
         if D < (365 + 1) then
            exit;
         end if;
         D := @ - 365;
         if Y_Leap then
            D := @ - 1;
         end if;
         Y_Offset := @ + 1;
      end loop;
      M := 0;
      for M_Idx in 1 .. 12 loop
         DPM := Days_Per_Month (M_Idx);
         if Y_Leap and then M_Idx = 2 then
            DPM := @ + 1;
         end if;
         if D < DPM then
            M := M_Idx;
            exit;
         end if;
         D := @ - DPM;
      end loop;
      D := @ + 1;
      Y := 2_000 + Y_Offset;
   end Make_Time;

   ----------------------------------------------------------------------------
   -- Date2Days
   ----------------------------------------------------------------------------
   -- Computes the number of days since 2000-01-01.
   ----------------------------------------------------------------------------
   function Date2Days (
                       D : Natural;
                       M : Natural;
                       Y : Natural
                      ) return Natural is
      DD : Natural := D;
      YY : Natural := Y;
   begin
      if YY >= 2000 then
         YY := @ - 2000;
      end if;
      for M_Idx in 1 .. M - 1 loop
         DD := @ + Days_Per_Month (M_Idx);
      end loop;
      if M > 2 and then YY mod 4 = 0 then
         DD := @ + 1;
      end if;
      DD := @ + 365 * YY + (YY + 3) / 4 - 1;
      return DD;
   end Date2Days;

   ----------------------------------------------------------------------------
   -- NDay_Of_Week
   ----------------------------------------------------------------------------
   -- Given a date, outputs the day of the week as and index to be used with
   -- Day_Of_Week array. Exploits 2000-01-01 = Saturday.
   ----------------------------------------------------------------------------
   function NDay_Of_Week (
                          D : Natural;
                          M : Natural;
                          Y : Natural
                         ) return Natural is
      NDay : Natural;
   begin
      NDay := Date2Days (D, M, Y);
      return (NDay + 6) mod 7;
   end NDay_Of_Week;

end Time;
