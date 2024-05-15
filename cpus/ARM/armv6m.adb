-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv6m.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with Definitions;

package body ARMv6M
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

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- MSP/PSP_Read/Write
   ----------------------------------------------------------------------------

   function MSP_Read
      return Unsigned_32
      is
      Value : Unsigned_32;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        mrs     %0,msp" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end MSP_Read;

   procedure MSP_Write
      (Value : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        msr     msp,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_32'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end MSP_Write;

   function PSP_Read
      return Unsigned_32
      is
      Value : Unsigned_32;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        mrs     %0,psp" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end PSP_Read;

   procedure PSP_Write
      (Value : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        msr     psp,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_32'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end PSP_Write;

   ----------------------------------------------------------------------------
   -- APSR_Read/Write
   ----------------------------------------------------------------------------

   function APSR_Read
      return APSR_Type
      is
      Value : APSR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        mrs     %0,apsr" & CRLF &
                       "",
           Outputs  => APSR_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end APSR_Read;

   procedure APSR_Write
      (Value : in APSR_Type)
      is
   begin
      Asm (
           Template => ""                              & CRLF &
                       "        msr     apsr_nzcvq,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => APSR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end APSR_Write;

   ----------------------------------------------------------------------------
   -- IPSR_Read/Write
   ----------------------------------------------------------------------------

   function IPSR_Read
      return IPSR_Type
      is
      Value : IPSR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        mrs     %0,ipsr" & CRLF &
                       "",
           Outputs  => IPSR_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end IPSR_Read;

   procedure IPSR_Write
      (Value : in IPSR_Type)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        msr     ipsr,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => IPSR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end IPSR_Write;

   ----------------------------------------------------------------------------
   -- EPSR_Read/Write
   ----------------------------------------------------------------------------

   function EPSR_Read
      return EPSR_Type
      is
      Value : EPSR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        mrs     %0,epsr" & CRLF &
                       "",
           Outputs  => EPSR_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end EPSR_Read;

   procedure EPSR_Write
      (Value : in EPSR_Type)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        msr     epsr,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => EPSR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end EPSR_Write;

   ----------------------------------------------------------------------------
   -- PRIMASK_Read/Write
   ----------------------------------------------------------------------------

   function PRIMASK_Read
      return PRIMASK_Type
      is
      Value : PRIMASK_Type;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        mrs     %0,primask" & CRLF &
                       "",
           Outputs  => PRIMASK_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end PRIMASK_Read;

   procedure PRIMASK_Write
      (Value : in PRIMASK_Type)
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        msr     primask,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => PRIMASK_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end PRIMASK_Write;

   ----------------------------------------------------------------------------
   -- CONTROL_Read/Write
   ----------------------------------------------------------------------------

   function CONTROL_Read
      return CONTROL_Type
      is
      Value : CONTROL_Type;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        mrs     %0,control" & CRLF &
                       "",
           Outputs  => CONTROL_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CONTROL_Read;

   procedure CONTROL_Write
      (Value : in CONTROL_Type)
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        msr     control,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CONTROL_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end CONTROL_Write;

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
           Template => ""             & CRLF &
                       "        bkpt" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- WFI
   ----------------------------------------------------------------------------
   procedure WFI
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        wfi" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end WFI;

   ----------------------------------------------------------------------------
   -- DMB
   ----------------------------------------------------------------------------
   procedure DMB
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        dmb" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end DMB;

   ----------------------------------------------------------------------------
   -- DSB
   ----------------------------------------------------------------------------
   procedure DSB
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        dsb" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end DSB;

   ----------------------------------------------------------------------------
   -- ISB
   ----------------------------------------------------------------------------
   procedure ISB
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        isb" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end ISB;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsie   i" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
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
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsid   i" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   ----------------------------------------------------------------------------
   -- Fault_Irq_Enable
   ----------------------------------------------------------------------------
   procedure Fault_Irq_Enable
      is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsie   f" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Fault_Irq_Enable;

   ----------------------------------------------------------------------------
   -- Fault_Irq_Disable
   ----------------------------------------------------------------------------
   procedure Fault_Irq_Disable
      is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        cpsid   f" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Fault_Irq_Disable;

end ARMv6M;
