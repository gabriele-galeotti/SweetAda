-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl031.adb                                                                                                 --
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

with Interfaces;
with Bits;

package body PL031
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type RTCCR_Type is record
      RTC_start : Boolean := False; -- If set to 1, the RTC is enabled.
      Reserved  : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTCCR_Type use record
      RTC_start at 0 range 0 ..  0;
      Reserved  at 0 range 1 .. 31;
   end record;

   type RTC_Type is record
      RTCDR : Unsigned_32 with Volatile_Full_Access => True;
      RTCMR : Unsigned_32 with Volatile_Full_Access => True;
      RTCLR : Unsigned_32 with Volatile_Full_Access => True;
      RTCCR : RTCCR_Type  with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for RTC_Type use record
      RTCDR at 16#0# range 0 .. 31;
      RTCMR at 16#4# range 0 .. 31;
      RTCLR at 16#8# range 0 .. 31;
      RTCCR at 16#C# range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Read_Clock
   ----------------------------------------------------------------------------
   procedure Read_Clock
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time)
      is
      RTC : RTC_Type
         with Address    => D.Base_Address,
              Volatile   => True,
              Import     => True,
              Convention => Ada;
   begin
      Time.Make_Time (RTC.RTCDR, T);
   end Read_Clock;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (D : in Descriptor_Type)
      is
      RTC : RTC_Type
         with Address    => D.Base_Address,
              Volatile   => True,
              Import     => True,
              Convention => Ada;
   begin
      RTC.RTCCR.RTC_start := True;
   end Init;

end PL031;
