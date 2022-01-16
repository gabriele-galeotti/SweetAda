-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x86_64.adb                                                                                                --
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

package body x86_64 is

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
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        sti" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        cli" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
      Irq_State : Irq_State_Type;
   begin
      Asm (
           -- __TBD__
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => Irq_State_Type'Asm_Output ("=g", Irq_State),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
      return Irq_State;
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
   begin
      Asm (
           -- __TBD__
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Irq_State_Type'Asm_Input ("g", Irq_State),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking subprograms
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
      Value : Lock_Type := (Lock => LOCK_LOCK);
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        xchgq   %0,%1" & CRLF &
                       "",
           Outputs  => (
                        CPU_Unsigned'Asm_Output ("+r", Value.Lock),
                        CPU_Unsigned'Asm_Output ("+m", Lock_Object.Lock)
                       ),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      Success := Value.Lock = LOCK_UNLOCK;
   end Lock_Try;

   procedure Lock (Lock_Object : in out Lock_Type) is
      Success : Boolean;
   begin
      loop
         Lock_Try (Lock_Object, Success);
         exit when Success;
      end loop;
   end Lock;

   procedure Unlock (Lock_Object : out Lock_Type) is
   begin
      Lock_Object.Lock := LOCK_UNLOCK;
   end Unlock;

end x86_64;
