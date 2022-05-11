-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ time.ads                                                                                                  --
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

   Days_Per_Month : constant array (Natural range 1 .. 12) of Natural :=
      (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
   Month_Name     : constant array (Natural range 1 .. 12) of String (1 .. 3) :=
      ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
   Day_Of_Week    : constant array (Natural range 1 .. 7) of String (1 .. 3) :=
      ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun");

   type TM_Time is
   record
      Second : Natural;
      Minute : Natural;
      Hour   : Natural;
      Mday   : Natural;
      Month  : Natural;
      Year   : Natural;
   end record;

   function Make_Time (
                       Year   : Positive;
                       Month  : Positive;
                       Day    : Positive;
                       Hour   : Natural;
                       Minute : Natural;
                       Second : Natural
                      ) return Natural;

   procedure Make_Time (
                        T  : in  Unsigned_32;
                        SS : out Natural;
                        MM : out Natural;
                        HH : out Natural;
                        D  : out Natural;
                        M  : out Natural;
                        Y  : out Natural
                       );

   function NDay_Of_Week (
                          D : Natural;
                          M : Natural;
                          Y : Natural
                         ) return Natural;

end Time;
