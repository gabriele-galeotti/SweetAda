-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc.ads                                                                                               --
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
with PowerPC_Definitions;

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

   subtype MSR_Type is PowerPC_Definitions.MSR_Type;

   function MSR_Read
      return MSR_Type
      with Inline => True;
   procedure MSR_Write
      (Value : in MSR_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- FPSCR
   ----------------------------------------------------------------------------

   -- C  Floating-point result class descriptor (C).
   -- FL Floating-point less than or negative (FL or <)
   -- FG Floating-point greater than or positive (FG or >)
   -- FE Floating-point equal or zero (FE or =)
   -- FU Floating-point unordered or NaN (FU or ?)
   --                           CFFFF
   --                            LGEU
   FPRF_QNan    : constant := 2#10001#; -- Quiet NaN
   FPRF_MInf    : constant := 2#01001#; -- –Infinity
   FPRF_MNorm   : constant := 2#01000#; -- –Normalized number
   FPRF_MDenorm : constant := 2#11000#; -- –Denormalized number
   FPRF_MZero   : constant := 2#10010#; -- –Zero
   FPRF_Zero    : constant := 2#00010#; -- +Zero
   FPRF_Denorm  : constant := 2#10100#; -- +Denormalized number
   FPRF_Norm    : constant := 2#00100#; -- +Normalized number
   FPRF_Inf     : constant := 2#00101#; -- +Infinity

   RN_Nearest : constant := 2#00#; -- Round to nearest
   RN_ToZero  : constant := 2#01#; -- Round toward zero
   RN_ToInf   : constant := 2#10#; -- Round toward +infinity
   RN_ToMInf  : constant := 2#11#; -- Round toward –infinity

   type FPSCR_Type is record
      FX       : Boolean;      -- Floating-point exception summary.
      FEX      : Boolean;      -- Floating-point enabled exception summary
      VX       : Boolean;      -- Floating-point invalid operation exception summary.
      OX       : Boolean;      -- Floating-point overflow exception.
      UX       : Boolean;      -- Floating-point underflow exception.
      ZX       : Boolean;      -- Floating-point zero divide exception.
      XX       : Boolean;      -- Floating-point inexact exception.
      VXSNAN   : Boolean;      -- Floating-point invalid operation exception for SNaN.
      VXISI    : Boolean;      -- Floating-point invalid operation exception for ∞ – ∞.
      VXIDI    : Boolean;      -- Floating-point invalid operation exception for ∞ ÷ ∞.
      VXZDZ    : Boolean;      -- Floating-point invalid operation exception for 0 ÷ 0.
      VXIMZ    : Boolean;      -- Floating-point invalid operation exception for ∞ * 0.
      VXVC     : Boolean;      -- Floating-point invalid operation exception for invalid compare.
      FR       : Boolean;      -- Floating-point fraction rounded.
      FI       : Boolean;      -- Floating-point fraction inexact.
      FPRF     : Bits_5;       -- Floating-point result flags.
      Reserved : Bits_1  := 0;
      VXSOFT   : Boolean;      -- Floating-point invalid operation exception for software request.
      VXSQRT   : Boolean;      -- Floating-point invalid operation exception for invalid square root.
      VXCVI    : Boolean;      -- Floating-point invalid operation exception for invalid integer convert.
      VE       : Boolean;      -- Floating-point invalid operation exception enable.
      OE       : Boolean;      -- IEEE floating-point overflow exception enable.
      UE       : Boolean;      -- IEEE floating-point underflow exception enable.
      ZE       : Boolean;      -- IEEE floating-point zero divide exception enable.
      XE       : Boolean;      -- Floating-point inexact exception enable.
      NI       : Boolean;      -- Floating-point non-IEEE mode.
      RN       : Bits_2;       -- Floating-point rounding control.
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for FPSCR_Type use record
      FX       at 0 range  0 ..  0;
      FEX      at 0 range  1 ..  1;
      VX       at 0 range  2 ..  2;
      OX       at 0 range  3 ..  3;
      UX       at 0 range  4 ..  4;
      ZX       at 0 range  5 ..  5;
      XX       at 0 range  6 ..  6;
      VXSNAN   at 0 range  7 ..  7;
      VXISI    at 0 range  8 ..  8;
      VXIDI    at 0 range  9 ..  9;
      VXZDZ    at 0 range 10 .. 10;
      VXIMZ    at 0 range 11 .. 11;
      VXVC     at 0 range 12 .. 12;
      FR       at 0 range 13 .. 13;
      FI       at 0 range 14 .. 14;
      FPRF     at 0 range 15 .. 19;
      Reserved at 0 range 20 .. 20;
      VXSOFT   at 0 range 21 .. 21;
      VXSQRT   at 0 range 22 .. 22;
      VXCVI    at 0 range 23 .. 23;
      VE       at 0 range 24 .. 24;
      OE       at 0 range 25 .. 25;
      UE       at 0 range 26 .. 26;
      ZE       at 0 range 27 .. 27;
      XE       at 0 range 28 .. 28;
      NI       at 0 range 29 .. 29;
      RN       at 0 range 30 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- XER
   ----------------------------------------------------------------------------

   type XER_Type is record
      SO         : Boolean;                     -- Summary overflow.
      OV         : Boolean;                     -- Overflow.
      CA         : Boolean;                     -- Carry.
      Reserved   : Bits_22 := 0;
      Byte_count : Natural range 0 .. 2**7 - 1; -- # of bytes in lswx and stswx instructions
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for XER_Type use record
      SO         at 0 range  0 ..  0;
      OV         at 0 range  1 ..  1;
      CA         at 0 range  2 ..  2;
      Reserved   at 0 range  3 .. 24;
      Byte_count at 0 range 25 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- SPRs
   ----------------------------------------------------------------------------

   type SPR_Type is mod 2**10; -- 0 .. 1023

   XER    : constant SPR_Type := 1;    -- Fixed-point exception register.
   LR     : constant SPR_Type := 8;    -- Used as a branch target address or holds a return address.
   CTR    : constant SPR_Type := 9;    -- Used for loop count decrement and branching.
   DSISR  : constant SPR_Type := 18;
   DAR    : constant SPR_Type := 19;
   DEC    : constant SPR_Type := 22;
   SDR1   : constant SPR_Type := 25;
   SRR0   : constant SPR_Type := 26;
   SRR1   : constant SPR_Type := 27;
   SPRG0  : constant SPR_Type := 272;
   SPRG1  : constant SPR_Type := 273;
   SPRG2  : constant SPR_Type := 274;
   SPRG3  : constant SPR_Type := 275;
   ASR    : constant SPR_Type := 280;  -- 64-bit only
   EAR    : constant SPR_Type := 282;  -- optional
   TBL    : constant SPR_Type := 284;
   TBU    : constant SPR_Type := 285;
   PVR    : constant SPR_Type := 287;  -- 0x11F
   IBAT0U : constant SPR_Type := 528;
   IBAT0L : constant SPR_Type := 529;
   IBAT1U : constant SPR_Type := 530;
   IBAT1L : constant SPR_Type := 531;
   IBAT2U : constant SPR_Type := 532;
   IBAT2L : constant SPR_Type := 533;
   IBAT3U : constant SPR_Type := 534;
   IBAT3L : constant SPR_Type := 535;
   DBAT0U : constant SPR_Type := 536;
   DBAT0L : constant SPR_Type := 537;
   DBAT1U : constant SPR_Type := 538;
   DBAT1L : constant SPR_Type := 539;
   DBAT2U : constant SPR_Type := 540;
   DBAT2L : constant SPR_Type := 541;
   DBAT3U : constant SPR_Type := 542;
   DBAT3L : constant SPR_Type := 543;
   DABR   : constant SPR_Type := 1013; -- optional

   ----------------------------------------------------------------------------
   -- SPRs subprogram templates
   ----------------------------------------------------------------------------

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   function MFSPR
      return Register_Type
      with Inline => True;

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   procedure MTSPR
      (Value : in Register_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- SPRs types and access subprograms
   ----------------------------------------------------------------------------

   type PVR_Type is record
      Version  : Unsigned_16;
      Revision : Unsigned_16;
   end record
      with Size => 32;
   for PVR_Type use record
      Version  at 0 range  0 .. 15;
      Revision at 0 range 16 .. 31;
   end record;

   function PVR_Read
      return PVR_Type
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
