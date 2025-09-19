-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh.adb                                                                                                    --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with Definitions;

package body SH
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
   -- SR_Read
   ----------------------------------------------------------------------------
   function SR_Read
      return Unsigned_32
      is
      SR : Unsigned_32;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        stc     sr,%0" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", SR),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return SR;
   end SR_Read;

   ----------------------------------------------------------------------------
   -- SR_Write
   ----------------------------------------------------------------------------
   procedure SR_Write
      (SR : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        ldc     %0,sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Unsigned_32'Asm_Input ("r", SR),
           Clobber  => "",
           Volatile => True
          );
   end SR_Write;

   ----------------------------------------------------------------------------
   -- VBR_Set
   ----------------------------------------------------------------------------
   procedure VBR_Set
      (VBR : in Address)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        ldc     %0,vbr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("r", VBR),
           Clobber  => "",
           Volatile => True
          );
   end VBR_Set;

   ----------------------------------------------------------------------------
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Intcontext := 0; -- __TBD__
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
   begin
      SR_Write (SR_Read and 16#EFFF_FF0F#);
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
   begin
      SR_Write ((SR_Read and 16#EFFF_FF0F#) or 16#0000_00F0#);
   end Irq_Disable;

end SH;
