-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ xps.ads                                                                                                   --
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

with System;
with Interfaces;
with Bits;

package XPS
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- LogiCORE IP XPS Timer/Counter (v1.02a)
   -- DS573 April 19, 2010
   ----------------------------------------------------------------------------

   -- Load Register (TLR0 and TLR1)

   type TLR_Type is record
      TimerCounter_Load_Register : Unsigned_32; -- Timer/Counter Load register
   end record
      with Bit_Order   => High_Order_First,
           Object_Size => 32;
   for TLR_Type use record
      TimerCounter_Load_Register at 0 range 0 .. 31;
   end record;

   -- Timer/Counter Register (TCR0 and TCR1)

   type TCR_Type is record
      TimerCounter_Register : Unsigned_32; -- Timer/Counter register
   end record
      with Bit_Order   => High_Order_First,
           Object_Size => 32;
   for TCR_Type use record
      TimerCounter_Register at 0 range 0 .. 31;
   end record;

   -- Control/Status Register 0 (TCSR0)

   UDT0_UP   : constant := 0; -- Timer functions as up counter
   UDT0_DOWN : constant := 1; -- Timer functions as down counter

   MDT0_GEN : constant := 0; -- Timer mode is generate
   MDT0_CAP : constant := 1; -- Timer mode is capture

   type TCSR0_Type is record
      Reserved : Bits_21 := 0;
      ENALL    : Boolean := False;    -- Enable All Timers
      PWMA0    : Boolean := False;    -- Enable Pulse Width Modulation for Timer0
      T0INT    : Boolean := False;    -- Timer0 Interrupt
      ENT0     : Boolean := False;    -- Enable Timer0
      ENIT0    : Boolean := False;    -- Enable Interrupt for Timer0
      LOAD0    : Boolean := False;    -- Load Timer0
      ARHT0    : Boolean := False;    -- Auto Reload/Hold Timer0
      CAPT0    : Boolean := False;    -- Enable External Capture Trigger Timer0
      GENT0    : Boolean := False;    -- Enable External Generate Signal Timer0
      UDT0     : Bits_1  := UDT0_UP;  -- Up/Down Count Timer0
      MDT0     : Bits_1  := MDT0_GEN; -- Timer0 Mode
   end record
      with Bit_Order   => High_Order_First,
           Object_Size => 32;
   for TCSR0_Type use record
      Reserved at 0 range  0 .. 20;
      ENALL    at 0 range 21 .. 21;
      PWMA0    at 0 range 22 .. 22;
      T0INT    at 0 range 23 .. 23;
      ENT0     at 0 range 24 .. 24;
      ENIT0    at 0 range 25 .. 25;
      LOAD0    at 0 range 26 .. 26;
      ARHT0    at 0 range 27 .. 27;
      CAPT0    at 0 range 28 .. 28;
      GENT0    at 0 range 29 .. 29;
      UDT0     at 0 range 30 .. 30;
      MDT0     at 0 range 31 .. 31;
   end record;

   -- Control/Status Register 1 (TCSR1)

   UDT1_UP   renames UDT0_UP;
   UDT1_DOWN renames UDT0_DOWN;

   MDT1_GEN renames MDT0_GEN;
   MDT1_CAP renames MDT0_CAP;

   type TCSR1_Type is record
      Reserved : Bits_21 := 0;
      ENALL    : Boolean := False;    -- Enable All Timers
      PWMB0    : Boolean := False;    -- Enable Pulse Width Modulation for Timer1
      T1INT    : Boolean := False;    -- Timer1 Interrupt
      ENT1     : Boolean := False;    -- Enable Timer1
      ENIT1    : Boolean := False;    -- Enable Interrupt for Timer1
      LOAD1    : Boolean := False;    -- Load Timer1
      ARHT1    : Boolean := False;    -- Auto Reload/Hold Timer1
      CAPT1    : Boolean := False;    -- Enable External Capture Trigger Timer1
      GENT1    : Boolean := False;    -- Enable External Generate Signal Timer1
      UDT1     : Bits_1  := UDT1_UP;  -- Up/Down Count Timer1
      MDT1     : Bits_1  := MDT1_GEN; -- Timer1 Mode
   end record
   with Bit_Order   => High_Order_First,
        Object_Size => 32;
   for TCSR1_Type use record
      Reserved at 0 range  0 .. 20;
      ENALL    at 0 range 21 .. 21;
      PWMB0    at 0 range 22 .. 22;
      T1INT    at 0 range 23 .. 23;
      ENT1     at 0 range 24 .. 24;
      ENIT1    at 0 range 25 .. 25;
      LOAD1    at 0 range 26 .. 26;
      ARHT1    at 0 range 27 .. 27;
      CAPT1    at 0 range 28 .. 28;
      GENT1    at 0 range 29 .. 29;
      UDT1     at 0 range 30 .. 30;
      MDT1     at 0 range 31 .. 31;
   end record;

   type TimerCounter_Type is record
      TCSR0 : TCSR0_Type  with Volatile_Full_Access => True;
      TLR0  : TLR_Type    with Volatile_Full_Access => True;
      TCR0  : TCR_Type    with Volatile_Full_Access => True;
      PAD   : Pad_Bytes_4;
      TCSR1 : TCSR1_Type  with Volatile_Full_Access => True;
      TLR1  : TLR_Type    with Volatile_Full_Access => True;
      TCR1  : TCR_Type    with Volatile_Full_Access => True;
   end record
      with Object_Size => 7 * 32;
   for TimerCounter_Type use record
      TCSR0 at 16#00# range 0 .. 31;
      TLR0  at 16#04# range 0 .. 31;
      TCR0  at 16#08# range 0 .. 31;
      PAD   at 16#0C# range 0 .. 31;
      TCSR1 at 16#10# range 0 .. 31;
      TLR1  at 16#14# range 0 .. 31;
      TCR1  at 16#18# range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- LogiCORE IP XPS Interrupt Controller (v2.01a)
   -- DS572 April 19, 2010
   ----------------------------------------------------------------------------

   -- Interrupt Status Register (ISR)
   -- Interrupt Pending Register (IPR)
   -- Interrupt Enable Register (IER)
   -- Interrupt Acknowledge Register (IAR)
   -- Set Interrupt Enables (SIE)

   type ISRIPRIERIARSIE_Type is record
      INT : Bitmap_32 := [others => False]; -- Interrupt Input (n) – Interrupt Input (0)
   end record
      with Bit_Order   => High_Order_First,
           Object_Size => 32;
   for ISRIPRIERIARSIE_Type use record
      INT at 0 range 0 .. 31;
   end record;

   type ISR_Type is new ISRIPRIERIARSIE_Type;
   type IPR_Type is new ISRIPRIERIARSIE_Type;
   type IER_Type is new ISRIPRIERIARSIE_Type;
   type IAR_Type is new ISRIPRIERIARSIE_Type;
   type SIE_Type is new ISRIPRIERIARSIE_Type;
   type CIE_Type is new ISRIPRIERIARSIE_Type;

   -- Interrupt Vector Register (IVR)

   type IVR_Type is record
      Interrupt_Vector_Number : Unsigned_32 := 16#FFFF_FFFF#; -- Ordinal of highest priority, enabled, active interrupt input
   end record
      with Bit_Order   => High_Order_First,
           Object_Size => 32;
   for IVR_Type use record
      Interrupt_Vector_Number at 0 range 0 .. 31;
   end record;

   -- Master Enable Register (MER)

   type MER_Type is record
      Reserved : Bits_30 := 0;
      HIE      : Boolean;      -- Hardware Interrupt Enable
      ME       : Boolean;      -- Master IRQ Enable
   end record
      with Bit_Order   => High_Order_First,
           Object_Size => 32;
   for MER_Type use record
      Reserved at 0 range  0 .. 29;
      HIE      at 0 range 30 .. 30;
      ME       at 0 range 31 .. 31;
   end record;

   type InterruptController_Type is record
      ISR : ISR_Type with Volatile_Full_Access => True;
      IPR : IPR_Type with Volatile_Full_Access => True;
      IER : IER_Type with Volatile_Full_Access => True;
      IAR : IAR_Type with Volatile_Full_Access => True;
      SIE : SIE_Type with Volatile_Full_Access => True;
      CIE : CIE_Type with Volatile_Full_Access => True;
      IVR : IVR_Type with Volatile_Full_Access => True;
      MER : MER_Type with Volatile_Full_Access => True;
   end record
      with Object_Size => 8 * 32;
   for InterruptController_Type use record
      ISR at 16#00# range 0 .. 31;
      IPR at 16#04# range 0 .. 31;
      IER at 16#08# range 0 .. 31;
      IAR at 16#0C# range 0 .. 31;
      SIE at 16#10# range 0 .. 31;
      CIE at 16#14# range 0 .. 31;
      IVR at 16#18# range 0 .. 31;
      MER at 16#1C# range 0 .. 31;
   end record;

end XPS;
