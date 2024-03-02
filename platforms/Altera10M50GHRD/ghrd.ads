-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ghrd.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Configure;
with Bits;

package GHRD
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- system definitions
   ----------------------------------------------------------------------------

   Timer_Frequency   renames Configure.TIMER_SYSCLK;
   Timer_1_Frequency renames Configure.TIMER_1_SYSCLK;

   UART_BASEADDRESS : constant := 16#F800_1600#;

   ----------------------------------------------------------------------------
   -- Timer
   ----------------------------------------------------------------------------

   type Timer_Status_Type is record
      TO       : Boolean := False;
      RUN      : Boolean := False;
      Reserved : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Timer_Status_Type use record
      TO       at 0 range 0 ..  0;
      RUN      at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   type Timer_Control_Type is record
      ITO      : Boolean := False;
      CONT     : Boolean := False;
      START    : Boolean := False;
      STOP     : Boolean := False;
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Timer_Control_Type use record
      ITO      at 0 range 0 ..  0;
      CONT     at 0 range 1 ..  1;
      START    at 0 range 2 ..  2;
      STOP     at 0 range 3 ..  3;
      Reserved at 0 range 4 .. 31;
   end record;

   type Timer_Type is record
      Status  : Timer_Status_Type  with Volatile_Full_Access => True;
      Control : Timer_Control_Type with Volatile_Full_Access => True;
      PeriodL : Unsigned_32        with Volatile_Full_Access => True; -- 16-bit
      PeriodH : Unsigned_32        with Volatile_Full_Access => True; -- 16-bit
      SnapL   : Unsigned_32        with Volatile_Full_Access => True; -- 16-bit
      SnapH   : Unsigned_32        with Volatile_Full_Access => True; -- 16-bit
   end record
      with Size => 6 * 32;
   for Timer_Type use record
      Status  at 16#00# range 0 .. 31;
      Control at 16#04# range 0 .. 31;
      PeriodL at 16#08# range 0 .. 31;
      PeriodH at 16#0C# range 0 .. 31;
      SnapL   at 16#10# range 0 .. 31;
      SnapH   at 16#14# range 0 .. 31;
   end record;

   TIMER_ADDRESS : constant := 16#F800_1440#;

   Timer : aliased Timer_Type
      with Address    => To_Address (TIMER_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   TIMER_1_ADDRESS : constant := 16#E000_0880#;

   Timer_1 : aliased Timer_Type
      with Address    => To_Address (TIMER_1_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- subprograms
   ----------------------------------------------------------------------------

   procedure Tclk_Init;

end GHRD;
