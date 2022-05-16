-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ aarch64.adb                                                                                               --
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
with Definitions;

package body AArch64 is

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
   -- VBAR_EL1_Read/Write
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

end AArch64;
