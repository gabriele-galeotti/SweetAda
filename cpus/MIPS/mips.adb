-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips.adb                                                                                                  --
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
with GCC.Defines;

package body MIPS
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

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
      Register : CP0_Register_Type;
   function MFC0
      return Unsigned_32
      with Inline => True;

   function MFC0
      return Unsigned_32
      is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        mfc0    %0,$%1" & CRLF &
                       "        nop           " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => CP0_Register_Type'Asm_Input ("i", Register),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFC0;

   generic
      Register : CP0_Register_Type;
   procedure MTC0
      (Register_Value : in Unsigned_32)
      with Inline => True;

   procedure MTC0
      (Register_Value : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        mtc0    %0,$%1" & CRLF &
                       "        nop           " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("r", Register_Value),
                        CP0_Register_Type'Asm_Input ("i", Register)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MTC0;

   ----------------------------------------------------------------------------
   -- CP0_Count_Read/Write (CP0 register 9, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Count_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (9);
   begin
      return CP0_Read;
   end CP0_Count_Read;

   procedure CP0_Count_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (9);
   begin
      CP0_Write (Value);
   end CP0_Count_Write;

   ----------------------------------------------------------------------------
   -- CP0_Compare_Read/Write (CP0 register 11, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Compare_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (11);
   begin
      return CP0_Read;
   end CP0_Compare_Read;

   procedure CP0_Compare_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (11);
   begin
      CP0_Write (Value);
   end CP0_Compare_Write;

   ----------------------------------------------------------------------------
   -- CP0_SR_Read/Write (CP0 register 12, Select 0)
   ----------------------------------------------------------------------------

   function CP0_SR_Read
      return SR_Type
      is
      function To_SR is new Ada.Unchecked_Conversion (Unsigned_32, SR_Type);
      function CP0_Read is new MFC0 (12);
   begin
      return To_SR (CP0_Read);
   end CP0_SR_Read;

   procedure CP0_SR_Write
      (Value : in SR_Type)
      is
      function To_U32 is new Ada.Unchecked_Conversion (SR_Type, Unsigned_32);
      procedure CP0_Write is new MTC0 (12);
   begin
      CP0_Write (To_U32 (Value));
   end CP0_SR_Write;

   ----------------------------------------------------------------------------
   -- CP0_PRId_Read (CP0 register 15, Select 0)
   ----------------------------------------------------------------------------

   function CP0_PRId_Read
      return PRId_Type
      is
      function To_PRId is new Ada.Unchecked_Conversion (Unsigned_32, PRId_Type);
      function CP0_Read is new MFC0 (15);
   begin
      return To_PRId (CP0_Read);
   end CP0_PRId_Read;

   ----------------------------------------------------------------------------
   -- CP0_Config_Read/Write (CP0 register 16, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Config_Read
      return Unsigned_32
      is
      function CP0_Read is new MFC0 (16);
   begin
      return CP0_Read;
   end CP0_Config_Read;

   procedure CP0_Config_Write
      (Value : in Unsigned_32)
      is
      procedure CP0_Write is new MTC0 (16);
   begin
      CP0_Write (Value);
   end CP0_Config_Write;

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- BREAK
   ----------------------------------------------------------------------------
   procedure BREAK
      is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        break" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAK;

   ----------------------------------------------------------------------------
   -- SYNC
   ----------------------------------------------------------------------------
   procedure SYNC
      is
   begin
      if GCC.Defines.MIPS_ISA > GCC.Defines.MIPS_ISA_MIPS32 then
         Asm (
              Template => ""             & CRLF &
                          "        sync" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => No_Input_Operands,
              Clobber  => "memory",
              Volatile => True
             );
      end if;
   end SYNC;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        .set    noreorder" & CRLF &
                       "        jal     %0       " & CRLF &
                       "        nop              " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("r", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Level_Set
   ----------------------------------------------------------------------------
   procedure Irq_Level_Set
      (Irq_Level : in Irq_Level_Type)
      is
   begin
      CP0_SR_Write ((CP0_SR_Read with delta IM => Irq_Level));
   end Irq_Level_Set;

   ----------------------------------------------------------------------------
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Intcontext := CP0_SR_Read;
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
   begin
      CP0_SR_Write ((CP0_SR_Read with delta IE  => Intcontext.IE,
                                            EXL => Intcontext.EXL,
                                            ERL => Intcontext.ERL,
                                            KSU => Intcontext.KSU,
                                            IM  => Intcontext.IM));
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
   begin
      CP0_SR_Write ((CP0_SR_Read with delta IE => True));
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
   begin
      CP0_SR_Write ((CP0_SR_Read with delta IE => False));
   end Irq_Disable;

end MIPS;
