-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips32.adb                                                                                                --
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

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Definitions;

package body MIPS32
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   Register_Equates : constant String :=
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

   type CP0_Register_Type is range 16#00# .. 16#1F#;        -- 32 CP0 registers
   type CP0_Register_Select_Type is range 2#000# .. 2#111#; -- 3-bit select field

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CP0 access templates
   ----------------------------------------------------------------------------

   generic
      Register        : CP0_Register_Type;
      Register_Select : CP0_Register_Select_Type;
   function MFC0
      return Unsigned_32
      with Inline => True;

   function MFC0
      return Unsigned_32
      is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        mfc0    %0,$%1,%2" & CRLF &
                       "        nop              " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => [
                        CP0_Register_Type'Asm_Input ("i", Register),
                        CP0_Register_Select_Type'Asm_Input ("i", Register_Select)
                       ],
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFC0;

   generic
      Register        : CP0_Register_Type;
      Register_Select : CP0_Register_Select_Type;
   procedure MTC0
      (Register_Value : in Unsigned_32)
      with Inline => True;

   procedure MTC0
      (Register_Value : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        mtc0    %0,$%1,%2" & CRLF &
                       "        nop              " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("r", Register_Value),
                        CP0_Register_Type'Asm_Input ("i", Register),
                        CP0_Register_Select_Type'Asm_Input ("i", Register_Select)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MTC0;

   ----------------------------------------------------------------------------
   -- Count register (CP0 register 9, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Count_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (9, 0);
   begin
      return CP0_Read;
   end CP0_Count_Read;

   procedure CP0_Count_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (9, 0);
   begin
      CP0_Write (Value);
   end CP0_Count_Write;

   ----------------------------------------------------------------------------
   -- Compare register (CP0 register 11, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Compare_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (11, 0);
   begin
      return CP0_Read;
   end CP0_Compare_Read;

   procedure CP0_Compare_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (11, 0);
   begin
      CP0_Write (Value);
   end CP0_Compare_Write;

   ----------------------------------------------------------------------------
   -- Status Register (CP0 register 12, Select 0)
   ----------------------------------------------------------------------------

   function CP0_SR_Read
      return Status_Type
      is
      function To_ST is new Ada.Unchecked_Conversion (Unsigned_32, Status_Type);
      function CP0_Read is new MFC0 (12, 0);
   begin
      return To_ST (CP0_Read);
   end CP0_SR_Read;

   procedure CP0_SR_Write
      (Value : in Status_Type)
      is
      function To_U32 is new Ada.Unchecked_Conversion (Status_Type, Unsigned_32);
      procedure CP0_Write is new MTC0 (12, 0);
   begin
      CP0_Write (To_U32 (Value));
   end CP0_SR_Write;

   ----------------------------------------------------------------------------
   -- Cause register (CP0 register 13, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Cause_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (13, 0);
   begin
      return CP0_Read;
   end CP0_Cause_Read;

   procedure CP0_Cause_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (13, 0);
   begin
      CP0_Write (Value);
   end CP0_Cause_Write;

   ----------------------------------------------------------------------------
   -- Exception Program Counter register (CP0 register 14, Select 0)
   ----------------------------------------------------------------------------

   function CP0_EPC_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (14, 0);
   begin
      return CP0_Read;
   end CP0_EPC_Read;

   procedure CP0_EPC_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (14, 0);
   begin
      CP0_Write (Value);
   end CP0_EPC_Write;

   ----------------------------------------------------------------------------
   -- PRId register (CP0 register 15, Select 0)
   ----------------------------------------------------------------------------

   function CP0_PRId_Read
      return PRId_Type
      is
      function To_PRId is new Ada.Unchecked_Conversion (Unsigned_32, PRId_Type);
      function CP0_Read is new MFC0 (15, 0);
   begin
      return To_PRId (CP0_Read);
   end CP0_PRId_Read;

   ----------------------------------------------------------------------------
   -- Config register (CP0 register 16, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Config_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (16, 0);
   begin
      return CP0_Read;
   end CP0_Config_Read;

   procedure CP0_Config_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (16, 0);
   begin
      CP0_Write (Value);
   end CP0_Config_Write;

   ----------------------------------------------------------------------------
   -- Config1 register (CP0 register 16, Select 1)
   ----------------------------------------------------------------------------

   function CP0_Config1_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (16, 1);
   begin
      return CP0_Read;
   end CP0_Config1_Read;

   procedure CP0_Config1_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (16, 1);
   begin
      CP0_Write (Value);
   end CP0_Config1_Write;

   ----------------------------------------------------------------------------
   -- Debug register (CP0 register 23, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Debug_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (23, 0);
   begin
      return CP0_Read;
   end CP0_Debug_Read;

   procedure CP0_Debug_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (23, 0);
   begin
      CP0_Write (Value);
   end CP0_Debug_Write;

   ----------------------------------------------------------------------------
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Intcontext := 0; -- __TBD__
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
   begin
      null; -- __TBD__
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""                             & CRLF &
                       Register_Equates                      &
                       "        mfc0    $t0,CP0_SR,0" & CRLF &
                       "        nop                 " & CRLF &
                       "        ori     $t0,$t0,1   " & CRLF &
                       "        mtc0    $t0,CP0_SR,0" & CRLF &
                       "        nop                 " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "$t0",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
   begin
      Asm (
           Template => ""                             & CRLF &
                       Register_Equates                      &
                       "        mfc0    $t0,CP0_SR,0" & CRLF &
                       "        nop                 " & CRLF &
                       "        li      $t1,1       " & CRLF &
                       "        not     $t1,$t1     " & CRLF &
                       "        and     $t0,$t0,$t1 " & CRLF &
                       "        mtc0    $t0,CP0_SR,0" & CRLF &
                       "        nop                 " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "$t0,$t1",
           Volatile => True
          );
   end Irq_Disable;

   procedure Irq_Level_Set
      (Irq_Level : in Irq_Level_Type)
      is
   begin
      Asm (
           Template => ""                             & CRLF &
                       Register_Equates                      &
                       "        mfc0    $t0,CP0_SR,0" & CRLF &
                       "        nop                 " & CRLF &
                       "        li      $t1,0xFC    " & CRLF &
                       "        not     $t1,$t1     " & CRLF &
                       "        and     $t0,$t0,$t1 " & CRLF &
                       "        sll     $t1,%0,10   " & CRLF &
                       "        or      $t0,$t0,$t1 " & CRLF &
                       "        mtc0    $t0,CP0_SR,0" & CRLF &
                       "        nop                 " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Irq_Level_Type'Asm_Input ("r", Irq_Level),
           Clobber  => "$t0,$t1",
           Volatile => True
          );
   end Irq_Level_Set;

end MIPS32;
