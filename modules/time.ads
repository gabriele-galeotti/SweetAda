-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Interfaces;

package Time is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   type TM_Time is
   record
      Sec   : Natural; -- Seconds (0-60)
      Min   : Natural; -- Minutes (0-59)
      Hour  : Natural; -- Hours (0-23)
      MDay  : Natural; -- Day of the month (1-31)
      Mon   : Natural; -- Month (0-11)
      Year  : Natural; -- Year - 1900
      WDay  : Natural; -- Day of the week (0-6, Sunday = 0)
      YDay  : Natural; -- Day in the year (0-365, 1 Jan = 0)
      IsDST : Integer; -- Daylight saving time
   end record;

   Month_Name  : constant array (Natural range 1 .. 12) of String (1 .. 3) :=
      ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
   Day_Of_Week : constant array (Natural range 1 .. 7) of String (1 .. 3) :=
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

   ----------------------------------------------------------------------------
   -- Compute the number of days since 1970-01-01.
   -- D, M, Y in standard format.
   ----------------------------------------------------------------------------
   function Date2Days
      (D : Natural;
       M : Natural;
       Y : Natural)
      return Natural;

   ----------------------------------------------------------------------------
   -- Given a date, output the day of the week as an index to be used with
   -- Day_Of_Week array. Exploit 1970-01-01 = Thursday.
   -- D, M, Y in standard format.
   ----------------------------------------------------------------------------
   function NDay_Of_Week
      (D : Natural;
       M : Natural;
       Y : Natural)
      return Natural;

   ----------------------------------------------------------------------------
   -- Convert Gregorian date since 1970-01-01 00:00:00 to seconds.
   -- Assume input in normal date format, i.e. 1980-12-31 23:59:59.
   ----------------------------------------------------------------------------
   function Make_Time
      (Year : Positive;
       Mon  : Positive;
       Day  : Positive;
       Hour : Natural;
       Min  : Natural;
       Sec  : Natural)
      return Natural;

   ----------------------------------------------------------------------------
   -- Convert number of seconds since 1970-01-01 00:00:00 to date.
   ----------------------------------------------------------------------------
   procedure Make_Time
      (T  : in     Unsigned_32;
       TM :    out TM_Time);

end Time;
