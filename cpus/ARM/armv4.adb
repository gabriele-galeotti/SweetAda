-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv4.adb                                                                                                 --
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
with Definitions;

package body ARMv4 is

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
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT
      is
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
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
      CPSR_R : Bits_32;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,cpsr    " & CRLF &
                       "        bic     %0,%0,#0x80" & CRLF &
                       "        msr     cpsr_c,%0  " & CRLF &
                       "",
           Outputs  => Bits_32'Asm_Output ("=r", CPSR_R),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
      CPSR_R : Bits_32;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,cpsr    " & CRLF &
                       "        orr     %0,%0,#0x80" & CRLF &
                       "        msr     cpsr_c,%0  " & CRLF &
                       "",
           Outputs  => Bits_32'Asm_Output ("=r", CPSR_R),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   ----------------------------------------------------------------------------
   -- Fiq_Enable
   ----------------------------------------------------------------------------
   procedure Fiq_Enable
      is
      CPSR_R : Bits_32;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,cpsr    " & CRLF &
                       "        bic     %0,%0,#0x40" & CRLF &
                       "        msr     cpsr_c,%0  " & CRLF &
                       "",
           Outputs  => Bits_32'Asm_Output ("=r", CPSR_R),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Fiq_Enable;

   ----------------------------------------------------------------------------
   -- Fiq_Disable
   ----------------------------------------------------------------------------
   procedure Fiq_Disable
      is
      CPSR_R : Bits_32;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,cpsr    " & CRLF &
                       "        orr     %0,%0,#0x40" & CRLF &
                       "        msr     cpsr_c,%0  " & CRLF &
                       "",
           Outputs  => Bits_32'Asm_Output ("=r", CPSR_R),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Fiq_Disable;

   ----------------------------------------------------------------------------
   -- Irq_State_Get
   ----------------------------------------------------------------------------
   function Irq_State_Get
      return Irq_State_Type
      is
      Irq_State : Irq_State_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        mrs     %0,cpsr" & CRLF &
                       "",
           Outputs  => Irq_State_Type'Asm_Output ("=r", Irq_State),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
      return Irq_State;
   end Irq_State_Get;

   ----------------------------------------------------------------------------
   -- Irq_State_Set
   ----------------------------------------------------------------------------
   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        msr     cpsr_c,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Irq_State_Type'Asm_Input  ("r", Irq_State),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Memory synchronization
   ----------------------------------------------------------------------------
   procedure Memory_Synchronization
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Memory_Synchronization;

end ARMv4;
