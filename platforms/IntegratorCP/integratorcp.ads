-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ integratorcp.ads                                                                                          --
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
   PIC_PRIMARY_BASEADDRESS  : constant := 16#1400_0000#;
   PL011_UART0_BASEADDRESS  : constant := 16#1600_0000#;
   PL011_UART1_BASEADDRESS  : constant := 16#1700_0000#;
   PL110_BASEADDRESS        : constant := 16#C000_0000#;
   LAN91C111_BASEADDRESS    : constant := 16#C800_0000#;

   -- 3.6.1 Primary interrupt controller

   type PIC_IRQ_ITEMS_Type is
   record
      SOFTINT   : Boolean;
      UARTINT0  : Boolean;
      UARTINT1  : Boolean;
      KBDINT    : Boolean;
      MOUSEINT  : Boolean;
      TIMERINT0 : Boolean;
      TIMERINT1 : Boolean;
      TIMERINT2 : Boolean;
      RTCINT    : Boolean;
      LM_LLINT0 : Boolean; -- IRQ0
      LM_LLINT1 : Boolean; -- FIQ0
      Reserved1 : Bits_11;
      CLCDCINT  : Boolean;
      MMCIINT0  : Boolean;
      MMCIINT1  : Boolean;
      AACINT    : Boolean;
      CPPLDINT  : Boolean;
      ETHINT    : Boolean;
      TSPENINT  : Boolean;
      Reserved2 : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PIC_IRQ_ITEMS_Type use
   record
      SOFTINT   at 0 range 0 .. 0;
      UARTINT0  at 0 range 1 .. 1;
      UARTINT1  at 0 range 2 .. 2;
      KBDINT    at 0 range 3 .. 3;
      MOUSEINT  at 0 range 4 .. 4;
      TIMERINT0 at 0 range 5 .. 5;
      TIMERINT1 at 0 range 6 .. 6;
      TIMERINT2 at 0 range 7 .. 7;
      RTCINT    at 0 range 8 .. 8;
      LM_LLINT0 at 0 range 9 .. 9;
      LM_LLINT1 at 0 range 10 .. 10;
      Reserved1 at 0 range 11 .. 21;
      CLCDCINT  at 0 range 22 .. 22;
      MMCIINT0  at 0 range 23 .. 23;
      MMCIINT1  at 0 range 24 .. 24;
      AACINT    at 0 range 25 .. 25;
      CPPLDINT  at 0 range 26 .. 26;
      ETHINT    at 0 range 27 .. 27;
      TSPENINT  at 0 range 28 .. 28;
      Reserved2 at 0 range 29 .. 31;
   end record;

   PIC_IRQ_STATUS    : aliased PIC_IRQ_ITEMS_Type with
      Address              => To_Address (PIC_PRIMARY_BASEADDRESS + 16#00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PIC_IRQ_RAWSTAT   : aliased PIC_IRQ_ITEMS_Type with
      Address              => To_Address (PIC_PRIMARY_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PIC_IRQ_ENABLESET : aliased PIC_IRQ_ITEMS_Type with
      Address              => To_Address (PIC_PRIMARY_BASEADDRESS + 16#08#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PIC_IRQ_ENABLECLR : aliased PIC_IRQ_ITEMS_Type with
      Address              => To_Address (PIC_PRIMARY_BASEADDRESS + 16#0C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PIC_FIQ_ENABLESET : aliased PIC_IRQ_ITEMS_Type with
      Address              => To_Address (PIC_PRIMARY_BASEADDRESS + 16#28#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   PIC_FIQ_ENABLECLR : aliased PIC_IRQ_ITEMS_Type with
      Address              => To_Address (PIC_PRIMARY_BASEADDRESS + 16#2C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

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
      Alignment => 16#100#;
   for Timer_Type use
   record
      Load    at 16#00# range 0 .. 31;
      Value   at 16#04# range 0 .. 31;
      Control at 16#08# range 0 .. 31;
      IntClr  at 16#0C# range 0 .. 31;
      RIS     at 16#10# range 0 .. 31;
      MIS     at 16#14# range 0 .. 31;
      BGLoad  at 16#18# range 0 .. 31;
   end record;

   Timer : aliased array (0 .. 2) of Timer_Type with
      Address    => To_Address (COUNTERTIMER_BASEADDRESS),
      Import     => True,
      Convention => Ada;

end IntegratorCP;
