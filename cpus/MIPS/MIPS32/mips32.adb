-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips32.adb                                                                                                --
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
with Ada.Unchecked_Conversion;
with Definitions;

package body MIPS32 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   Register_Equates : constant String :=
      "        .equ    CP0_Index,   $0 " & CRLF &
      "        .equ    CP0_EntryLo, $2 " & CRLF &
      "        .equ    CP0_Context, $4 " & CRLF &
      "        .equ    CP0_BadVAddr,$8 " & CRLF &
      "        .equ    CP0_Count,   $9 " & CRLF &
      "        .equ    CP0_EntryHi, $10" & CRLF &
      "        .equ    CP0_Compare, $11" & CRLF &
      "        .equ    CP0_SR,      $12" & CRLF &
      "        .equ    CP0_Cause,   $13" & CRLF &
      "        .equ    CP0_EPC,     $14" & CRLF &
      "        .equ    CP0_PRId,    $15" & CRLF &
      "        .equ    CP0_Config,  $16" & CRLF &
      "        .equ    CP0_WatchLo, $18" & CRLF &
      "        .equ    CP0_WatchHi, $19" & CRLF &
      "        .equ    CP0_XContext,$20" & CRLF &
      "        .equ    CP0_Debug,   $23" & CRLF;

   type CP0_Register_Type is range 16#00# .. 16#1F#;        -- 32 CP0 registers
   type CP0_Register_Select_Type is range 2#000# .. 2#111#; -- 3-bit select field

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CP0 access templates
   ----------------------------------------------------------------------------

   generic
      Register        : CP0_Register_Type;
      Register_Select : CP0_Register_Select_Type;
   function MFC0 return Unsigned_32;
   pragma Inline (MFC0);
   function MFC0 return Unsigned_32 is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        mfc0    %0,$%1,%2" & CRLF &
                       "        nop              " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => [
                        CP0_Register_Type'Asm_Input ("i", Register),
                        CP0_Register_Select_Type'Asm_Input ("i", Register_Select)
                       ],
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFC0;

   generic
      Register        : CP0_Register_Type;
      Register_Select : CP0_Register_Select_Type;
   procedure MTC0 (Register_Value : in Unsigned_32);
   pragma Inline (MTC0);
   procedure MTC0 (Register_Value : in Unsigned_32) is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        mtc0    %0,$%1,%2" & CRLF &
                       "        nop              " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("r", Register_Value),
                        CP0_Register_Type'Asm_Input ("i", Register),
                        CP0_Register_Select_Type'Asm_Input ("i", Register_Select)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MTC0;

   ----------------------------------------------------------------------------
   -- Count register (CP0 register 9, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Count_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (9, 0);
   begin
      return CP0_Read;
   end CP0_Count_Read;

   procedure CP0_Count_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (9, 0);
   begin
      CP0_Write (Value);
   end CP0_Count_Write;

   ----------------------------------------------------------------------------
   -- Compare register (CP0 register 11, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Compare_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (11, 0);
   begin
      return CP0_Read;
   end CP0_Compare_Read;

   procedure CP0_Compare_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (11, 0);
   begin
      CP0_Write (Value);
   end CP0_Compare_Write;

   ----------------------------------------------------------------------------
   -- Status Register (CP0 register 12, Select 0)
   ----------------------------------------------------------------------------

   function CP0_SR_Read return Status_Type is
      function U32_To_SRT is new Ada.Unchecked_Conversion (Unsigned_32, Status_Type);
      function CP0_Read is new MFC0 (12, 0);
   begin
      return U32_To_SRT (CP0_Read);
   end CP0_SR_Read;

   procedure CP0_SR_Write (Value : in Status_Type) is
      function SRT_To_U32 is new Ada.Unchecked_Conversion (Status_Type, Unsigned_32);
      procedure CP0_Write is new MTC0 (12, 0);
   begin
      CP0_Write (SRT_To_U32 (Value));
   end CP0_SR_Write;

   ----------------------------------------------------------------------------
   -- Cause register (CP0 register 13, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Cause_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (13, 0);
   begin
      return CP0_Read;
   end CP0_Cause_Read;

   procedure CP0_Cause_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (13, 0);
   begin
      CP0_Write (Value);
   end CP0_Cause_Write;

   ----------------------------------------------------------------------------
   -- Exception Program Counter register (CP0 register 14, Select 0)
   ----------------------------------------------------------------------------

   function CP0_EPC_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (14, 0);
   begin
      return CP0_Read;
   end CP0_EPC_Read;

   procedure CP0_EPC_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (14, 0);
   begin
      CP0_Write (Value);
   end CP0_EPC_Write;

   ----------------------------------------------------------------------------
   -- PRId register (CP0 register 15, Select 0)
   ----------------------------------------------------------------------------

   function CP0_PRId_Read return PRId_Type is
      function U32_To_PRId is new Ada.Unchecked_Conversion (Unsigned_32, PRId_Type);
      function CP0_Read is new MFC0 (15, 0);
   begin
      return U32_To_PRId (CP0_Read);
   end CP0_PRId_Read;

   ----------------------------------------------------------------------------
   -- Config register (CP0 register 16, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Config_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (16, 0);
   begin
      return CP0_Read;
   end CP0_Config_Read;

   procedure CP0_Config_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (16, 0);
   begin
      CP0_Write (Value);
   end CP0_Config_Write;

   ----------------------------------------------------------------------------
   -- Config1 register (CP0 register 16, Select 1)
   ----------------------------------------------------------------------------

   function CP0_Config1_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (16, 1);
   begin
      return CP0_Read;
   end CP0_Config1_Read;

   procedure CP0_Config1_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (16, 1);
   begin
      CP0_Write (Value);
   end CP0_Config1_Write;

   ----------------------------------------------------------------------------
   -- Debug register (CP0 register 23, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Debug_Read return Unsigned_32 is
      function CP0_Read is new MFC0 (23, 0);
   begin
      return CP0_Read;
   end CP0_Debug_Read;

   procedure CP0_Debug_Write (Value : in Unsigned_32) is
      procedure CP0_Write is new MTC0 (23, 0);
   begin
      CP0_Write (Value);
   end CP0_Debug_Write;

   ----------------------------------------------------------------------------
   -- Interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable is
   begin
      Asm (
           Template => ""                               & CRLF &
                       Register_Equates                        &
                       "        mfc0    $t0,CP0_SR,0  " & CRLF &
                       "        nop                   " & CRLF &
                       "        lui     $t1,0         " & CRLF &
                       "        ori     $t1,$t1,0xFC01" & CRLF & -- IM7..IM2 all enabled
                       "        or      $t0,$t1       " & CRLF &
                       "        mtc0    $t0,CP0_SR,0  " & CRLF &
                       "        nop                   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "$t0,$t1",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      null;
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
   begin
      return 0;
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
   begin
      null;
   end Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking subprograms
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
      Locked_Item : Lock_Type := (Lock => LOCK_LOCK);
      T_lock      : Lock_Type;
   begin
      -- ll/sc locking implementation
      -- current value of the lock is loaded in T_lock; if sc succeeded (so a
      -- write of Locked_Item in the lock occured), then a 1 is written back in
      -- Locked_Item); if sc fails (because memory was updated in the middle) a
      -- 0 is written back in Locked_Item
      Asm (
           Template => ""                         & CRLF &
                       "        ll      %0,0(%2)" & CRLF &
                       "        sc      %1,0(%2)" & CRLF &
                       "",
           Outputs  => [
                        CPU_Unsigned'Asm_Output ("=&r", T_lock.Lock),
                        CPU_Unsigned'Asm_Output ("+r", Locked_Item.Lock)
                       ],
           Inputs   => Address'Asm_Input ("r", Lock_Object.Lock'Address),
           Clobber  => "",
           Volatile => True
          );
      -- if sc fails, Locked_Item is 0
      if Locked_Item.Lock = 0 then
         Success := False;
      else
      -- if sc succeeded, check if lock was already taken
         Success := T_lock.Lock = LOCK_UNLOCK;
      end if;
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

end MIPS32;
