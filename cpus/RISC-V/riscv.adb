-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.adb                                                                                                 --
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

package body RISCV is

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
   -- MCAUSE_Read
   ----------------------------------------------------------------------------
   function MCAUSE_Read return Unsigned_32 is
      MCAUSE : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        csrr    %0,mcause" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", MCAUSE),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return MCAUSE;
   end MCAUSE_Read;

   ----------------------------------------------------------------------------
   -- MEPC_Read
   ----------------------------------------------------------------------------
   function MEPC_Read return Unsigned_32 is
      MEPC : Unsigned_32;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        csrr    %0,mepc" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", MEPC),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return MEPC;
   end MEPC_Read;

   ----------------------------------------------------------------------------
   -- MTVEC_Write
   ----------------------------------------------------------------------------
   procedure MTVEC_Write (Mtvec : in MTVEC_Type) is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        csrw    mtvec,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => MTVEC_Type'Asm_Input ("r", Mtvec),
           Clobber  => "",
           Volatile => True
          );
   end MTVEC_Write;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
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

   MSTATUS_USMIE : constant MSTATUS_Type := (
                                             UIE       => False,
                                             SIE       => False,
                                             Reserved1 => 0,
                                             MIE       => True,
                                             UPIE      => False,
                                             SPIE      => False,
                                             Reserved2 => 0,
                                             MPIE      => False,
                                             SPP       => False,
                                             Reserved3 => 0,
                                             MPP       => 0,
                                             FS        => 0,
                                             XS        => 0,
                                             MPRIV     => False,
                                             SUM       => False,
                                             MXR       => False,
                                             TVM       => False,
                                             TW        => False,
                                             TSR       => False,
                                             Reserved4 => 0,
                                             SD        => False
                                            );

   procedure Irq_Enable is
   begin
      Asm (
           Template => ""                              & CRLF &
                       "        csrrs   x0,mstatus,%0" & CRLF &
                       "        csrrs   x0,mie,%1    " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        MSTATUS_Type'Asm_Input ("r", MSTATUS_USMIE),
                        Interfaces.Unsigned_32'Asm_Input ("r", 16#0000_0080#)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      Asm (
           Template => ""                              & CRLF &
                       "        csrrc   x0,mstatus,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => MSTATUS_Type'Asm_Input ("r", MSTATUS_USMIE),
           Clobber  => "",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
   begin
      return 0; -- __TBD__
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
   begin
      null; -- __TBD__
   end Irq_State_Set;

end RISCV;
