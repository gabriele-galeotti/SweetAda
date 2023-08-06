-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.adb                                                                                                 --
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
with Configure;
with Definitions;

package body RISCV is

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
   -- mtvec_Write
   ----------------------------------------------------------------------------
   procedure mtvec_Write
      (mtvec : in mtvec_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       ZICSR_ZIFENCEI_ASM         & CRLF &
                       "        csrw    mtvec,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mtvec_Type'Asm_Input ("r", mtvec),
           Clobber  => "",
           Volatile => True
          );
   end mtvec_Write;

   ----------------------------------------------------------------------------
   -- mepc_Read
   ----------------------------------------------------------------------------
   function mepc_Read
      return MXLEN_Type
      is
      mepc : MXLEN_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       ZICSR_ZIFENCEI_ASM        & CRLF &
                       "        csrr    %0,mepc" & CRLF &
                       "",
           Outputs  => MXLEN_Type'Asm_Output ("=r", mepc),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return mepc;
   end mepc_Read;

   ----------------------------------------------------------------------------
   -- mcause_Read
   ----------------------------------------------------------------------------
   function mcause_Read
      return mcause_Type
      is
      mcause : mcause_Type;
   begin
      Asm (
           Template => ""                          & CRLF &
                       ZICSR_ZIFENCEI_ASM          & CRLF &
                       "        csrr    %0,mcause" & CRLF &
                       "",
           Outputs  => mcause_Type'Asm_Output ("=r", mcause),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return mcause;
   end mcause_Read;

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
           Template => ""                        & CRLF &
                       "        jalr    x1,%0,0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   mstatus_USMIE : constant mstatus_Type := (
                                             UIE    => False,
                                             SIE    => False,
                                             MIE    => True,
                                             UPIE   => False,
                                             SPIE   => False,
                                             MPIE   => False,
                                             SPP    => False,
                                             MPP    => 0,
                                             FS     => 0,
                                             XS     => 0,
                                             MPRIV  => False,
                                             SUM    => False,
                                             MXR    => False,
                                             TVM    => False,
                                             TW     => False,
                                             TSR    => False,
                                             SD     => False,
                                             others => <>
                                            );

   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""                              & CRLF &
                       ZICSR_ZIFENCEI_ASM              & CRLF &
                       "        csrrs   x0,mstatus,%0" & CRLF &
                       "        csrrs   x0,mie,%1    " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        mstatus_Type'Asm_Input ("r", mstatus_USMIE),
                        MXLEN_Type'Asm_Input ("r", 16#80#)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable
      is
   begin
      Asm (
           Template => ""                              & CRLF &
                       ZICSR_ZIFENCEI_ASM              & CRLF &
                       "        csrrc   x0,mstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => mstatus_Type'Asm_Input ("r", mstatus_USMIE),
           Clobber  => "",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get
      return Irq_State_Type
      is
   begin
      return 0; -- __TBD__
   end Irq_State_Get;

   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      is
   begin
      null; -- __TBD__
   end Irq_State_Set;

end RISCV;
