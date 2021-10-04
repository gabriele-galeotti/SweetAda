-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ virt.ads                                                                                                  --
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

with System.Storage_Elements;
with Interfaces;

package Virt is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   mtimecmp : Unsigned_64 with
      Address    => To_Address (16#0200_4000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   mtime    : Unsigned_64 with
      Address    => To_Address (16#0200_BFF8#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART0_BASEADDRESS : constant := 16#1000_0000#;

   ----------------------------------------------------------------------------
   -- Goldfish RTC
   ----------------------------------------------------------------------------

   type Goldfish_Type is
   record
      RTC_TIME_LOW        : Unsigned_32 with Volatile_Full_Access => True;
      RTC_TIME_HIGH       : Unsigned_32 with Volatile_Full_Access => True;
      RTC_ALARM_LOW       : Unsigned_32 with Volatile_Full_Access => True;
      RTC_ALARM_HIGH      : Unsigned_32 with Volatile_Full_Access => True;
      RTC_IRQ_ENABLED     : Unsigned_32 with Volatile_Full_Access => True;
      RTC_CLEAR_ALARM     : Unsigned_32 with Volatile_Full_Access => True;
      RTC_ALARM_STATUS    : Unsigned_32 with Volatile_Full_Access => True;
      RTC_CLEAR_INTERRUPT : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Size => 8 * 32;
   for Goldfish_Type use
   record
      RTC_TIME_LOW        at 16#00# range 0 .. 31;
      RTC_TIME_HIGH       at 16#04# range 0 .. 31;
      RTC_ALARM_LOW       at 16#08# range 0 .. 31;
      RTC_ALARM_HIGH      at 16#0C# range 0 .. 31;
      RTC_IRQ_ENABLED     at 16#10# range 0 .. 31;
      RTC_CLEAR_ALARM     at 16#14# range 0 .. 31;
      RTC_ALARM_STATUS    at 16#18# range 0 .. 31;
      RTC_CLEAR_INTERRUPT at 16#1C# range 0 .. 31;
   end record;

   GOLDFISH_ADDRESS : constant := 16#0010_1000#;

   GOLDFISH : aliased Goldfish_Type with
      Address    => To_Address (GOLDFISH_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end Virt;
