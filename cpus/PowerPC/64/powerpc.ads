-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc.ads                                                                                               --
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
with Interfaces;
with Bits;

package PowerPC
   with Preelaborate => True
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
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#7D82_1008#; -- twge r2,r2
   Opcode_BREAKPOINT_Size : constant := 4;

   BREAKPOINT_Asm_String : constant String := ".long   0x7D821008";

   ----------------------------------------------------------------------------
   -- PowerPC registers
   ----------------------------------------------------------------------------

   R0    : constant := 0;
   R1    : constant := 1;
   R2    : constant := 2;
   R3    : constant := 3;
   R4    : constant := 4;
   R5    : constant := 5;
   R6    : constant := 6;
   R7    : constant := 7;
   R8    : constant := 8;
   R9    : constant := 9;
   R10   : constant := 10;
   R11   : constant := 11;
   R12   : constant := 12;
   R13   : constant := 13;
   R14   : constant := 14;
   R15   : constant := 15;
   R16   : constant := 16;
   R17   : constant := 17;
   R18   : constant := 18;
   R19   : constant := 19;
   R20   : constant := 20;
   R21   : constant := 21;
   R22   : constant := 22;
   R23   : constant := 23;
   R24   : constant := 24;
   R25   : constant := 25;
   R26   : constant := 26;
   R27   : constant := 27;
   R28   : constant := 28;
   R29   : constant := 29;
   R30   : constant := 30;
   R31   : constant := 31;
   FP0   : constant := 32;
   FP1   : constant := 33;
   FP2   : constant := 34;
   FP3   : constant := 35;
   FP4   : constant := 36;
   FP5   : constant := 37;
   FP6   : constant := 38;
   FP7   : constant := 39;
   FP8   : constant := 40;
   FP9   : constant := 41;
   FP10  : constant := 42;
   FP11  : constant := 43;
   FP12  : constant := 44;
   FP13  : constant := 45;
   FP14  : constant := 46;
   FP15  : constant := 47;
   FP16  : constant := 48;
   FP17  : constant := 49;
   FP18  : constant := 50;
   FP19  : constant := 51;
   FP20  : constant := 52;
   FP21  : constant := 53;
   FP22  : constant := 54;
   FP23  : constant := 55;
   FP24  : constant := 56;
   FP25  : constant := 57;
   FP26  : constant := 58;
   FP27  : constant := 59;
   FP28  : constant := 60;
   FP29  : constant := 61;
   FP30  : constant := 62;
   FP31  : constant := 63;

   subtype Register_Number_Type is Natural range R0 .. FP31;

   ----------------------------------------------------------------------------
   -- MSR
   ----------------------------------------------------------------------------

   -- __TBD__

   type MSR_Type is record
      Reserved : Bits_64 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for MSR_Type use record
      Reserved at 0 range 0 .. 63;
   end record;

   function MSR_Read
      return MSR_Type
      with Inline => True;
   procedure MSR_Write
      (Value : in MSR_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;
   procedure SYNC
      with Inline => True;
   procedure ISYNC
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Integer;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline_Always => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline_Always => True;

   procedure Irq_Enable
      with Inline_Always => True;
   procedure Irq_Disable
      with Inline_Always => True;

end PowerPC;
