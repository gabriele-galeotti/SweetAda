-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68k.adb                                                                                                  --
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
with Definitions;

package body M68k
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
   -- Status Register (Condition Code Register)
   ----------------------------------------------------------------------------

   function SR_Read
      return SR_Type
      is
      Value : SR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        move.w  %%sr,%0" & CRLF &
                       "",
           Outputs  => SR_Type'Asm_Output ("=d", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end SR_Read;

   procedure SR_Write
      (Value : in SR_Type)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        move.w  %0,%%sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => SR_Type'Asm_Input ("d", Value),
           Clobber  => "",
           Volatile => True
          );
   end SR_Write;

   ----------------------------------------------------------------------------
   -- VBR_Set
   ----------------------------------------------------------------------------
   procedure VBR_Set
      (VBR_Address : in Address)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movec   %0,%%vbr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("d", VBR_Address),
           Clobber  => "",
           Volatile => True
          );
   end VBR_Set;

   ----------------------------------------------------------------------------
   -- MoveSByte
   ----------------------------------------------------------------------------

   function MoveSByte
      (A : Address)
      return Unsigned_8
      is
      B : Unsigned_8;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        moves.b %1@,%0" & CRLF &
                       "",
           Outputs  => Unsigned_8'Asm_Output ("=d", B),
           Inputs   => Address'Asm_Input ("a", A),
           Clobber  => "",
           Volatile => True
          );
      return B;
   end MoveSByte;

   procedure MoveSByte
      (A : in Address;
       B : in Unsigned_8)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        moves.b %0,%1@" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_8'Asm_Input ("d", B),
                        Address'Asm_Input ("a", A)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MoveSByte;

   ----------------------------------------------------------------------------
   -- MoveSWord
   ----------------------------------------------------------------------------

   function MoveSWord
      (A : in Address)
      return Unsigned_16
      is
      W : Unsigned_16;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        moves.w %1@,%0" & CRLF &
                       "",
           Outputs  => Unsigned_16'Asm_Output ("=d", W),
           Inputs   => Address'Asm_Input ("a", A),
           Clobber  => "",
           Volatile => True
          );
      return W;
   end MoveSWord;

   procedure MoveSWord
      (A : in Address;
       W : in Unsigned_16)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        moves.w %0,%1@" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_16'Asm_Input ("d", W),
                        Address'Asm_Input ("a", A)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MoveSWord;

   ----------------------------------------------------------------------------
   -- MoveSLong
   ----------------------------------------------------------------------------

   function MoveSLong
      (A : in Address)
      return Unsigned_32
      is
      L : Unsigned_32;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        moves.l %1@,%0" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=d", L),
           Inputs   => Address'Asm_Input ("a", A),
           Clobber  => "",
           Volatile => True
          );
      return L;
   end MoveSLong;

   procedure MoveSLong
      (A : in Address;
       L : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        moves.l %0,%1@" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("d", L),
                        Address'Asm_Input ("a", A)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MoveSLong;

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
   -- RESET
   ----------------------------------------------------------------------------
   procedure RESET
      is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        reset" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end RESET;

   ----------------------------------------------------------------------------
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT
      is
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
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
   begin
      Asm (
           Template => ""                    & CRLF &
                       "        jsr     %0@" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("a", Target_Address),
           Clobber  => "",
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
      Asm (
           Template => ""                        & CRLF &
                       "        move.w  %%sr,%0" & CRLF &
                       "",
           Outputs  => Intcontext_Type'Asm_Output ("=d", Intcontext),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
      Value : SR_Type;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        move.w  %0,%%sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Intcontext_Type'Asm_Input ("d", Intcontext),
           Clobber  => "cc,memory",
           Volatile => True
          );
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        andi.w  %0,%%sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Integer'Asm_Input ("i", 16#F8FF#),
           Clobber  => "memory",
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
           Template => ""                        & CRLF &
                       "        ori.w   %0,%%sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Integer'Asm_Input ("i", 16#0700#),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   ----------------------------------------------------------------------------
   -- Locking subprograms
   ----------------------------------------------------------------------------

   procedure Lock_Try
      (Lock_Object : in out Lock_Type;
       Success     :    out Boolean)
      is
   separate;

   procedure Lock
      (Lock_Object : in out Lock_Type)
      is
      Success : Boolean;
   begin
      loop
         Lock_Try (Lock_Object, Success);
         exit when Success;
      end loop;
   end Lock;

   procedure Unlock
      (Lock_Object : out Lock_Type)
      is
   begin
      Lock_Object.Lock := LOCK_UNLOCK;
   end Unlock;

end M68k;
