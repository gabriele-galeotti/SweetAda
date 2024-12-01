-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv8a.adb                                                                                                --
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
with Ada.Unchecked_Conversion;
with Definitions;

package body ARMv8A
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
   -- Memory Attribute functions
   ----------------------------------------------------------------------------

   function Device_Memory_Attribute
      (Device : Device_Attribute_Type;
       XS     : Boolean)
      return Memory_Attribute_Type
      is
      type MA_Device_Type is record
         XS   : Bits_2;
         dd   : Bits_2;
         Zero : Bits_4;
      end record
         with Bit_Order => Low_Order_First,
              Size      => 8;
      for MA_Device_Type use record
         XS   at 0 range 0 .. 1;
         dd   at 0 range 2 .. 3;
         Zero at 0 range 4 .. 7;
      end record;
      function To_MAT is new Ada.Unchecked_Conversion (MA_Device_Type, Memory_Attribute_Type);
      MA_Device : MA_Device_Type;
   begin
      MA_Device.XS := (if XS then 2#01# else 2#00#);
      case Device is
         when DEVICE_nGnRnE => MA_Device.dd := 2#00#;
         when DEVICE_nGnRE  => MA_Device.dd := 2#01#;
         when DEVICE_nGRE   => MA_Device.dd := 2#10#;
         when DEVICE_GRE    => MA_Device.dd := 2#11#;
      end case;
      MA_Device.Zero := 0;
      return To_MAT (MA_Device);
   end Device_Memory_Attribute;

   function Normal_Memory_Attribute
      (Attribute      : Normal_Memory_Attribute_Type;
       Inner_Policy   : Normal_Memory_Policy_Type;
       Inner_R_Policy : Bits_1;
       Inner_W_Policy : Bits_1;
       Outer_Policy   : Normal_Memory_Policy_Type;
       Outer_R_Policy : Bits_1;
       Outer_W_Policy : Bits_1)
      return Memory_Attribute_Type
      is
      type MA_Memory_Type is record
         Inner_W : Bits_1;
         Inner_R : Bits_1;
         Inner   : Bits_2;
         Outer_W : Bits_1;
         Outer_R : Bits_1;
         Outer   : Bits_2;
      end record
         with Bit_Order => Low_Order_First,
              Size      => 8;
      for MA_Memory_Type use record
         Inner_W at 0 range 0 .. 0;
         Inner_R at 0 range 1 .. 1;
         Inner   at 0 range 2 .. 3;
         Outer_W at 0 range 4 .. 4;
         Outer_R at 0 range 5 .. 5;
         Outer   at 0 range 6 .. 7;
      end record;
      MA_Memory : MA_Memory_Type;
      function To_Bits
         (P : Normal_Memory_Policy_Type)
         return Bits_2;
      function To_Bits
         (P : Normal_Memory_Policy_Type)
         return Bits_2
         is
         B : Bits_2;
      begin
         case P is
            when WTT  => B := 2#00#;
            when nC   => B := 2#01#;
            when WBT  => B := 2#01#;
            when WTnT => B := 2#10#;
            when WBnT => B := 2#11#;
         end case;
         return B;
      end To_Bits;
      function To_MAT is new Ada.Unchecked_Conversion (MA_Memory_Type, Memory_Attribute_Type);
   begin
      case Attribute is
         when NORMAL_XS_InCOnC          => MA_Memory := (0, 0, 2#00#, 0, 0, 2#01#);
         when NORMAL_XS_IWTCOWTCRAnWAnT => MA_Memory := (0, 0, 2#00#, 0, 1, 2#10#);
         when NORMAL_MTE2_TIWBOWBRAWAnT => MA_Memory := (0, 0, 2#00#, 1, 1, 2#11#);
         when NORMAL                    =>
            if (Inner_Policy = WTT or else Inner_Policy = WBT) and then
               Inner_W_Policy = NoAllocate                     and then
               Inner_R_Policy = NoAllocate
            then
               raise Constraint_Error;
            end if;
            if (Outer_Policy = WTT or else Outer_Policy = WBT) and then
               Outer_W_Policy = NoAllocate                     and then
               Outer_R_Policy = NoAllocate
            then
               raise Constraint_Error;
            end if;
            MA_Memory := (
               Inner_W_Policy, Inner_R_Policy, To_Bits (Inner_Policy),
               Outer_W_Policy, Outer_R_Policy, To_Bits (Outer_Policy)
               );
      end case;
      return To_MAT (MA_Memory);
   end Normal_Memory_Attribute;

   ----------------------------------------------------------------------------
   -- MRS/MSR instantiations
   ----------------------------------------------------------------------------

pragma Style_Checks (Off);

   function CurrentEL_Read return EL_Type is function MRS_Read is new MRS ("currentel", EL_Type); begin return MRS_Read; end CurrentEL_Read;

   function FPCR_Read return FPCR_Type is function MRS_Read is new MRS ("fpcr", FPCR_Type); begin return MRS_Read; end FPCR_Read;
   procedure FPCR_Write (Value : in FPCR_Type) is procedure MSR_Write is new MSR ("fpcr", FPCR_Type); begin MSR_Write (Value); end FPCR_Write;

   function FPSR_Read return FPSR_Type is function MRS_Read is new MRS ("fpsr", FPSR_Type); begin return MRS_Read; end FPSR_Read;
   procedure FPSR_Write (Value : in FPSR_Type) is procedure MSR_Write is new MSR ("fpsr", FPSR_Type); begin MSR_Write (Value); end FPSR_Write;

   function FAR_EL1_Read return Unsigned_64 is function MRS_Read is new MRS ("far_el1", Unsigned_64); begin return MRS_Read; end FAR_EL1_Read;
   function FAR_EL2_Read return Unsigned_64 is function MRS_Read is new MRS ("far_el2", Unsigned_64); begin return MRS_Read; end FAR_EL2_Read;
   function FAR_EL3_Read return Unsigned_64 is function MRS_Read is new MRS ("far_el3", Unsigned_64); begin return MRS_Read; end FAR_EL3_Read;

   function FPEXC32_EL2_Read return FPEXC32_EL2_Type is function MRS_Read is new MRS ("fpexc32_el2", FPEXC32_EL2_Type); begin return MRS_Read; end FPEXC32_EL2_Read;
   procedure FPEXC32_EL2_Write (Value : in FPEXC32_EL2_Type) is procedure MSR_Write is new MSR ("fpexc32_el2", FPEXC32_EL2_Type); begin MSR_Write (Value); end FPEXC32_EL2_Write;

   function HCR_EL2_Read return HCR_EL2_Type is function MRS_Read is new MRS ("hcr_el2", HCR_EL2_Type); begin return MRS_Read; end HCR_EL2_Read;
   procedure HCR_EL2_Write (Value : in HCR_EL2_Type) is procedure MSR_Write is new MSR ("hcr_el2", HCR_EL2_Type); begin MSR_Write (Value); end HCR_EL2_Write;

   function ID_AA64ISAR0_EL1_Read return ID_AA64ISAR0_EL1_Type is function MRS_Read is new MRS ("id_aa64isar0_el1", ID_AA64ISAR0_EL1_Type); begin return MRS_Read; end ID_AA64ISAR0_EL1_Read;
   function ID_AA64ISAR1_EL1_Read return ID_AA64ISAR1_EL1_Type is function MRS_Read is new MRS ("id_aa64isar1_el1", ID_AA64ISAR1_EL1_Type); begin return MRS_Read; end ID_AA64ISAR1_EL1_Read;
   function ID_AA64ISAR2_EL1_Read return ID_AA64ISAR2_EL1_Type is function MRS_Read is new MRS ("id_aa64isar2_el1", ID_AA64ISAR2_EL1_Type); begin return MRS_Read; end ID_AA64ISAR2_EL1_Read;

   function ISR_EL1_Read return ISR_EL1_Type is function MRS_Read is new MRS ("isr_el1", ISR_EL1_Type); begin return MRS_Read; end ISR_EL1_Read;

   function MAIR_EL1_Read return MAIR_ELx_Type is function MRS_Read is new MRS ("mair_el1", MAIR_ELx_Type); begin return MRS_Read; end MAIR_EL1_Read;
   procedure MAIR_EL1_Write (Value : in MAIR_ELx_Type) is procedure MSR_Write is new MSR ("mair_el1", MAIR_ELx_Type); begin MSR_Write (Value); end MAIR_EL1_Write;
   function MAIR_EL2_Read return MAIR_ELx_Type is function MRS_Read is new MRS ("mair_el2", MAIR_ELx_Type); begin return MRS_Read; end MAIR_EL2_Read;
   procedure MAIR_EL2_Write (Value : in MAIR_ELx_Type) is procedure MSR_Write is new MSR ("mair_el2", MAIR_ELx_Type); begin MSR_Write (Value); end MAIR_EL2_Write;
   function MAIR_EL3_Read return MAIR_ELx_Type is function MRS_Read is new MRS ("mair_el3", MAIR_ELx_Type); begin return MRS_Read; end MAIR_EL3_Read;
   procedure MAIR_EL3_Write (Value : in MAIR_ELx_Type) is procedure MSR_Write is new MSR ("mair_el3", MAIR_ELx_Type); begin MSR_Write (Value); end MAIR_EL3_Write;

   function MPIDR_EL1_Read return MPIDR_EL1_Type is function MRS_Read is new MRS ("mpidr_el1", MPIDR_EL1_Type); begin return MRS_Read; end MPIDR_EL1_Read;

   function SCR_EL3_Read return SCR_EL3_Type is function MRS_Read is new MRS ("scr_el3", SCR_EL3_Type); begin return MRS_Read; end SCR_EL3_Read;
   procedure SCR_EL3_Write (Value : in SCR_EL3_Type) is procedure MSR_Write is new MSR ("scr_el3", SCR_EL3_Type); begin MSR_Write (Value); end SCR_EL3_Write;

   function SCTLR_EL1_Read return SCTLR_EL1_Type is function MRS_Read is new MRS ("sctlr_el1", SCTLR_EL1_Type); begin return MRS_Read; end SCTLR_EL1_Read;
   procedure SCTLR_EL1_Write (Value : in SCTLR_EL1_Type) is procedure MSR_Write is new MSR ("sctlr_el1", SCTLR_EL1_Type); begin MSR_Write (Value); end SCTLR_EL1_Write;

   -- function TCR2_EL1_Read return TCR2_EL1_Type is function MRS_Read is new MRS ("tcr2_el1", TCR2_EL1_Type); begin return MRS_Read; end TCR2_EL1_Read;
   -- procedure TCR2_EL1_Write (Value : in TCR2_EL1_Type) is procedure MSR_Write is new MSR ("tcr2_el1", TCR2_EL1_Type); begin MSR_Write (Value); end TCR2_EL1_Write;

   -- function TCR2_EL2_Read return TCR2_EL2_Type is function MRS_Read is new MRS ("tcr2_el2", TCR2_EL2_Type); begin return MRS_Read; end TCR2_EL2_Read;
   -- procedure TCR2_EL2_Write (Value : in TCR2_EL2_Type) is procedure MSR_Write is new MSR ("tcr2_el2", TCR2_EL2_Type); begin MSR_Write (Value); end TCR2_EL2_Write;

   function TCR_EL1_Read return TCR_EL1_Type is function MRS_Read is new MRS ("tcr_el1", TCR_EL1_Type); begin return MRS_Read; end TCR_EL1_Read;
   procedure TCR_EL1_Write (Value : in TCR_EL1_Type) is procedure MSR_Write is new MSR ("tcr_el1", TCR_EL1_Type); begin MSR_Write (Value); end TCR_EL1_Write;

   function TTBR0_EL1_Read return TTBR0_EL1_Type is function MRS_Read is new MRS ("ttbr0_el1", TTBR0_EL1_Type); begin return MRS_Read; end TTBR0_EL1_Read;
   procedure TTBR0_EL1_Write (Value : in TTBR0_EL1_Type) is procedure MSR_Write is new MSR ("ttbr0_el1", TTBR0_EL1_Type); begin MSR_Write (Value); end TTBR0_EL1_Write;

   function TTBR0_EL2_Read return TTBR0_EL2_Type is function MRS_Read is new MRS ("ttbr0_el2", TTBR0_EL2_Type); begin return MRS_Read; end TTBR0_EL2_Read;
   procedure TTBR0_EL2_Write (Value : in TTBR0_EL2_Type) is procedure MSR_Write is new MSR ("ttbr0_el2", TTBR0_EL2_Type); begin MSR_Write (Value); end TTBR0_EL2_Write;

   function TTBR0_EL3_Read return TTBR0_EL3_Type is function MRS_Read is new MRS ("ttbr0_el3", TTBR0_EL3_Type); begin return MRS_Read; end TTBR0_EL3_Read;
   procedure TTBR0_EL3_Write (Value : in TTBR0_EL3_Type) is procedure MSR_Write is new MSR ("ttbr0_el3", TTBR0_EL3_Type); begin MSR_Write (Value); end TTBR0_EL3_Write;

   function TTBR1_EL1_Read return TTBR1_EL1_Type is function MRS_Read is new MRS ("ttbr1_el1", TTBR1_EL1_Type); begin return MRS_Read; end TTBR1_EL1_Read;
   procedure TTBR1_EL1_Write (Value : in TTBR1_EL1_Type) is procedure MSR_Write is new MSR ("ttbr1_el1", TTBR1_EL1_Type); begin MSR_Write (Value); end TTBR1_EL1_Write;

   -- function TTBR1_EL2_Read return TTBR1_EL2_Type is function MRS_Read is new MRS ("ttbr1_el2", TTBR1_EL2_Type); begin return MRS_Read; end TTBR1_EL2_Read;
   -- procedure TTBR1_EL2_Write (Value : in TTBR1_EL2_Type) is procedure MSR_Write is new MSR ("ttbr1_el2", TTBR1_EL2_Type); begin MSR_Write (Value); end TTBR1_EL2_Write;

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
