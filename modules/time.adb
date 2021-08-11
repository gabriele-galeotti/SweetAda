-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.adb                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
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
         M := M + 10;
         Y := Y - 1;
      else
         M := M - 2;
      end if;
      return ((((Y / 4 - Y / 100 + Y / 400 + 367 * M / 12 + Day) + Y * 365 - 719499) * 24 + Hour) * 60 + Minute) * 60 + Second;
   end Make_Time;

end Time;
