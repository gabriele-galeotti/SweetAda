-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ microblaze.ads                                                                                            --
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
with Interfaces;
with Bits;

package MicroBlaze is

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
   -- Generic definitions
   ----------------------------------------------------------------------------

   -- __REF__ https://www.xilinx.com/support/answers/53823.html
   -- BRKI R14,0x60
   BREAKPOINT_Instruction      : constant Unsigned_32 := 16#B9CC_0060#;
   BREAKPOINT_Instruction_Size : constant             := 4;
   BREAKPOINT_Asm_String       : constant String      := ".word 0xB9CC0060";

   procedure NOP with
      Inline => True;
   procedure BREAKPOINT with
      Inline => True;

   ----------------------------------------------------------------------------
   -- MicroBlaze registers
   ----------------------------------------------------------------------------

   R0  : constant := 0;
   R1  : constant := 1;
   R2  : constant := 2;
   R3  : constant := 3;
   R4  : constant := 4;
   R5  : constant := 5;
   R6  : constant := 6;
   R7  : constant := 7;
   R8  : constant := 8;
   R9  : constant := 9;
   R10 : constant := 10;
   R11 : constant := 11;
   R12 : constant := 12;
   R13 : constant := 13;
   R14 : constant := 14;
   R15 : constant := 15;
   R16 : constant := 16;
   R17 : constant := 17;
   R18 : constant := 18;
   R19 : constant := 19;
   R20 : constant := 20;
   R21 : constant := 21;
   R22 : constant := 22;
   R23 : constant := 23;
   R24 : constant := 24;
   R25 : constant := 25;
   R26 : constant := 26;
   R27 : constant := 27;
   R28 : constant := 28;
   R29 : constant := 29;
   R30 : constant := 30;
   R31 : constant := 31;
   PC  : constant := 32;
   MSR : constant := 33;
   EAR : constant := 34;

   subtype Register_Number_Type is Natural range R0 .. PC;

   Register_Size : constant array (R0 .. PC) of Positive :=
      (
       R0  => 4,
       R1  => 4,
       R2  => 4,
       R3  => 4,
       R4  => 4,
       R5  => 4,
       R6  => 4,
       R7  => 4,
       R8  => 4,
       R9  => 4,
       R10 => 4,
       R11 => 4,
       R12 => 4,
       R13 => 4,
       R14 => 4,
       R15 => 4,
       R16 => 4,
       R17 => 4,
       R18 => 4,
       R19 => 4,
       R20 => 4,
       R21 => 4,
       R22 => 4,
       R23 => 4,
       R24 => 4,
       R25 => 4,
       R26 => 4,
       R27 => 4,
       R28 => 4,
       R29 => 4,
       R30 => 4,
       R31 => 4,
       PC  => 4
      );

   Maximum_Register_Size : constant := 4;

   ----------------------------------------------------------------------------
   -- XPS Timer
   ----------------------------------------------------------------------------

   type XPS_Timer_CSR_Type is
   record
      Reserved : Bits_21;
      ENALL    : Bits_1;
      PWMA0    : Bits_1;
      T0INT    : Bits_1;
      ENT0     : Bits_1;
      ENIT0    : Bits_1;
      LOAD0    : Bits_1;
      ARHT0    : Bits_1;
      CAPT0    : Bits_1;
      GENT0    : Bits_1;
      UDT0     : Bits_1;
      MDT0     : Bits_1;
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for XPS_Timer_CSR_Type use
   record
      Reserved at 0 range 0 .. 20;
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

   type XPS_Timer_Type is
   record
      TCSR0 : XPS_Timer_CSR_Type;
      TLR0  : Unsigned_32;
      TCR0  : Unsigned_32;
   end record with
      Size => 3 * 32;
   for XPS_Timer_Type use
   record
      TCSR0 at 0 range 0 .. 31;
      TLR0  at 4 range 0 .. 31;
      TCR0  at 8 range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- XPS Interrupt Controller
   ----------------------------------------------------------------------------

   type XPS_INTC_MER_Type is
   record
      Reserved : Bits_30;
      HIE      : Bits_1;
      ME       : Bits_1;
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for XPS_INTC_MER_Type use
   record
      Reserved at 0 range 0 .. 29;
      HIE      at 0 range 30 .. 30;
      ME       at 0 range 31 .. 31;
   end record;

   type XPS_INTC_Type is
   record
      ISR : Unsigned_32;
      IPR : Unsigned_32;
      IER : Unsigned_32;
      IAR : Unsigned_32;
      SIE : Unsigned_32;
      CIE : Unsigned_32;
      IVR : Unsigned_32;
      MER : XPS_INTC_MER_Type;
   end record with
      Size => 8 * 32;
   for XPS_INTC_Type use
   record
      ISR at 16#00# range 0 .. 31;
      IPR at 16#04# range 0 .. 31;
      IER at 16#08# range 0 .. 31;
      IAR at 16#0C# range 0 .. 31;
      SIE at 16#10# range 0 .. 31;
      CIE at 16#14# range 0 .. 31;
      IVR at 16#18# range 0 .. 31;
      MER at 16#1C# range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer; -- __FIX__

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

end MicroBlaze;
