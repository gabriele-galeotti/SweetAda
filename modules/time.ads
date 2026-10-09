-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.ads                                                                                                  --
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

pragma Restrictions (No_Elaboration_Code);

with Interfaces;

package Time
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   DAYS_PER_WEEK   : constant := 7;
   DAYS_PER_MONTH  : constant := 31;
   DAYS_PER_YEAR   : constant := 365;
   MONTHS_PER_YEAR : constant := 12;

   type Sec_Type  is range 0 .. 60;              -- Seconds (0-60)
   type Min_Type  is range 0 .. 59;              -- Minutes (0-59)
   type Hour_Type is range 0 .. 23;              -- Hours (0-23)
   type MDay_Type is range 1 .. DAYS_PER_MONTH;  -- Day of the month (1-31)
   type Mon_Type  is range 1 .. MONTHS_PER_YEAR; -- Month (1-12)
   type Year_Type is new Natural;

   type TM_Sec_Type   is new Sec_Type;                   -- Seconds (0-60)
   type TM_Min_Type   is new Min_Type;                   -- Minutes (0-59)
   type TM_Hour_Type  is new Hour_Type;                  -- Hours (0-23)
   type TM_MDay_Type  is new MDay_Type;                  -- Day of the month (1-31)
   type TM_Mon_Type   is range 0 .. MONTHS_PER_YEAR - 1; -- Month (0-11)
   type TM_Year_Type  is new Year_Type;                  -- Year - 1900
   type TM_WDay_Type  is range 0 .. DAYS_PER_WEEK - 1;   -- Day of the week (0-6, Sunday = 0)
   type TM_YDay_Type  is range 0 .. DAYS_PER_YEAR;       -- Day in the year (0-365, 1 Jan = 0)
   type TM_IsDST_Type is new Integer;                    -- Daylight saving time

   type TM_Time is record
      Sec   : TM_Sec_Type;
      Min   : TM_Min_Type;
      Hour  : TM_Hour_Type;
      MDay  : TM_MDay_Type;
      Mon   : TM_Mon_Type;
      Year  : TM_Year_Type;
      WDay  : TM_WDay_Type;
      YDay  : TM_YDay_Type;
      IsDST : TM_IsDST_Type;
   end record;

   -- ISO 8601 layout
   Day_Of_Week : constant array (Natural range 1 .. DAYS_PER_WEEK) of String (1 .. 3) :=
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
   Month_Name  : constant array (Mon_Type) of String (1 .. 3) :=
      ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

   ----------------------------------------------------------------------------
   -- Compute the number of days since 1970-01-01.
   -- D, M, Y in standard format.
   ----------------------------------------------------------------------------
   function Date2Days
      (D : MDay_Type;
       M : Mon_Type;
       Y : Year_Type)
      return Natural;

   ----------------------------------------------------------------------------
   -- Given a date, output the day of the week as an index to be used with
   -- Day_Of_Week array. Exploit 1970-01-01 = Thursday.
   -- D, M, Y in standard format.
   ----------------------------------------------------------------------------
   function NDay_Of_Week
      (D : MDay_Type;
       M : Mon_Type;
       Y : Year_Type)
      return Natural;

   ----------------------------------------------------------------------------
   -- Convert Gregorian date since 1970-01-01 00:00:00 to seconds.
   -- Assume input in normal date format, i.e. 1980-12-31 23:59:59.
   ----------------------------------------------------------------------------
   function Make_Time
      (Year : Year_Type;
       Mon  : Mon_Type;
       Day  : MDay_Type;
       Hour : Hour_Type;
       Min  : Min_Type;
       Sec  : Sec_Type)
      return Natural;

   ----------------------------------------------------------------------------
   -- Convert number of seconds since 1970-01-01 00:00:00 to date.
   ----------------------------------------------------------------------------
   procedure Make_Time
      (T  : in     Unsigned_32;
       TM :    out TM_Time);

end Time;
