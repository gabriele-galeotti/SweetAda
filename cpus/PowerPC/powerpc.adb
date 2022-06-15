-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc.adb                                                                                               --
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
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT is
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        " & BREAKPOINT_Asm_String & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- SYNC
   ----------------------------------------------------------------------------
   procedure SYNC is
   begin
      Asm (
           Template => ""             & CRLF &
                       "        sync" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end SYNC;

   ----------------------------------------------------------------------------
   -- ISYNC
   ----------------------------------------------------------------------------
   procedure ISYNC is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        isync" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end ISYNC;

   ----------------------------------------------------------------------------
   -- MSR_Read
   ----------------------------------------------------------------------------
   function MSR_Read return MSR_Type is
      Result : MSR_Type;
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        mfmsr   %0" & CRLF &
                       "",
           Outputs  => MSR_Type'Asm_Output ("=r", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MSR_Read;

   ----------------------------------------------------------------------------
   -- MSR_Write
   ----------------------------------------------------------------------------
   procedure MSR_Write (Value : in MSR_Type) is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        mtmsr   %0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => MSR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end MSR_Write;

   ----------------------------------------------------------------------------
   -- SPRs generics
   ----------------------------------------------------------------------------

   function MFSPR return Register_Type is
      Result : Register_Type;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mfspr   %0,%1" & CRLF &
                       "",
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
           Template => ""                      & CRLF &
                       "        mtspr   %0,%1" & CRLF &
                       "",
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
   -- SPRs subprograms
   ----------------------------------------------------------------------------

   function PVR_Read return PVR_Type is
      function SPR_Read is new MFSPR (PVR, PVR_Type);
   begin
      return SPR_Read;
   end PVR_Read;

   ----------------------------------------------------------------------------
   -- Exceptions
   ----------------------------------------------------------------------------

   procedure Setup_Exception_Stack is
   begin
      Asm (
           Template => ""                                        & CRLF &
                       "        lis     r1,exception_stack@ha  " & CRLF &
                       "        ori     r1,r1,exception_stack@l" & CRLF &
                       "",
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
