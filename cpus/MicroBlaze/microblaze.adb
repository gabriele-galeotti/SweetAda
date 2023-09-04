-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ microblaze.adb                                                                                            --
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
with Definitions;

package body MicroBlaze is

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
   -- Cache management
   ----------------------------------------------------------------------------

   procedure ICache_Invalidate
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        addik   r5,r0,1  " & CRLF &
                       "        addik   r6,r5,2  " & CRLF &
                       "1:      wic     r5,r0    " & CRLF &
                       "        cmpu    r18,r5,r6" & CRLF &
                       "        blei    r18,2f   " & CRLF &
                       "        brid    1b       " & CRLF &
                       "        addik   r5,r5,3  " & CRLF &
                       "2:      nop              " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "r5,r6,r18",
           Volatile => True
          );
   end ICache_Invalidate;

   procedure ICache_Enable
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        mfs     r8,rmsr   " & CRLF &
                       "        ori     r8,r8,0x20" & CRLF &
                       "        mts     rmsr,r8   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "r8",
           Volatile => True
          );
   end ICache_Enable;

   procedure DCache_Invalidate
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        addik   r5,r0,1  " & CRLF &
                       "        addik   r6,r5,2  " & CRLF &
                       "1:      wdc     r5,r0    " & CRLF &
                       "        cmpu    r18,r5,r6" & CRLF &
                       "        blei    r18,2f   " & CRLF &
                       "        brid    1b       " & CRLF &
                       "        addik   r5,r5,3  " & CRLF &
                       "2:      nop              " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "r5,r6,r18",
           Volatile => True
          );
   end DCache_Invalidate;

   procedure DCache_Enable
      is
   begin
      Asm (
           Template => ""                           & CRLF &
                       "        mfs     r8,rmsr   " & CRLF &
                       "        ori     r8,r8,0x80" & CRLF &
                       "        mts     rmsr,r8   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "r8",
           Volatile => True
          );
   end DCache_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
      RMSR_R : Unsigned_32;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        mfs     %0,rmsr " & CRLF &
                       "        nop             " & CRLF &
                       "        ori     %0,%0,%1" & CRLF &
                       "        mts     rmsr,%0 " & CRLF &
                       "        nop             " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", RMSR_R),
           Inputs   => Unsigned_32'Asm_Input ("i", MSR_IE),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
      RMSR_R : Unsigned_32;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        mfs     %0,rmsr " & CRLF &
                       "        nop             " & CRLF &
                       "        andi    %0,%0,%1" & CRLF &
                       "        mts     rmsr,%0 " & CRLF &
                       "        nop             " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", RMSR_R),
           Inputs   => Unsigned_32'Asm_Input ("i", not MSR_IE),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   ----------------------------------------------------------------------------
   -- Irq_State_Get
   ----------------------------------------------------------------------------
   -- __TBD__
   function Irq_State_Get return Irq_State_Type
      is
   begin
      return 0;
   end Irq_State_Get;

   ----------------------------------------------------------------------------
   -- Irq_State_Set
   ----------------------------------------------------------------------------
   -- __TBD__
   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      is
   begin
      null;
   end Irq_State_Set;

end MicroBlaze;
