-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ goldfish.ads                                                                                              --
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

with System.Storage_Elements;
with Interfaces;
with Definitions;

package Goldfish is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   ----------------------------------------------------------------------------
   -- RTC
   ----------------------------------------------------------------------------

   type RTC_Type is
   record
      TIME_LOW        : Unsigned_32 with Volatile_Full_Access => True;
      TIME_HIGH       : Unsigned_32 with Volatile_Full_Access => True;
      ALARM_LOW       : Unsigned_32 with Volatile_Full_Access => True;
      ALARM_HIGH      : Unsigned_32 with Volatile_Full_Access => True;
      IRQ_ENABLED     : Unsigned_32 with Volatile_Full_Access => True;
      CLEAR_ALARM     : Unsigned_32 with Volatile_Full_Access => True;
      ALARM_STATUS    : Unsigned_32 with Volatile_Full_Access => True;
      CLEAR_INTERRUPT : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Size => 8 * 32;
   for RTC_Type use
   record
      TIME_LOW        at 16#00# range 0 .. 31;
      TIME_HIGH       at 16#04# range 0 .. 31;
      ALARM_LOW       at 16#08# range 0 .. 31;
      ALARM_HIGH      at 16#0C# range 0 .. 31;
      IRQ_ENABLED     at 16#10# range 0 .. 31;
      CLEAR_ALARM     at 16#14# range 0 .. 31;
      ALARM_STATUS    at 16#18# range 0 .. 31;
      CLEAR_INTERRUPT at 16#1C# range 0 .. 31;
   end record;

end Goldfish;
