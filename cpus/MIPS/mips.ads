-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips.ads                                                                                                  --
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
with Definitions;
with Bits;

package MIPS
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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MIPS32® 24K® Processor Core Family
   -- Software User’s Manual
   -- Document Number: MD00343 Revision 03.11 December 19, 2008
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Registers
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

   type CP0_Register_Type is range 16#00# .. 16#1F#;

   CRLF : String renames Definitions.CRLF;

   Asm_Register_Equates : constant String :=
      "        .equ    CP0_INDEX,   $0 " & CRLF &
      "        .equ    CP0_ENTRYLO, $2 " & CRLF &
      "        .equ    CP0_CONTEXT, $4 " & CRLF &
      "        .equ    CP0_BADVADDR,$8 " & CRLF &
      "        .equ    CP0_COUNT,   $9 " & CRLF &
      "        .equ    CP0_ENTRYHI, $10" & CRLF &
      "        .equ    CP0_COMPARE, $11" & CRLF &
      "        .equ    CP0_SR,      $12" & CRLF &
      "        .equ    CP0_CAUSE,   $13" & CRLF &
      "        .equ    CP0_EPC,     $14" & CRLF &
      "        .equ    CP0_PRID,    $15" & CRLF &
      "        .equ    CP0_CONFIG,  $16" & CRLF &
      "        .equ    CP0_WATCHLO, $18" & CRLF &
      "        .equ    CP0_WATCHHI, $19" & CRLF &
      "        .equ    CP0_XCONTEXT,$20" & CRLF &
      "        .equ    CP0_DEBUG,   $23" & CRLF;

   ----------------------------------------------------------------------------
   -- Chapter 4 Memory Management of the 24K® Core
   ----------------------------------------------------------------------------

   KUSEG_ADDRESS : constant := 16#0000_0000#;
   KSEG0_ADDRESS : constant := 16#8000_0000#;
   KSEG1_ADDRESS : constant := 16#A000_0000#;
   KSEG2_ADDRESS : constant := 16#C000_0000#;

   ----------------------------------------------------------------------------
   -- Chapter 6 CP0 Registers of the 24K® Core
   ----------------------------------------------------------------------------

   -- 6.2.10 Count Register (CP0 Register 9, Select 0)

   function CP0_Count_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Count_Write
      (Value : in Unsigned_32)
      with Inline => True;

   -- 6.2.12 Compare Register (CP0 Register 11, Select 0)

   function CP0_Compare_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Compare_Write
      (Value : in Unsigned_32)
      with Inline => True;

   -- 6.2.13 Status Register (CP0 Register 12, Select 0)

   KSU_Kernel     : constant := 2#00#; -- Base mode is Kernel Mode
   KSU_Supervisor : constant := 2#01#; -- Base mode is Supervisor Mode
   KSU_User       : constant := 2#10#; -- Base mode is User Mode
   KSU_Reserved   : constant := 2#11#; -- Reserved

   FR_32  : constant := 0; -- FP registers can contain any 32-bit datatype. 64-bit in even-odd pairs of registers
   FR_ANY : constant := 1; -- FP registers can contain any datatype

   type SR_Type is record
      IE        : Boolean;      -- Interrupt Enable
      EXL       : Boolean;      -- Exception Level
      ERL       : Boolean;      -- Error Level
      KSU       : Bits_2;       -- base operating mode of the processor
      Reserved1 : Bits_1  := 0; -- UX
      Reserved2 : Bits_1  := 0; -- SX
      Reserved3 : Bits_1  := 0; -- KX
      IM        : Bits_8;       -- Interrupt Mask (or IPL)
      Reserved4 : Bits_1  := 0;
      CEE       : Boolean;      -- CorExtend Enable
      ZERO      : Bits_1  := 0; -- Reserved
      NMI       : Boolean;      -- entry through the reset exception vector was due to an NMI
      SR        : Boolean;      -- entry through the reset exception vector was due to a Soft Reset
      TS        : Boolean;      -- TLB shutdown
      BEV       : Boolean;      -- Controls the location of exception vectors
      Reserved5 : Bits_1  := 0;
      MX        : Boolean;      -- Enables access to DSP ASE resources
      RE        : Boolean;      -- enable reverse-endian memory references while the processor is running in user mode
      FR        : Bits_1;       -- control the floating point register mode for 64-bit floating point units
      RP        : Boolean;      -- Enables reduced power mode
      CU0       : Boolean;
      CU1       : Boolean;
      CU2       : Boolean;
      CU3       : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SR_Type use record
      IE        at 0 range  0 ..  0;
      EXL       at 0 range  1 ..  1;
      ERL       at 0 range  2 ..  2;
      KSU       at 0 range  3 ..  4;
      Reserved1 at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      Reserved3 at 0 range  7 ..  7;
      IM        at 0 range  8 .. 15;
      Reserved4 at 0 range 16 .. 16;
      CEE       at 0 range 17 .. 17;
      ZERO      at 0 range 18 .. 18;
      NMI       at 0 range 19 .. 19;
      SR        at 0 range 20 .. 20;
      TS        at 0 range 21 .. 21;
      BEV       at 0 range 22 .. 22;
      Reserved5 at 0 range 23 .. 23;
      MX        at 0 range 24 .. 24;
      RE        at 0 range 25 .. 25;
      FR        at 0 range 26 .. 26;
      RP        at 0 range 27 .. 27;
      CU0       at 0 range 28 .. 28;
      CU1       at 0 range 29 .. 29;
      CU2       at 0 range 30 .. 30;
      CU3       at 0 range 31 .. 31;
   end record;

   function CP0_SR_Read
      return SR_Type
      with Inline => True;
   procedure CP0_SR_Write
      (Value : in SR_Type)
      with Inline => True;

   -- 6.2.19 Processor Identification (CP0 Register 15, Select 0)

   Processor_ID_R2000      : constant := 1;
   Processor_ID_R3000      : constant := 2;      -- IDT R3051, R3052, R3071, R3081, most early 32-bit MIPS CPUs
   Processor_ID_R6000      : constant := 3;
   Processor_ID_R4000      : constant := 4;      -- R4400
   Processor_ID_LSI        : constant := 5;      -- LSI Logic 32-bit CPUs
   Processor_ID_R6000A     : constant := 6;
   Processor_ID_R3041      : constant := 7;
   Processor_ID_R10000     : constant := 9;
   Processor_ID_NEC_Vr4200 : constant := 10;
   Processor_ID_NEC_Vr4300 : constant := 11;
   Processor_ID_R8000      : constant := 16;
   Processor_ID_R4600      : constant := 32;
   Processor_ID_R4700      : constant := 33;
   Processor_ID_R3900      : constant := 34;
   Processor_ID_R5000      : constant := 35;
   Processor_ID_QED_RM5230 : constant := 40;     -- RM5260
   Processor_ID_5K         : constant := 16#81#;
   Processor_ID_20K        : constant := 16#82#;
   Processor_ID_24K        : constant := 16#93#;

   Company_ID_LEGACY   : constant := 16#00#;
   Company_ID_MIPS     : constant := 16#01#;
   Company_ID_BROADCOM : constant := 16#02#;

   type PRId_Type is record
      Revision       : Unsigned_8; -- Specifies the revision number of the processor.
      Processor_ID   : Unsigned_8; -- Identifies the type of processor.
      Company_ID     : Unsigned_8; -- Identifies the company that designed or manufactured the processor.
      Company_Option : Unsigned_8; -- Implementation specific values
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PRId_Type use record
      Revision       at 0 range  0 ..  7;
      Processor_ID   at 0 range  8 .. 15;
      Company_ID     at 0 range 16 .. 23;
      Company_Option at 0 range 24 .. 31;
   end record;

   function CP0_PRId_Read
      return PRId_Type
      with Inline => True;

   -- 6.2.21 Config Register (CP0 Register 16, Select 0)

   function CP0_Config_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Config_Write
      (Value : in Unsigned_32)
      with Inline => True;

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
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Natural;
   subtype Irq_Id_Type is Natural;
   subtype Irq_Level_Type is Unsigned_16 range 0 .. 63;

   procedure Irq_Level_Set
      (Irq_Level : in Irq_Level_Type)
      with Inline => True;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end MIPS;
