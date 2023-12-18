-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ppc405.adb                                                                                                --
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

package body PPC405
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
   -- DCRs subprogram templates
   ----------------------------------------------------------------------------

   function MFDCR
      return DCR_Value_Type
      is
      DCR_Value : DCR_Value_Type;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mfdcr   %0,%1" & CRLF &
                       "",
           Outputs  => DCR_Value_Type'Asm_Output ("=r", DCR_Value),
           Inputs   => DCR_Type'Asm_Input ("i", DCR),
           Clobber  => "",
           Volatile => True
          );
      return DCR_Value;
   end MFDCR;

   procedure MTDCR
      (DCR_Value : in DCR_Value_Type)
      is
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mtdcr   %0,%1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        DCR_Type'Asm_Input ("i", DCR),
                        DCR_Value_Type'Asm_Input ("r", DCR_Value)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end MTDCR;

   ----------------------------------------------------------------------------
   -- PPC405 SPRs subprograms
   ----------------------------------------------------------------------------

   function TSR_Read
      return TSR_Register_Type
      is
      function SPR_Read is new MFSPR (TSR, TSR_Register_Type);
   begin
      return SPR_Read;
   end TSR_Read;

   procedure TSR_Write
      (Value : in TSR_Register_Type)
      is
      procedure SPR_Write is new MTSPR (TSR, TSR_Register_Type);
   begin
      SPR_Write (Value);
   end TSR_Write;

   function TCR_Read
      return TCR_Register_Type
      is
      function SPR_Read is new MFSPR (TCR, TCR_Register_Type);
   begin
      return SPR_Read;
   end TCR_Read;

   procedure TCR_Write
      (Value : in TCR_Register_Type)
      is
      procedure SPR_Write is new MTSPR (TCR, TCR_Register_Type);
   begin
      SPR_Write (Value);
   end TCR_Write;

   function PIT_Read
      return Unsigned_32
      is
      function SPR_Read is new MFSPR (PIT, Unsigned_32);
   begin
      return SPR_Read;
   end PIT_Read;

   procedure PIT_Write
      (Value : in Unsigned_32)
      is
      procedure SPR_Write is new MTSPR (PIT, Unsigned_32);
   begin
      SPR_Write (Value);
   end PIT_Write;

   ----------------------------------------------------------------------------
   -- DCRs subprograms
   ----------------------------------------------------------------------------

   function UIC0_SR_Read
      return UIC0_SR_Type
      is
      function DCR_Read is new MFDCR (UIC0_SR, UIC0_SR_Type);
   begin
      return DCR_Read;
   end UIC0_SR_Read;

   procedure UIC0_SR_Write
      (Value : in UIC0_SR_Type)
      is
      procedure DCR_Write is new MTDCR (UIC0_SR, UIC0_SR_Type);
   begin
      DCR_Write (Value);
   end UIC0_SR_Write;

   -- function UIC0_ER_Read
   --    return UIC0_ER_Type
   --    is
   --    function DCR_Read is new MFDCR (UIC0_ER, UIC0_ER_Type);
   -- begin
   --    return DCR_Read;
   -- end UIC0_ER_Read;

   -- procedure UIC0_ER_Write
   --    (Value : in UIC0_ER_Type)
   --    is
   --    procedure DCR_Write is new MTDCR (UIC0_ER, UIC0_ER_Type);
   -- begin
   --    DCR_Write (Value);
   -- end UIC0_ER_Write;

   function UIC0_ER_Read
      return Bitmap_32
      is
      function DCR_Read is new MFDCR (UIC0_ER, Bitmap_32);
   begin
      return DCR_Read;
   end UIC0_ER_Read;

   procedure UIC0_ER_Write
      (Value : in Bitmap_32)
      is
      procedure DCR_Write is new MTDCR (UIC0_ER, Bitmap_32);
   begin
      DCR_Write (Value);
   end UIC0_ER_Write;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        wrteei  1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable
      is
   begin
      Asm (
           Template => ""                  & CRLF &
                       "        wrteei  0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end Irq_Disable;

end PPC405;
