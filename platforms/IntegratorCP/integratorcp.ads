-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ integratorcp.ads                                                                                          --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package IntegratorCP is

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

   COUNTERTIMER_BASEADDRESS : constant := 16#1300_0000#;
   PL011_UART0_BASEADDRESS  : constant := 16#1600_0000#;
   PL011_UART1_BASEADDRESS  : constant := 16#1700_0000#;
   PL110_BASEADDRESS        : constant := 16#C000_0000#;
   LAN91C111_BASEADDRESS    : constant := 16#C800_0000#;

   -- 4.9.2 Counter/timer registers

   TIMER_SIZE_16 : constant := 0; -- 16-bit counter (default)
   TIMER_SIZE_32 : constant := 1; -- 32-bit counter

   PRESCALE_NONE : constant := 2#00#; -- none
   PRESCALE_16   : constant := 2#01#; -- divide by 16
   PRESCALE_256  : constant := 2#10#; -- divide by 256

   MODE_FREERUNNING : constant := 0; -- free running, counts once and then wraps to 0xFFFF
   MODE_PERIODIC    : constant := 1; -- periodic, reloads from load register at the end of each count.

   type TimerXControl_Type is
   record
      ONESHOT    : Boolean;      -- Selects one-shot or wrapping counter mode
      TIMER_SIZE : Bits_1;       -- Selects 16/32 bit counter operation
      PRESCALE   : Bits_2;       -- Prescale divisor
      Reserved1  : Bits_1 := 0;
      IE         : Boolean;      -- Interrupt enable
      MODE       : Bits_1;       -- Timer mode
      ENABLE     : Boolean;      -- Timer enable
      Reserved2  : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for TimerXControl_Type use
   record
      ONESHOT    at 0 range 0 .. 0;
      TIMER_SIZE at 0 range 1 .. 1;
      PRESCALE   at 0 range 2 .. 3;
      Reserved1  at 0 range 4 .. 4;
      IE         at 0 range 5 .. 5;
      MODE       at 0 range 6 .. 6;
      ENABLE     at 0 range 7 .. 7;
      Reserved2  at 0 range 8 .. 31;
   end record;

   type TimerXRIS_Type is
   record
      RTI      : Boolean; -- Raw interrupt status from the counter
      Reserved : Bits_31;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for TimerXRIS_Type use
   record
      RTI      at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 31;
   end record;

   type TimerXMIS_Type is
   record
      TI       : Boolean; -- Enabled interrupt status from the counter
      Reserved : Bits_31;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for TimerXMIS_Type use
   record
      TI       at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 31;
   end record;

pragma Warnings (Off, "bits of * unused");
   type Timer_Type is
   record
      Load    : Unsigned_32        with Volatile_Full_Access => True;
      Value   : Unsigned_32        with Volatile_Full_Access => True;
      Control : TimerXControl_Type with Volatile_Full_Access => True;
      IntClr  : Unsigned_32        with Volatile_Full_Access => True;
      RIS     : TimerXRIS_Type     with Volatile_Full_Access => True;
      MIS     : TimerXMIS_Type     with Volatile_Full_Access => True;
      BGLoad  : Unsigned_32        with Volatile_Full_Access => True;
   end record with
      Size        => 8 * 32,
      Object_Size => 16#100#;
pragma Warnings (On, "bits of * unused");

   Timer : aliased array (0 .. 2) of Timer_Type with
      Address    => To_Address (COUNTERTIMER_BASEADDRESS),
      Import     => True,
      Convention => Ada;

end IntegratorCP;
