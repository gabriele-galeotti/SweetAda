-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips-r3000.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with MIPS;

package body R3000
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   subtype CP0_Register_Type is MIPS.CP0_Register_Type;
   CRLF renames MIPS.CRLF;
   Asm_Register_Equates renames MIPS.Asm_Register_Equates;

   NOP3 : constant String :=
      "        nop" & CRLF &
      "        nop" & CRLF &
      "        nop" & CRLF;

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
   -- R3000 has no register select
   ----------------------------------------------------------------------------

   generic
      Register : CP0_Register_Type;
   function MFC0
      return Unsigned_32
      with Inline => True;

   function MFC0
      return Unsigned_32
      is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        .set    push     " & CRLF &
                       "        .set    noreorder" & CRLF &
                       "        mfc0    %0,$%1   " & CRLF &
                       "        .set    pop      " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => CP0_Register_Type'Asm_Input ("i", Register),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFC0;

   generic
      Register : CP0_Register_Type;
   procedure MTC0
      (Register_Value : in Unsigned_32)
      with Inline => True;

   procedure MTC0
      (Register_Value : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        .set    push     " & CRLF &
                       "        .set    noreorder" & CRLF &
                       "        mtc0    %0,$%1   " & CRLF &
                       NOP3                               &
                       "        .set    pop      " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("r", Register_Value),
                        CP0_Register_Type'Asm_Input ("i", Register)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MTC0;

   ----------------------------------------------------------------------------
   -- CP0_PRId_Read
   ----------------------------------------------------------------------------
   function CP0_PRId_Read
      return PRId_Type
      is
      function To_PRId is new Ada.Unchecked_Conversion (Unsigned_32, PRId_Type);
      function CP0_Read is new MFC0 (15);
   begin
      return To_PRId (CP0_Read);
   end CP0_PRId_Read;

   ----------------------------------------------------------------------------
   -- CP0_SR_Read/Write
   ----------------------------------------------------------------------------

   function CP0_SR_Read
      return SR_Type
      is
      function To_SR is new Ada.Unchecked_Conversion (Unsigned_32, SR_Type);
      function CP0_Read is new MFC0 (12);
   begin
      return To_SR (CP0_Read);
   end CP0_SR_Read;

   procedure CP0_SR_Write
      (Value : in SR_Type)
      is
      function To_U32 is new Ada.Unchecked_Conversion (SR_Type, Unsigned_32);
      procedure CP0_Write is new MTC0 (12);
   begin
      CP0_Write (To_U32 (Value));
   end CP0_SR_Write;

   ----------------------------------------------------------------------------
   -- Cache_Size
   ----------------------------------------------------------------------------
   function Cache_Size
      (ICache : Boolean)
      return Unsigned_32
      is
      SwC  : Unsigned_32;
      Size : Unsigned_32;
   begin
      SwC := 0;
      if ICache then
         SwC := 16#0002_0000#;
      end if;
      Asm (
           Template => ""                           & CRLF &
                       "        .set    push      " & CRLF &
                       "        .set    noreorder " & CRLF &
                       "        subu    $sp,4     " & CRLF &
                       "        sw      $ra,0($sp)" & CRLF &
                       "        move    $a0,%1    " & CRLF &
                       "        .extern size_cache" & CRLF &
                       "        jal     size_cache" & CRLF &
                       "        nop               " & CRLF &
                       "        move    %0,$v0    " & CRLF &
                       "        lw      $ra,0($sp)" & CRLF &
                       "        addu    $sp,4     " & CRLF &
                       "        .set    pop       " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Size),
           Inputs   => Unsigned_32'Asm_Input ("r", SwC),
           Clobber  => "memory,$v0,$v1,$a0,$t0,$t1,$t2",
           Volatile => True
          );
      return Size;
   end Cache_Size;

   ----------------------------------------------------------------------------
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       Asm_Register_Equates               &
                       "        .set    push     " & CRLF &
                       "        .set    reorder  " & CRLF &
                       "        mfc0    %0,CP0_SR" & CRLF &
                       "        .set    pop      " & CRLF &
                       "",
           Outputs  => Intcontext_Type'Asm_Output ("=r", Intcontext),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
      CP0R12_R : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       Asm_Register_Equates               &
                       "        .set    push     " & CRLF &
                       "        .set    noreorder" & CRLF &
                       "        .set    noat     " & CRLF &
                       "        mfc0    $1,CP0_SR" & CRLF &
                       "        andi    %0,1     " & CRLF &
                       "        ori     $1,1     " & CRLF &
                       "        xori    $1,1     " & CRLF &
                       "        or      %0,$1    " & CRLF &
                       "        mtc0    %0,CP0_SR" & CRLF &
                       NOP3                               &
                       "        .set    pop      " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", CP0R12_R),
           Inputs   => Intcontext_Type'Asm_Input ("0", Intcontext),
           Clobber  => "$1,memory",
           Volatile => True
          );
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable is
      R : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       Asm_Register_Equates               &
                       "        .set    push     " & CRLF &
                       "        .set    reorder  " & CRLF &
                       "        .set    noat     " & CRLF &
                       "        mfc0    %0,CP0_SR" & CRLF &
                       "        ori     %0,0x1F  " & CRLF &
                       "        xori    %0,0x1E  " & CRLF &
                       "        mtc0    %0,CP0_SR" & CRLF &
                       NOP3                               &
                       "        .set    pop      " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", R),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable is
      R : Unsigned_32;
   begin
      Asm (
           Template => ""                          & CRLF &
                       Asm_Register_Equates               &
                       "        .set    push     " & CRLF &
                       "        .set    reorder  " & CRLF &
                       "        .set    noat     " & CRLF &
                       "        mfc0    %0,CP0_SR" & CRLF &
                       "        ori     %0,1     " & CRLF &
                       "        xori    %0,1     " & CRLF &
                       "        .set    noreorder" & CRLF &
                       "        mtc0    %0,CP0_SR" & CRLF &
                       NOP3                               &
                       "        .set    pop      " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", R),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

end R3000;
