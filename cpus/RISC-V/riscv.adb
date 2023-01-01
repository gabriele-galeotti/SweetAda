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

   RISCV_TOOLCHAIN_WORKAROUND : constant Boolean := True;

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
      if RISCV_TOOLCHAIN_WORKAROUND then
         Asm (
              Template => ""                           & CRLF &
                          "        mv      a5,%0     " & CRLF &
                          "        .long   0x342027F3" & CRLF &
                          "",
              Outputs  => Unsigned_32'Asm_Output ("=r", MCAUSE),
              Inputs   => No_Input_Operands,
              Clobber  => "a5",
              Volatile => True
             );
      else
         Asm (
              Template => ""                          & CRLF &
                          "        csrr    %0,mcause" & CRLF &
                          "",
              Outputs  => Unsigned_32'Asm_Output ("=r", MCAUSE),
              Inputs   => No_Input_Operands,
              Clobber  => "",
              Volatile => True
             );
      end if;
      return MCAUSE;
   end MCAUSE_Read;

   ----------------------------------------------------------------------------
   -- MEPC_Read
   ----------------------------------------------------------------------------
   function MEPC_Read return Unsigned_32 is
      MEPC : Unsigned_32;
   begin
      if RISCV_TOOLCHAIN_WORKAROUND then
         Asm (
              Template => ""                           & CRLF &
                          "        mv      a5,%0     " & CRLF &
                          "        .long   0x341027F3" & CRLF &
                          "",
              Outputs  => Unsigned_32'Asm_Output ("=r", MEPC),
              Inputs   => No_Input_Operands,
              Clobber  => "a5",
              Volatile => True
             );
      else
         Asm (
              Template => ""                        & CRLF &
                          "        csrr    %0,mepc" & CRLF &
                          "",
              Outputs  => Unsigned_32'Asm_Output ("=r", MEPC),
              Inputs   => No_Input_Operands,
              Clobber  => "",
              Volatile => True
             );
      end if;
      return MEPC;
   end MEPC_Read;

   ----------------------------------------------------------------------------
   -- MTVEC_Write
   ----------------------------------------------------------------------------
   procedure MTVEC_Write (Mtvec : in MTVEC_Type) is
   begin
      if RISCV_TOOLCHAIN_WORKAROUND then
         Asm (
              Template => ""                           & CRLF &
                          "        mv      a5,%0     " & CRLF &
                          "        .long   0x30579073" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => MTVEC_Type'Asm_Input ("r", Mtvec),
              Clobber  => "a5",
              Volatile => True
             );
      else
         Asm (
              Template => ""                         & CRLF &
                          "        csrw    mtvec,%0" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => MTVEC_Type'Asm_Input ("r", Mtvec),
              Clobber  => "",
              Volatile => True
             );
      end if;
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
                                             MIE       => True,
                                             UPIE      => False,
                                             SPIE      => False,
                                             MPIE      => False,
                                             SPP       => False,
                                             MPP       => 0,
                                             FS        => 0,
                                             XS        => 0,
                                             MPRIV     => False,
                                             SUM       => False,
                                             MXR       => False,
                                             TVM       => False,
                                             TW        => False,
                                             TSR       => False,
                                             SD        => False,
                                             others    => <>
                                            );

   procedure Irq_Enable is
   begin
      if RISCV_TOOLCHAIN_WORKAROUND then
         Asm (
              Template => ""                           & CRLF &
                          "        mv      a5,%0     " & CRLF &
                          "        .long   0x3007A073" & CRLF &
                          "        mv      a5,%1     " & CRLF &
                          "        .long   0x3047A073" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => [
                           MSTATUS_Type'Asm_Input ("r", MSTATUS_USMIE),
                           Unsigned_32'Asm_Input ("r", 16#0000_0080#)
                          ],
              Clobber  => "a5",
              Volatile => True
             );
      else
         Asm (
              Template => ""                              & CRLF &
                          "        csrrs   x0,mstatus,%0" & CRLF &
                          "        csrrs   x0,mie,%1    " & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => [
                           MSTATUS_Type'Asm_Input ("r", MSTATUS_USMIE),
                           Unsigned_32'Asm_Input ("r", 16#0000_0080#)
                          ],
              Clobber  => "",
              Volatile => True
             );
      end if;
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      if RISCV_TOOLCHAIN_WORKAROUND then
         Asm (
              Template => ""                           & CRLF &
                          "        mv      a5,%0     " & CRLF &
                          "        .long   0x3007B073" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => MSTATUS_Type'Asm_Input ("r", MSTATUS_USMIE),
              Clobber  => "a5",
              Volatile => True
             );
      else
         Asm (
              Template => ""                              & CRLF &
                          "        csrrc   x0,mstatus,%0" & CRLF &
                          "",
              Outputs  => No_Output_Operands,
              Inputs   => MSTATUS_Type'Asm_Input ("r", MSTATUS_USMIE),
              Clobber  => "",
              Volatile => True
             );
      end if;
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
