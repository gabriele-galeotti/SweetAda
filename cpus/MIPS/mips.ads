-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;

package MIPS
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
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MIPS PRId values
   ----------------------------------------------------------------------------

   -- Imp
   ID_R2000      : constant := 1;
   ID_R3000      : constant := 2;      -- IDT R3051, R3052, R3071, R3081, most early 32-bit MIPS CPUs
   ID_R6000      : constant := 3;
   ID_R4000      : constant := 4;      -- R4400
   ID_LSI        : constant := 5;      -- LSI Logic 32-bit CPUs
   ID_R6000A     : constant := 6;
   ID_R3041      : constant := 7;
   ID_R10000     : constant := 9;
   ID_NEC_Vr4200 : constant := 10;
   ID_NEC_Vr4300 : constant := 11;
   ID_R8000      : constant := 16;
   ID_R4600      : constant := 32;
   ID_R4700      : constant := 33;
   ID_R3900      : constant := 34;
   ID_R5000      : constant := 35;
   ID_QED_RM5230 : constant := 40;     -- RM5260
   ID_5K         : constant := 16#81#;
   ID_24K        : constant := 16#93#;

   ID_COMPANY_LEGACY   : constant := 16#00#;
   ID_COMPANY_MIPS     : constant := 16#01#;
   ID_COMPANY_BROADCOM : constant := 16#02#;

   ----------------------------------------------------------------------------
   -- MIPS registers
   ----------------------------------------------------------------------------

   R0   : constant := 0;   R1   : constant := 1;   R2   : constant := 2;   R3   : constant := 3;
   R4   : constant := 4;   R5   : constant := 5;   R6   : constant := 6;   R7   : constant := 7;
   R8   : constant := 8;   R9   : constant := 9;   R10  : constant := 10;  R11  : constant := 11;
   R12  : constant := 12;  R13  : constant := 13;  R14  : constant := 14;  R15  : constant := 15;
   R16  : constant := 16;  R17  : constant := 17;  R18  : constant := 18;  R19  : constant := 19;
   R20  : constant := 20;  R21  : constant := 21;  R22  : constant := 22;  R23  : constant := 23;
   R24  : constant := 24;  R25  : constant := 25;  R26  : constant := 26;  R27  : constant := 27;
   R28  : constant := 28;  R29  : constant := 29;  R30  : constant := 30;  R31  : constant := 31;

   ZERO : constant := R0;  ATR  : constant := R1;  V0   : constant := R2;  V1   : constant := R3;
   A0   : constant := R4;  A1   : constant := R5;  A2   : constant := R6;  A3   : constant := R7;
   T0   : constant := R8;  T1   : constant := R9;  T2   : constant := R10; T3   : constant := R11;
   T4   : constant := R12; T5   : constant := R13; T6   : constant := R14; T7   : constant := R15;
   S0   : constant := R16; S1   : constant := R17; S2   : constant := R18; S3   : constant := R19;
   S4   : constant := R20; S5   : constant := R21; S6   : constant := R22; S7   : constant := R23;
   T8   : constant := R24; T9   : constant := R25; K0   : constant := R26; K1   : constant := R27;
   GP   : constant := R28; SP   : constant := R29; FP   : constant := R30; RA   : constant := R31;

   subtype Register_Number_Type is Natural range R0 .. R31;

   Register_Size : constant array (R0 .. R31) of Positive :=
      [R0  => 4, R1  => 4, R2  => 4, R3  => 4, R4  => 4, R5  => 4, R6  => 4, R7  => 4,
       R8  => 4, R9  => 4, R10 => 4, R11 => 4, R12 => 4, R13 => 4, R14 => 4, R15 => 4,
       R16 => 4, R17 => 4, R18 => 4, R19 => 4, R20 => 4, R21 => 4, R22 => 4, R23 => 4,
       R24 => 4, R25 => 4, R26 => 4, R27 => 4, R28 => 4, R29 => 4, R30 => 4, R31 => 4];

   Maximum_Register_Size : constant := 4;

   ----------------------------------------------------------------------------
   -- KSEGs
   ----------------------------------------------------------------------------

   KUSEG_ADDRESS : constant := 16#0000_0000#;
   KSEG0_ADDRESS : constant := 16#8000_0000#;
   KSEG1_ADDRESS : constant := 16#A000_0000#;
   KSEG2_ADDRESS : constant := 16#C000_0000#;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;
   procedure BREAK
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   LOCK_UNLOCK : constant CPU_Unsigned := 0;
   LOCK_LOCK   : constant CPU_Unsigned := 1;

   type Lock_Type is record
      Lock : aliased CPU_Unsigned := LOCK_UNLOCK with Atomic => True;
   end record
      with Size => CPU_Unsigned'Size;

pragma Style_Checks (On);

end MIPS;
