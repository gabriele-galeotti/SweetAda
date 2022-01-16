-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh.adb                                                                                                    --
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

with System;
with System.Machine_Code;
with Definitions;

package body SH is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Machine_Code;
   use Bits;

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
   -- Interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable is
   begin
      null; -- __TBD__
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      null; -- __TBD__
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
   begin
      return 0; -- __TBD__
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
   begin
      null; -- __TBD__
   end Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking subprograms
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
      Lock_Flag : CPU_Integer;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        tas.b   @%2  " & CRLF &
                       "        movt    %0   " & CRLF &
                       "        xor     #1,%0" & CRLF &
                       "",
           Outputs  => (
                        CPU_Integer'Asm_Output ("=z", Lock_Flag),
                        Lock_Type'Asm_Output ("+m", Lock_Object)
                       ),
           Inputs   => Address'Asm_Input ("r", Lock_Object'Address),
           Clobber  => "memory,t",
           Volatile => True
          );
      Success := Lock_Flag = 0;
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

end SH;
