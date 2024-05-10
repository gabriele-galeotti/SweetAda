-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.adb                                                                                                 --
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

package body RISCV
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Definitions;

   ZICSR_ZIFENCEI_ASM : constant String := "        .option arch,+zicsr,+zifencei";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CSRs generics
   ----------------------------------------------------------------------------

   generic
      CSR : in String;
      type Register_Type is private;
   function CSR_Read
      return Register_Type
      with Inline => True;

   function CSR_Read
      return Register_Type
      is
      Result : Register_Type;
   begin
      Asm (
           Template => ""                          & CRLF &
                       ZICSR_ZIFENCEI_ASM          & CRLF &
                       "        csrr    %0," & CSR & CRLF &
                       "",
           Outputs  => Register_Type'Asm_Output ("=r", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
      return Result;
   end CSR_Read;

   generic
      CSR : in String;
      type Register_Type is private;
   procedure CSR_Write
      (Value : in Register_Type)
      with Inline => True;

   procedure CSR_Write
      (Value : in Register_Type)
      is
   begin
      Asm (
           Template => ""                               & CRLF &
                       ZICSR_ZIFENCEI_ASM               & CRLF &
                       "        csrw    " & CSR & ",%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Register_Type'Asm_Input ("r", Value),
           Clobber  => "memory",
           Volatile => True
          );
   end CSR_Write;

   generic
      CSR : in String;
      type Register_Type is private;
   procedure CSR_Set
      (Value : in Register_Type)
      with Inline => True;

   procedure CSR_Set
      (Value : in Register_Type)
      is
   begin
      Asm (
           Template => ""                               & CRLF &
                       ZICSR_ZIFENCEI_ASM               & CRLF &
                       "        csrs    " & CSR & ",%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Register_Type'Asm_Input ("r", Value),
           Clobber  => "memory",
           Volatile => True
          );
   end CSR_Set;

pragma Style_Checks (Off);

   function mhartid_Read return MXLEN_Type
      is function CSRR is new CSR_Read ("mhartid", MXLEN_Type); begin return CSRR; end mhartid_Read;

   function mstatus_Read return mstatus_Type
      is function CSRR is new CSR_Read ("mstatus", mstatus_Type); begin return CSRR; end mstatus_Read;

   procedure mstatus_Write (mstatus : in mstatus_Type)
      is procedure CSRW is new CSR_Write ("mstatus", mstatus_Type); begin CSRW (mstatus); end mstatus_Write;

   procedure mstatus_Set (mstatus : in mstatus_Type)
      is procedure CSRS is new CSR_Set ("mstatus", mstatus_Type); begin CSRS (mstatus); end mstatus_Set;

   procedure mtvec_Write (mtvec : in mtvec_Type)
      is procedure CSRW is new CSR_Write ("mtvec", mtvec_Type); begin CSRW (mtvec); end mtvec_Write;

   function mepc_Read return MXLEN_Type
      is function CSRR is new CSR_Read ("mepc", MXLEN_Type); begin return CSRR; end mepc_Read;

   function mcause_Read return mcause_Type
      is function CSRR is new CSR_Read ("mcause", mcause_Type); begin return CSRR; end mcause_Read;

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
   -- FENCE
   ----------------------------------------------------------------------------
   procedure FENCE
      is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        fence" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end FENCE;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        jalr    x1,%0,0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "x1",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Intcontext := mstatus_Read.MIE;
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
      function To_mstatus is new Ada.Unchecked_Conversion (MXLEN_Type, mstatus_Type);
      mstatus : mstatus_Type := To_mstatus (0);
   begin
      mstatus.MIE := Intcontext;
      mstatus_Set (mstatus);
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- mie_Set_Interrupt
   ----------------------------------------------------------------------------
   procedure mie_Set_Interrupt
      (mie : in mie_Type)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       ZICSR_ZIFENCEI_ASM          & CRLF &
                       "        csrrs   x0,mie,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mie_Type'Asm_Input ("r", mie),
           Clobber  => "memory",
           Volatile => True
          );
   end mie_Set_Interrupt;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
      function To_mstatus is new Ada.Unchecked_Conversion (MXLEN_Type, mstatus_Type);
      mstatus : mstatus_Type := To_mstatus (0);
   begin
      mstatus.MIE := True;
      Asm (
           Template => ""                              & CRLF &
                       ZICSR_ZIFENCEI_ASM              & CRLF &
                       "        csrrs   x0,mstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mstatus_Type'Asm_Input ("r", mstatus),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
      function To_mstatus is new Ada.Unchecked_Conversion (MXLEN_Type, mstatus_Type);
      mstatus : mstatus_Type := To_mstatus (0);
   begin
      mstatus.MIE := True;
      Asm (
           Template => ""                              & CRLF &
                       ZICSR_ZIFENCEI_ASM              & CRLF &
                       "        csrrc   x0,mstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mstatus_Type'Asm_Input ("r", mstatus),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

end RISCV;
