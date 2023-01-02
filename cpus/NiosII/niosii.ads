-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ niosii.ads                                                                                                --
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
with Interfaces;
with Bits;

package NiosII is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- Processor core
   ----------------------------------------------------------------------------

   -- status/estatus/bstatus

   type status_Type is
   record
      PIE      : Boolean;     -- PIE is the processor interrupt-enable bit.
      U        : Boolean;     -- U is the user mode bit.
      EH       : Boolean;     -- EH is the exception handler mode bit.
      IH       : Boolean;     -- IH is the interrupt handler mode bit.
      IL       : Bits_6;      -- IL is the interrupt level field.
      CRS      : Bits_6;      -- CRS is the current register set field.
      PRS      : Bits_6;      -- PRS is the previous register set field.
      NMI      : Boolean;     -- NMI is the nonmaskable interrupt mode bit.
      RSIE     : Boolean;     -- RSIE is the register set interrupt-enable bit.
      Reserved : Bits_8 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for status_Type use
   record
      PIE      at 0 range 0 .. 0;
      U        at 0 range 1 .. 1;
      EH       at 0 range 2 .. 2;
      IH       at 0 range 3 .. 3;
      IL       at 0 range 4 .. 9;
      CRS      at 0 range 10 .. 15;
      PRS      at 0 range 16 .. 21;
      NMI      at 0 range 22 .. 22;
      RSIE     at 0 range 23 .. 23;
      Reserved at 0 range 24 .. 31;
   end record;

   function status_Read return status_Type with
      Inline => True;
   procedure status_Write (Value : in status_Type) with
      Inline => True;

   function estatus_Read return status_Type with
      Inline => True;
   procedure estatus_Write (Value : in status_Type) with
      Inline => True;

   function bstatus_Read return status_Type with
      Inline => True;
   procedure bstatus_Write (Value : in status_Type) with
      Inline => True;

   -- IRQ constants for ienable and ipending

   IRQ0  : constant := 0;
   IRQ1  : constant := 1;
   IRQ2  : constant := 2;
   IRQ3  : constant := 3;
   IRQ4  : constant := 4;
   IRQ5  : constant := 5;
   IRQ6  : constant := 6;
   IRQ7  : constant := 7;
   IRQ8  : constant := 8;
   IRQ9  : constant := 9;
   IRQ10 : constant := 10;
   IRQ11 : constant := 11;
   IRQ12 : constant := 12;
   IRQ13 : constant := 13;
   IRQ14 : constant := 14;
   IRQ15 : constant := 15;
   IRQ16 : constant := 16;
   IRQ17 : constant := 17;
   IRQ18 : constant := 18;
   IRQ19 : constant := 19;
   IRQ20 : constant := 20;
   IRQ21 : constant := 21;
   IRQ22 : constant := 22;
   IRQ23 : constant := 23;
   IRQ24 : constant := 24;
   IRQ25 : constant := 25;
   IRQ26 : constant := 26;
   IRQ27 : constant := 27;
   IRQ28 : constant := 28;
   IRQ29 : constant := 29;
   IRQ30 : constant := 30;
   IRQ31 : constant := 31;

   -- ienable

   function ienable_Read return Bitmap_32 with
      Inline => True;
   procedure ienable_Write (Value : in Bitmap_32) with
      Inline => True;

   -- ipending

   function ipending_Read return Bitmap_32 with
      Inline => True;

   -- cpuid

   function cpuid_Read return Unsigned_32 with
      Inline => True;

   -- exception control

   type exception_control_Type is
   record
      Reserved1 : Bits_2 := 0;
      Cause     : Bits_5;       -- CAUSE is written by the Nios II processor when certain exceptions occur.
      Reserved2 : Bits_25 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for exception_control_Type use
   record
      Reserved1 at 0 range 0 .. 1;
      Cause     at 0 range 2 .. 6;
      Reserved2 at 0 range 7 .. 31;
   end record;

   function exception_control_Read return exception_control_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Irq handling
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Boolean;

   procedure PIE_Set (PIE : in Boolean) with
      Inline => True;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;

   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

end NiosII;
