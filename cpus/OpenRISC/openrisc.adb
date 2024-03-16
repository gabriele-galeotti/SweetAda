-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ openrisc.adb                                                                                              --
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

package body OpenRISC
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

   ----------------------------------------------------------------------------
   -- SPRs generics
   ----------------------------------------------------------------------------

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   function MFSPR
      return Register_Type
      with Inline => True;

   function MFSPR
      return Register_Type
      is
      Result : Register_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        l.mfspr %0,r0,%1" & CRLF &
                       "",
           Outputs  => Register_Type'Asm_Output ("=r", Result),
           Inputs   => SPR_Type'Asm_Input ("i", SPR),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end MFSPR;

   generic
      SPR : in SPR_Type;
      type Register_Type is private;
   procedure MTSPR
      (Value : in Register_Type)
      with Inline => True;

   procedure MTSPR
      (Value : in Register_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        l.mtspr r0,%0,%1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Register_Type'Asm_Input ("r", Value),
                        SPR_Type'Asm_Input ("i", SPR)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MTSPR;

pragma Style_Checks (Off);

   function SR_Read return SR_Type
      is function SPR_Read is new MFSPR (SR_REGNO, SR_Type); begin return SPR_Read; end SR_Read;

   procedure SR_Write (Value : in SR_Type)
      is procedure SPR_Write is new MTSPR (SR_REGNO, SR_Type); begin SPR_Write (Value); end SR_Write;

   function TTMR_Read return TTMR_Type
      is function SPR_Read is new MFSPR (TTMR_REGNO, TTMR_Type); begin return SPR_Read; end TTMR_Read;

   procedure TTMR_Write (Value : in TTMR_Type)
      is procedure SPR_Write is new MTSPR (TTMR_REGNO, TTMR_Type); begin SPR_Write (Value); end TTMR_Write;

   function TTCR_Read return Unsigned_32
      is function SPR_Read is new MFSPR (TTCR_REGNO, Unsigned_32); begin return SPR_Read; end TTCR_Read;

   procedure TTCR_Write (Value : in Unsigned_32)
      is procedure SPR_Write is new MTSPR (TTCR_REGNO, Unsigned_32); begin SPR_Write (Value); end TTCR_Write;

   function VR_Read return VR_Type
      is function SPR_Read is new MFSPR (VR_REGNO, VR_Type); begin return SPR_Read; end VR_Read;

pragma Style_Checks (On);

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP
      is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        l.nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   procedure TEE_Enable
      (Enable : in Boolean)
      is
      SR : SR_Type;
   begin
      SR := SR_Read;
      SR.TEE := Enable;
      SR_Write (SR);
   end TEE_Enable;

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
      null; -- __TBD__
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
   begin
      null; -- __TBD__
   end Irq_Disable;

end OpenRISC;
