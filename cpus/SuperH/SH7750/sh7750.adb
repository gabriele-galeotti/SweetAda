-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7750.adb                                                                                                --
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

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Definitions;

package body SH7750 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

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
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT is
   begin
      Asm (
           Template => " " & BREAKPOINT_Asm_String,
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- Status Register Read/Write
   ----------------------------------------------------------------------------

   function Status_Register_Read return Status_Register_Type is
      Value : Unsigned_32;
      function To_SR is new Ada.Unchecked_Conversion (Unsigned_32, Status_Register_Type);
   begin
      Asm (
           Template => " stc sr,%0",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return To_SR (Value);
   end Status_Register_Read;

   procedure Status_Register_Write (Value : in Status_Register_Type) is
      function To_U32 is new Ada.Unchecked_Conversion (Status_Register_Type, Unsigned_32);
   begin
      Asm (
           Template => " ldc %0,sr",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_32'Asm_Input ("r", To_U32 (Value)),
           Clobber  => "",
           Volatile => True
          );
   end Status_Register_Write;

end SH7750;
