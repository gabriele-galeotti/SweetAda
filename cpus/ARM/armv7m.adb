-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7m.adb                                                                                                --
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
with Definitions;

package body ARMv7M
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
   -- BASEPRI_Read/Write
   ----------------------------------------------------------------------------

   function BASEPRI_Read
      return BASEPRI_Type
      is
      Value : BASEPRI_Type;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        mrs     %0,basepri" & CRLF &
                       "",
           Outputs  => BASEPRI_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end BASEPRI_Read;

   procedure BASEPRI_Write
      (Value : in BASEPRI_Type)
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        msr     basepri,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => BASEPRI_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end BASEPRI_Write;

   ----------------------------------------------------------------------------
   -- FAULTMASK_Read/Write
   ----------------------------------------------------------------------------

   function FAULTMASK_Read
      return FAULTMASK_Type
      is
      Value : FAULTMASK_Type;
   begin
      Asm (
           Template => ""                             & CRLF &
                       "        mrs     %0,faultmask" & CRLF &
                       "",
           Outputs  => FAULTMASK_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end FAULTMASK_Read;

   procedure FAULTMASK_Write
      (Value : in FAULTMASK_Type)
      is
   begin
      Asm (
           Template => ""                             & CRLF &
                       "        msr     faultmask,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => FAULTMASK_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end FAULTMASK_Write;

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
   -- NVIC CMSIS-like subprograms
   ----------------------------------------------------------------------------

pragma Style_Checks (Off);

   procedure NVIC_EnableIRQ (IRQ : in Natural) is begin NVIC_ISER (IRQ / 32)(IRQ mod 32) := True; end NVIC_EnableIRQ;
   procedure NVIC_DisableIRQ (IRQ : in Natural) is begin NVIC_ICER (IRQ / 32)(IRQ mod 32) := True; end NVIC_DisableIRQ;
   function NVIC_GetEnableIRQ (IRQ : Natural) return Boolean is begin return NVIC_ISER (IRQ / 32)(IRQ mod 32); end NVIC_GetEnableIRQ;

   function NVIC_GetPriority (IRQ : Natural) return Unsigned_8 is begin return NVIC_IPR (IRQ / 4)(IRQ mod 4); end NVIC_GetPriority;
   procedure NVIC_SetPriority (IRQ : in Natural; Priority : in Unsigned_8) is begin NVIC_IPR (IRQ / 4)(IRQ mod 4) := Priority; end NVIC_SetPriority;

   function NVIC_GetPendingIRQ (IRQ : Natural) return Boolean is begin return NVIC_ISPR (IRQ / 32)(IRQ mod 32); end NVIC_GetPendingIRQ;
   procedure NVIC_SetPendingIRQ (IRQ : in Natural) is begin NVIC_ISPR (IRQ / 32)(IRQ mod 32) := True; end NVIC_SetPendingIRQ;
   procedure NVIC_ClearPendingIRQ (IRQ : in Natural) is begin NVIC_ICPR (IRQ / 32)(IRQ mod 32) := True; end NVIC_ClearPendingIRQ;

pragma Style_Checks (On);

end ARMv7M;
