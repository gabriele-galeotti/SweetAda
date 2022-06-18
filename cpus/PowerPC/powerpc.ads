-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc.ads                                                                                               --
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

   Opcode_BREAKPOINT      : constant := 16#7D82_1008#; -- twge r2,r2
   Opcode_BREAKPOINT_Size : constant := 4;

   BREAKPOINT_Asm_String : constant String := ".long   0x7D821008";

   procedure NOP with
      Inline => True;
   procedure BREAKPOINT with
      Inline => True;
   procedure SYNC with
      Inline => True;
   procedure ISYNC with
      Inline => True;

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

   -- 2.3.1 Machine State Register (MSR)

   PR_US : constant := 0; -- The processor can execute both user- and supervisor-level instructions.
   PR_U  : constant := 1; -- The processor can only execute user-level instructions.

   type FE_Type is
   record
      FE0 : Bits_1;
      FE1 : Bits_1;
   end record;

   FE_DISABLED    : constant FE_Type := (0, 0); -- Floating-point exceptions disabled
   FE_IMPRECISENR : constant FE_Type := (0, 1); -- Floating-point imprecise nonrecoverable
   FE_IMPRECISE   : constant FE_Type := (1, 0); -- Floating-point imprecise recoverable
   FE_PRECISE     : constant FE_Type := (1, 1); -- Floating-point precise mode

   IP_LOW  : constant := 0; -- Interrupts are vectored to the physical address 0x000n_nnnn.
   IP_HIGH : constant := 1; -- Interrupts are vectored to the physical address 0xFFFn_nnnn.

   type MSR_Type is
   record
      Reserved1 : Bits_13 := 0;
      POW       : Boolean;      -- Power management enable
      Reserved2 : Bits_1 := 0;
      ILE       : Boolean;      -- Interrupt little-endian mode.
      EE        : Boolean;      -- External interrupt enable
      PR        : Bits_1;       -- Privilege level
      FP        : Boolean;      -- Floating-point available
      ME        : Boolean;      -- Machine check enable
      FE0       : Bits_1;       -- Floating-point exception mode 0
      SE        : Boolean;      -- Single-step trace enable
      BE        : Boolean;      -- Branch trace enable
      FE1       : Bits_1;       -- Floating-point exception mode 1
      Reserved3 : Bits_1 := 0;
      IP        : Bits_1;       -- Interrupt prefix
      IR        : Boolean;      -- Instruction address translation
      DR        : Boolean;      -- Data address translation
      Reserved4 : Bits_2 := 0;
      RI        : Boolean;      -- Recoverable interrupt
      LE        : Boolean;      -- Little-endian mode enable
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for MSR_Type use
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

   function MSR_Read return MSR_Type with
      Inline => True;
   procedure MSR_Write (Value : in MSR_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- SPRs subprogram templates
   ----------------------------------------------------------------------------

   type SPR_Type is mod 2**10; -- 0 .. 1023

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   function MFSPR return Register_Type with
      Inline => True;

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   procedure MTSPR (Value : in Register_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- SPRs types and access subprograms
   ----------------------------------------------------------------------------

   PVR : constant SPR_Type := 287; -- 0x11F

   type PVR_Type is
   record
      Version  : Unsigned_16;
      Revision : Unsigned_16;
   end record with
      Size => 32;
   for PVR_Type use
   record
      Version  at 0 range 0 .. 15;
      Revision at 0 range 16 .. 31;
   end record;

   function PVR_Read return PVR_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions
   ----------------------------------------------------------------------------

   procedure Setup_Exception_Stack;

   ----------------------------------------------------------------------------
   -- Interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type);

end PowerPC;
