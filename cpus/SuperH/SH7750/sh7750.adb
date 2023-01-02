-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7750.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
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
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT is
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        " & BREAKPOINT_Asm_String & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
   begin
      Asm (
           Template => ""                    & CRLF &
                       "        jsr     @%0" & CRLF &
                       "        nop        " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("r", Target_Address),
           Clobber  => "pr",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Status Register Read/Write
   ----------------------------------------------------------------------------

   function SR_Read return SR_Type is
      Value : Unsigned_32;
      function To_SR is new Ada.Unchecked_Conversion (Unsigned_32, SR_Type);
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        stc     sr,%0" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return To_SR (Value);
   end SR_Read;

   procedure SR_Write (Value : in SR_Type) is
      function To_U32 is new Ada.Unchecked_Conversion (SR_Type, Unsigned_32);
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        ldc     %0,sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_32'Asm_Input ("r", To_U32 (Value)),
           Clobber  => "",
           Volatile => True
          );
   end SR_Write;

end SH7750;
