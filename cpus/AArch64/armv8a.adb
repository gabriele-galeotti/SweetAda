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
   -- MRS/MSR templates
   ----------------------------------------------------------------------------

   generic
      Register_Name : in String;
      type Register_Type is private;
   function MRS
      return Register_Type
      with Inline => True;

   generic
      Register_Name : in String;
      type Register_Type is private;
   procedure MSR
      (Value : in Register_Type)
      with Inline => True;

   function MRS return
      Register_Type
      is
      Result : Register_Type;
   begin
      Asm (
           Template => ""                                    & CRLF &
                       "        mrs     %0," & Register_Name & CRLF &
                       "",
           Outputs  => Register_Type'Asm_Output ("=r", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MRS;

   procedure MSR
      (Value : in Register_Type)
      is
   begin
      Asm (
           Template => ""                                         & CRLF &
                       "        msr     " & Register_Name & ",%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Register_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end MSR;

   ----------------------------------------------------------------------------
   -- MRS/MSR instantiations
   ----------------------------------------------------------------------------

pragma Style_Checks (Off);

   function CurrentEL_Read return EL_Type is function MRS_Read is new MRS ("currentel", EL_Type); begin return MRS_Read; end CurrentEL_Read;

   function FPCR_Read return FPCR_Type is function MRS_Read is new MRS ("fpcr", FPCR_Type); begin return MRS_Read; end FPCR_Read;
   procedure FPCR_Write (Value : in FPCR_Type) is procedure MSR_Write is new MSR ("fpcr", FPCR_Type); begin MSR_Write (Value); end FPCR_Write;

   function FPSR_Read return FPSR_Type is function MRS_Read is new MRS ("fpsr", FPSR_Type); begin return MRS_Read; end FPSR_Read;
   procedure FPSR_Write (Value : in FPSR_Type) is procedure MSR_Write is new MSR ("fpsr", FPSR_Type); begin MSR_Write (Value); end FPSR_Write;

   function FPEXC32_EL2_Read return FPEXC32_EL2_Type is function MRS_Read is new MRS ("fpexc32_el2", FPEXC32_EL2_Type); begin return MRS_Read; end FPEXC32_EL2_Read;
   procedure FPEXC32_EL2_Write (Value : in FPEXC32_EL2_Type) is procedure MSR_Write is new MSR ("fpexc32_el2", FPEXC32_EL2_Type); begin MSR_Write (Value); end FPEXC32_EL2_Write;

   function HCR_EL2_Read return HCR_EL2_Type is function MRS_Read is new MRS ("hcr_el2", HCR_EL2_Type); begin return MRS_Read; end HCR_EL2_Read;
   procedure HCR_EL2_Write (Value : in HCR_EL2_Type) is procedure MSR_Write is new MSR ("hcr_el2", HCR_EL2_Type); begin MSR_Write (Value); end HCR_EL2_Write;

   function ISR_EL1_Read return ISR_EL1_Type is function MRS_Read is new MRS ("isr_el1", ISR_EL1_Type); begin return MRS_Read; end ISR_EL1_Read;

   function SCR_EL3_Read return SCR_EL3_Type is function MRS_Read is new MRS ("scr_el3", SCR_EL3_Type); begin return MRS_Read; end SCR_EL3_Read;
   procedure SCR_EL3_Write (Value : in SCR_EL3_Type) is procedure MSR_Write is new MSR ("scr_el3", SCR_EL3_Type); begin MSR_Write (Value); end SCR_EL3_Write;

   function SCTLR_EL1_Read return SCTLR_EL1_Type is function MRS_Read is new MRS ("sctlr_el1", SCTLR_EL1_Type); begin return MRS_Read; end SCTLR_EL1_Read;
   procedure SCTLR_EL1_Write (Value : in SCTLR_EL1_Type) is procedure MSR_Write is new MSR ("sctlr_el1", SCTLR_EL1_Type); begin MSR_Write (Value); end SCTLR_EL1_Write;

   function VBAR_EL1_Read return Unsigned_64 is function MRS_Read is new MRS ("vbar_el1", Unsigned_64); begin return MRS_Read; end VBAR_EL1_Read;
   procedure VBAR_EL1_Write (Value : in Unsigned_64) is procedure MSR_Write is new MSR ("vbar_el1", Unsigned_64); begin MSR_Write (Value); end VBAR_EL1_Write;

   function VBAR_EL2_Read return Unsigned_64 is function MRS_Read is new MRS ("vbar_el2", Unsigned_64); begin return MRS_Read; end VBAR_EL2_Read;
   procedure VBAR_EL2_Write (Value : in Unsigned_64) is procedure MSR_Write is new MSR ("vbar_el2", Unsigned_64); begin MSR_Write (Value); end VBAR_EL2_Write;

   function VBAR_EL3_Read return Unsigned_64 is function MRS_Read is new MRS ("vbar_el3", Unsigned_64); begin return MRS_Read; end VBAR_EL3_Read;
   procedure VBAR_EL3_Write (Value : in Unsigned_64) is procedure MSR_Write is new MSR ("vbar_el3", Unsigned_64); begin MSR_Write (Value); end VBAR_EL3_Write;

   function CNTFRQ_EL0_Read return CNTFRQ_EL0_Type is function MRS_Read is new MRS ("cntfrq_el0", CNTFRQ_EL0_Type); begin return MRS_Read; end CNTFRQ_EL0_Read;

   function CNTP_CTL_EL0_Read return CNTP_CTL_EL0_Type is function MRS_Read is new MRS ("cntp_ctl_el0", CNTP_CTL_EL0_Type); begin return MRS_Read; end CNTP_CTL_EL0_Read;
   procedure CNTP_CTL_EL0_Write (Value : CNTP_CTL_EL0_Type) is procedure MSR_Write is new MSR ("cntp_ctl_el0", CNTP_CTL_EL0_Type); begin MSR_Write (Value); end CNTP_CTL_EL0_Write;

   function CNTP_CVAL_EL0_Read return Unsigned_64 is function MRS_Read is new MRS ("cntp_cval_el0", Unsigned_64); begin return MRS_Read; end CNTP_CVAL_EL0_Read;
   procedure CNTP_CVAL_EL0_Write (Value : Unsigned_64) is procedure MSR_Write is new MSR ("cntp_cval_el0", Unsigned_64); begin MSR_Write (Value); end CNTP_CVAL_EL0_Write;

   function CNTP_TVAL_EL0_Read return CNTP_TVAL_EL0_Type is function MRS_Read is new MRS ("cntp_tval_el0", CNTP_TVAL_EL0_Type); begin return MRS_Read; end CNTP_TVAL_EL0_Read;
   procedure CNTP_TVAL_EL0_Write (Value : CNTP_TVAL_EL0_Type) is procedure MSR_Write is new MSR ("cntp_tval_el0", CNTP_TVAL_EL0_Type); begin MSR_Write (Value); end CNTP_TVAL_EL0_Write;

   function CNTPCT_EL0_Read return Unsigned_64 is function MRS_Read is new MRS ("cntfrq_el0", Unsigned_64); begin return MRS_Read; end CNTPCT_EL0_Read;

pragma Style_Checks (On);

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
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
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
   procedure Irq_Enable
      is
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
   procedure Irq_Disable
      is
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
