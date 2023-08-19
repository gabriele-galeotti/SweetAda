-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv8a.adb                                                                                                --
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

package body ARMv8A is

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
   -- CurrentEL_Read
   ----------------------------------------------------------------------------
   function CurrentEL_Read return EL_Type is
      Value : EL_Type;
   begin
      Asm (
           Template => ""                             & CRLF &
                       "        mrs     %0,currentel" & CRLF &
                       "",
           Outputs  => EL_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CurrentEL_Read;

   ----------------------------------------------------------------------------
   -- FPCR_Read/Write
   ----------------------------------------------------------------------------

   function FPCR_Read return FPCR_Type is
      Value : FPCR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        mrs     %0,fpcr" & CRLF &
                       "",
           Outputs  => FPCR_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end FPCR_Read;

   procedure FPCR_Write (Value : in FPCR_Type) is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        msr     fpcr,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => FPCR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end FPCR_Write;

   ----------------------------------------------------------------------------
   -- FPSR_Read/Write
   ----------------------------------------------------------------------------

   function FPSR_Read return FPSR_Type is
      Value : FPSR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        mrs     %0,fpsr" & CRLF &
                       "",
           Outputs  => FPSR_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end FPSR_Read;

   procedure FPSR_Write (Value : in FPSR_Type) is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        msr     fpsr,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => FPSR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end FPSR_Write;

   ----------------------------------------------------------------------------
   -- FPEXC32_EL2_Read/Write
   ----------------------------------------------------------------------------

   function FPEXC32_EL2_Read return FPEXC32_EL2_Type is
      Value : FPEXC32_EL2_Type;
   begin
      Asm (
           Template => ""                               & CRLF &
                       "        mrs     %0,fpexc32_el2" & CRLF &
                       "",
           Outputs  => FPEXC32_EL2_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end FPEXC32_EL2_Read;

   procedure FPEXC32_EL2_Write (Value : in FPEXC32_EL2_Type) is
   begin
      Asm (
           Template => ""                               & CRLF &
                       "        msr     fpexc32_el2,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => FPEXC32_EL2_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end FPEXC32_EL2_Write;

   ----------------------------------------------------------------------------
   -- HCR_EL2_Read/Write
   ----------------------------------------------------------------------------

   function HCR_EL2_Read return HCR_EL2_Type is
      Value : HCR_EL2_Type;
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        mrs     %0,hcr_el2" & CRLF &
                       "",
           Outputs  => HCR_EL2_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end HCR_EL2_Read;

   procedure HCR_EL2_Write (Value : in HCR_EL2_Type) is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        msr     hcr_el2,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => HCR_EL2_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end HCR_EL2_Write;

   ----------------------------------------------------------------------------
   -- SCTLR_EL1_Read/Write
   ----------------------------------------------------------------------------

   function SCTLR_EL1_Read return SCTLR_EL1_Type is
      Value : SCTLR_EL1_Type;
   begin
      Asm (
           Template => ""                             & CRLF &
                       "        mrs     %0,sctlr_el1" & CRLF &
                       "",
           Outputs  => SCTLR_EL1_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end SCTLR_EL1_Read;

   procedure SCTLR_EL1_Write (Value : in SCTLR_EL1_Type) is
   begin
      Asm (
           Template => ""                             & CRLF &
                       "        msr     sctlr_el1,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => SCTLR_EL1_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end SCTLR_EL1_Write;

   ----------------------------------------------------------------------------
   -- VBAR_ELx_Read/Write
   ----------------------------------------------------------------------------

   function VBAR_EL1_Read return Unsigned_64 is
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,vbar_el1" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end VBAR_EL1_Read;

   procedure VBAR_EL1_Write (Value : in Unsigned_64) is
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        msr     vbar_el1,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_64'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end VBAR_EL1_Write;

   function VBAR_EL2_Read return Unsigned_64 is
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,vbar_el2" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end VBAR_EL2_Read;

   procedure VBAR_EL2_Write (Value : in Unsigned_64) is
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        msr     vbar_el2,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_64'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end VBAR_EL2_Write;

   function VBAR_EL3_Read return Unsigned_64 is
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        mrs     %0,vbar_el3" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end VBAR_EL3_Read;

   procedure VBAR_EL3_Write (Value : in Unsigned_64) is
   begin
      Asm (
           Template => ""                            & CRLF &
                       "        msr     vbar_el3,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_64'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end VBAR_EL3_Write;

   ----------------------------------------------------------------------------
   -- CNTFRQ_EL0_Read
   ----------------------------------------------------------------------------

   function CNTFRQ_EL0_Read return CNTFRQ_EL0_Type is
      Value : CNTFRQ_EL0_Type;
   begin
      Asm (
           Template => ""                              & CRLF &
                       "        mrs     %0,cntfrq_el0" & CRLF &
                       "",
           Outputs  => CNTFRQ_EL0_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CNTFRQ_EL0_Read;

   ----------------------------------------------------------------------------
   -- CNTP_CTL_EL0_Read/Write
   ----------------------------------------------------------------------------

   function CNTP_CTL_EL0_Read return CNTP_CTL_EL0_Type is
      Value : CNTP_CTL_EL0_Type;
   begin
      Asm (
           Template => ""                                & CRLF &
                       "        mrs     %0,cntp_ctl_el0" & CRLF &
                       "",
           Outputs  => CNTP_CTL_EL0_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CNTP_CTL_EL0_Read;

   procedure CNTP_CTL_EL0_Write (Value : in CNTP_CTL_EL0_Type) is
   begin
      Asm (
           Template => ""                                & CRLF &
                       "        msr     cntp_ctl_el0,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CNTP_CTL_EL0_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end CNTP_CTL_EL0_Write;

   ----------------------------------------------------------------------------
   -- CNTP_CVAL_EL0_Read/Write
   ----------------------------------------------------------------------------

   function CNTP_CVAL_EL0_Read return Unsigned_64 is
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        mrs     %0,cntp_cval_el0" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CNTP_CVAL_EL0_Read;

   procedure CNTP_CVAL_EL0_Write (Value : in Unsigned_64) is
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        msr     cntp_cval_el0,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_64'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end CNTP_CVAL_EL0_Write;

   ----------------------------------------------------------------------------
   -- CNTP_TVAL_EL0_Read/Write
   ----------------------------------------------------------------------------

   function CNTP_TVAL_EL0_Read return CNTP_TVAL_EL0_Type is
      Value : CNTP_TVAL_EL0_Type;
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        mrs     %0,cntp_tval_el0" & CRLF &
                       "",
           Outputs  => CNTP_TVAL_EL0_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CNTP_TVAL_EL0_Read;

   procedure CNTP_TVAL_EL0_Write (Value : in CNTP_TVAL_EL0_Type) is
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        msr     cntp_tval_el0,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CNTP_TVAL_EL0_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end CNTP_TVAL_EL0_Write;

   ----------------------------------------------------------------------------
   -- CNTPCT_EL0_Read
   ----------------------------------------------------------------------------

   function CNTPCT_EL0_Read return Unsigned_64 is
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                              & CRLF &
                       "        mrs     %0,cntpct_el0" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end CNTPCT_EL0_Read;

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
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        blr     %0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("r", Target_Address),
           Clobber  => "x30",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        msr     daifclr,#2" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        msr     daifset,#2" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Irq_Disable;

end ARMv8A;
