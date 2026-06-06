-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ microblaze.adb                                                                                            --
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
with Definitions;

package body MicroBlaze
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

   -- constants-like-functions that return a single flag or its negated bitmask
pragma Style_Checks (Off);
   function To_MSR is new Ada.Unchecked_Conversion (Unsigned_32, MSR_Type);
   function MSR_IE   return MSR_Type is begin return (To_MSR (0) with delta IE => True); end MSR_IE;
   function MSR_nIE  return MSR_Type is begin return (To_MSR (16#FFFF_FFFF#) with delta IE => False); end MSR_nIE;
   function MSR_ICE  return MSR_Type is begin return (To_MSR (0) with delta ICE => True); end MSR_ICE;
   function MSR_nICE return MSR_Type is begin return (To_MSR (16#FFFF_FFFF#) with delta ICE => False); end MSR_nICE;
   function MSR_DCE  return MSR_Type is begin return (To_MSR (0) with delta DCE => True); end MSR_DCE;
   function MSR_nDCE return MSR_Type is begin return (To_MSR (16#FFFF_FFFF#) with delta DCE => False); end MSR_nDCE;
pragma Style_Checks (On);

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
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      null; -- __TBD__
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
   begin
      null; -- __TBD__
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
      IE    : constant MSR_Type := MSR_IE;
      MSR_R : Unsigned_32;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        mfs     %0,rmsr " & CRLF &
                       "        nop             " & CRLF &
                       "        or      %0,%0,%1" & CRLF &
                       "        mts     rmsr,%0 " & CRLF &
                       "        nop             " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("r", MSR_R),
                        MSR_Type'Asm_Input ("r", IE)
                       ],
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
      nIE   : constant MSR_Type := MSR_nIE;
      MSR_R : Unsigned_32;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        mfs     %0,rmsr " & CRLF &
                       "        nop             " & CRLF &
                       "        and     %0,%0,%1" & CRLF &
                       "        mts     rmsr,%0 " & CRLF &
                       "        nop             " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("r", MSR_R),
                        MSR_Type'Asm_Input ("r", nIE)
                       ],
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

end MicroBlaze;
