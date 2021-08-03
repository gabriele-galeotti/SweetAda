-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc.adb                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with System.Machine_Code;
with Definitions;

package body PowerPC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
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
           Template => " nop",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT is
   begin
      Asm (
           Template => " " & BREAKPOINT_Asm_String,
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- MSR
   ----------------------------------------------------------------------------

   function MSR_Read return MSR_Register_Type is
      Result : MSR_Register_Type;
   begin
      Asm (
           Template => " mfmsr %0",
           Outputs  => MSR_Register_Type'Asm_Output ("=r", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MSR_Read;
   procedure MSR_Write (Value : in MSR_Register_Type) is
   begin
      Asm (
           Template => " mtmsr %0",
           Outputs  => No_Output_Operands,
           Inputs   => MSR_Register_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end MSR_Write;

   ----------------------------------------------------------------------------
   -- SPRs function templates
   ----------------------------------------------------------------------------

   function MFSPR return Register_Type is
      Result : Register_Type;
   begin
      Asm (
           Template => " mfspr %0,%1",
           Outputs  => Register_Type'Asm_Output ("=r", Result),
           Inputs   => SPR_Type'Asm_Input ("i", SPR),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFSPR;

   procedure MTSPR (Value : in Register_Type) is
   begin
      Asm (
           Template => " mtspr %0,%1",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        SPR_Type'Asm_Input ("i", SPR),
                        Register_Type'Asm_Input ("r", Value)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end MTSPR;

   ----------------------------------------------------------------------------
   -- SPRs access subprograms
   ----------------------------------------------------------------------------

   function PVR_Read return PVR_Register_Type is
      function SPR_Read is new MFSPR (PVR, PVR_Register_Type);
   begin
      return SPR_Read;
   end PVR_Read;

   function SVR_Read return Unsigned_32 is
      function SPR_Read is new MFSPR (PVR, Unsigned_32);
   begin
      return SPR_Read;
   end SVR_Read;

   ----------------------------------------------------------------------------
   -- Exceptions
   ----------------------------------------------------------------------------

   procedure Setup_Exception_Stack is
   begin
      Asm (
           Template => " lis r1,exception_stack@ha"    & CRLF &
                       " ori r1,r1,exception_stack@l",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Setup_Exception_Stack;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable is null;

   procedure Irq_Disable is null;

   function Irq_State_Get return Irq_State_Type is
   begin
      return 0;
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
      pragma Unreferenced (Irq_State);
   begin
      null;
   end Irq_State_Set;

end PowerPC;
