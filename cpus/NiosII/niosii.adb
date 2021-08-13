-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ niosii.adb                                                                                                --
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
with Definitions;

package body NiosII is

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
   -- CPUID
   ----------------------------------------------------------------------------
   function CPUID return Unsigned_32 is
      Value : Unsigned_32;
   begin
      Asm (
           Template => " rdctl %0,cpuid",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CPUID;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
   begin
      Asm (
           Template => " mov r2,%0" & CRLF &
                       " callr r2",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "r2",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable (Irq_Line : in Natural) is
   begin
      Asm (
           Template => " rdctl r2,ienable" & CRLF &
                       " or r2,r2,%0"      & CRLF &
                       " wrctl ienable,r2",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_32'Asm_Input ("r", 2 ** Irq_Line),
           Clobber  => "r2",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Enable is
   begin
      Asm (
           Template => " rdctl r2,status" & CRLF &
                       " ori r2,r2,1"     & CRLF &
                       " wrctl status,r2",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "r2",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      Asm (
           Template => " rdctl r2,status"   & CRLF &
                       " andi r2,r2,0xFFFE" & CRLF &
                       " wrctl status,r2",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "r2",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
      Value : Unsigned_32;
   begin
      Asm (
           Template => " rdctl %0,status",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return (Value and PIE) /= 0;
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
   begin
      if Irq_State then
         Irq_Enable;
      else
         Irq_Disable;
      end if;
   end Irq_State_Set;

end NiosII;
