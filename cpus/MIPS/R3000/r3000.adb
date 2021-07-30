-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips-r3000.adb                                                                                            --
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

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Definitions;

package body R3000 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   type CP0_Register_Type is range 0 .. 31; -- 32 CP0 registers

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP is
   begin
      Asm (
           Template => " nop",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- CP0 access templates
   ----------------------------------------------------------------------------
   -- MIPS R3000 has no register select
   ----------------------------------------------------------------------------

   generic
      Register : CP0_Register_Type;
   function MFC0 return Unsigned_32;
   pragma Inline (MFC0);
   function MFC0 return Unsigned_32 is
      Result : Unsigned_32;
   begin
      Asm (
           Template => " mfc0 %0,$%1" & CRLF &
                       " nop",
           Outputs  => Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => (
                        CP0_Register_Type'Asm_Input ("i", Register)
                       ),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFC0;

   generic
      Register : CP0_Register_Type;
   procedure MTC0 (Register_Value : in Unsigned_32);
   pragma Inline (MTC0);
   procedure MTC0 (Register_Value : in Unsigned_32) is
   begin
      Asm (
           Template => " mtc0 %0,$%1" & CRLF &
                       " nop",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Unsigned_32'Asm_Input ("r", Register_Value),
                        CP0_Register_Type'Asm_Input ("i", Register)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end MTC0;

   ----------------------------------------------------------------------------
   -- Status Register (CP0 register 12)
   ----------------------------------------------------------------------------

   function CP0_SR_Read return Status_Register_Type is
      function U32_To_SRT is new Ada.Unchecked_Conversion (Unsigned_32, Status_Register_Type);
      function CP0_Read is new MFC0 (12);
   begin
      return U32_To_SRT (CP0_Read);
   end CP0_SR_Read;

   procedure CP0_SR_Write (Value : in Status_Register_Type) is
      function SRT_To_U32 is new Ada.Unchecked_Conversion (Status_Register_Type, Unsigned_32);
      procedure CP0_Write is new MTC0 (12);
   begin
      CP0_Write (SRT_To_U32 (Value));
   end CP0_SR_Write;

   ----------------------------------------------------------------------------
   -- PRId register (CP0 register 15)
   ----------------------------------------------------------------------------

   function CP0_PRId_Read return PRId_Register_Type is
      function U32_To_PRId is new Ada.Unchecked_Conversion (Unsigned_32, PRId_Register_Type);
      function CP0_Read is new MFC0 (15);
   begin
      return U32_To_PRId (CP0_Read);
   end CP0_PRId_Read;

end R3000;
