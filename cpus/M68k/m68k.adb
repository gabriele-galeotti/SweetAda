-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68k.adb                                                                                                  --
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

package body M68k is

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
           Template => "        nop",
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
           Template => "        " & BREAKPOINT_Asm_String,
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- Status Register (Condition Code Register)
   ----------------------------------------------------------------------------

   function SR_Read return SR_Type is
      Value : SR_Type;
   begin
      Asm (
           Template => "        move.w %%sr,%0",
           Outputs  => SR_Type'Asm_Output ("=d", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end SR_Read;

   procedure SR_Write (Value : in SR_Type) is
   begin
      Asm (
           Template => "        move.w %0,%%sr",
           Outputs  => No_Output_Operands,
           Inputs   => SR_Type'Asm_Input ("d", Value),
           Clobber  => "",
           Volatile => True
          );
   end SR_Write;

   ----------------------------------------------------------------------------
   -- VBR_Set
   ----------------------------------------------------------------------------
   procedure VBR_Set (VBR_Address : in Address) is
   begin
      Asm (
           Template => "        movec %0,%%vbr",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("d", VBR_Address),
           Clobber  => "",
           Volatile => True
          );
   end VBR_Set;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
   begin
      Asm (
           Template => "        jsr %0@",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("a", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable is
   begin
      Asm (
           Template => "        andi.w #0xF8FF,%%sr",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      Asm (
           Template => "        ori.w #0x0700,%%sr",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
   begin
      return SR_Read.ILEVEL;
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
      Value : SR_Type;
   begin
      Value        := SR_Read;
      Value.ILEVEL := Irq_State;
      SR_Write (Value);
   end Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking subprograms
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
   separate;

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

end M68k;
