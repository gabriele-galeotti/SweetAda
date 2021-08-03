-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc.ads                                                                                               --
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

with System;
with Interfaces;
with Bits;

package PowerPC is

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

   -- __REF__ http://lxr.free-electrons.com/source/arch/ppc/kernel/ppc-stub.c?v=2.6.24 use "twge r2,r2"
   -- BREAKPOINT_Instruction      : constant Unsigned_32 := 16#7FE0_0008#; -- tw (trap)
   BREAKPOINT_Instruction      : constant Unsigned_32 := 16#7D82_1008#; -- twge r2,r2
   BREAKPOINT_Instruction_Size : constant             := 4;
   BREAKPOINT_Asm_String       : constant String      := ".long 0x7D821008";

   procedure NOP;
   procedure BREAKPOINT;

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
   NIP   : constant := 64;
   MSR   : constant := 65;
   CR    : constant := 66;
   LR    : constant := 67;
   CTR   : constant := 68;
   XER   : constant := 69;
   FPSCR : constant := 70;

   subtype Register_Number_Type is Natural range R0 .. FPSCR;

   ----------------------------------------------------------------------------
   -- MSR
   ----------------------------------------------------------------------------

   type MSR_Register_Type is
   record
      Reserved1 : Bits_13_Zeroes := Bits_13_0; -- bit #0 .. #12 reserved
      POW       : Bits_1;
      Reserved2 : Bits_1_Zeroes := Bits_1_0; -- bit #14 reserved
      ILE       : Bits_1;
      EE        : Boolean;
      PR        : Bits_1;
      FP        : Bits_1;
      ME        : Bits_1;
      FE0       : Bits_1;
      SE        : Bits_1;
      BE        : Bits_1;
      FE1       : Bits_1;
      Reserved3 : Bits_1_Zeroes := Bits_1_0; -- bit #24 reserved
      IP        : Bits_1;
      IR        : Bits_1;
      DR        : Bits_1;
      Reserved4 : Bits_2_Zeroes := Bits_2_0; -- bit #28, #29 reserved
      RI        : Bits_1;
      LE        : Bits_1;
   end record with
      Size => 32;
   for MSR_Register_Type use
   record
      Reserved1 at 0 range 0 .. 12;
      POW       at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 14;
      ILE       at 0 range 15 .. 15;
      EE        at 0 range 16 .. 16;
      PR        at 0 range 17 .. 17;
      FP        at 0 range 18 .. 18;
      ME        at 0 range 19 .. 19;
      FE0       at 0 range 20 .. 20;
      SE        at 0 range 21 .. 21;
      BE        at 0 range 22 .. 22;
      FE1       at 0 range 23 .. 23;
      Reserved3 at 0 range 24 .. 24;
      IP        at 0 range 25 .. 25;
      IR        at 0 range 26 .. 26;
      DR        at 0 range 27 .. 27;
      Reserved4 at 0 range 28 .. 29;
      RI        at 0 range 30 .. 30;
      LE        at 0 range 31 .. 31;
   end record;

   function MSR_Read return MSR_Register_Type;
   procedure MSR_Write (Value : in MSR_Register_Type);

   ----------------------------------------------------------------------------
   -- SPRs subprogram templates
   ----------------------------------------------------------------------------

   type SPR_Type is mod 2**10; -- 0 .. 1023

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   function MFSPR return Register_Type;

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   procedure MTSPR (Value : in Register_Type);

   ----------------------------------------------------------------------------
   -- SPRs types and access subprograms
   ----------------------------------------------------------------------------

   PVR : constant SPR_Type := 287;
   type PVR_Register_Type is
   record
      Version  : Unsigned_16;
      Revision : Unsigned_16;
   end record with
      Size => 32;
   for PVR_Register_Type use
   record
      Version  at 0 range 0 .. 15;
      Revision at 0 range 16 .. 31;
   end record;
   function PVR_Read return PVR_Register_Type;

   -- SVR System Version Register
   -- 603e/e300 core: SPR 286
   -- EIS (Freescale extension): SPR 1023
   SVR : constant SPR_Type := 1023;
   function SVR_Read return Unsigned_32;

   ----------------------------------------------------------------------------
   -- Exceptions
   ----------------------------------------------------------------------------

   procedure Setup_Exception_Stack;

   ----------------------------------------------------------------------------
   -- Interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable;
   procedure Irq_Disable;
   function Irq_State_Get return Irq_State_Type;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type);

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (NOP);
   pragma Inline (BREAKPOINT);

   pragma Inline (MSR_Read);
   pragma Inline (MSR_Write);

   pragma Inline (MFSPR);
   pragma Inline (MTSPR);

   pragma Inline (PVR_Read);

   pragma Inline (Irq_Enable);
   pragma Inline (Irq_Disable);

end PowerPC;
