-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ppc440.adb                                                                                                --
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

package body PPC440
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
      return TSR_Type
      is
      function SPR_Read is new PowerPC.MFSPR (TSR, TSR_Type);
   begin
      return SPR_Read;
   end TSR_Read;

   procedure TSR_Write
      (Value : in TSR_Type)
      is
      procedure SPR_Write is new PowerPC.MTSPR (TSR, TSR_Type);
   begin
      SPR_Write (Value);
   end TSR_Write;

   -- constants-like-functions that return a single flag or its negated bitmask
pragma Style_Checks (Off);
   function To_TSR is new Ada.Unchecked_Conversion (Unsigned_32, TSR_Type);
   function TSR_DIS return TSR_Type is begin return (To_TSR (0) with delta DIS => True); end TSR_DIS;
   function TSR_FIS return TSR_Type is begin return (To_TSR (0) with delta FIS => True); end TSR_FIS;
pragma Style_Checks (On);

   function TCR_Read
      return TCR_Type
      is
      function SPR_Read is new PowerPC.MFSPR (TCR, TCR_Type);
   begin
      return SPR_Read;
   end TCR_Read;

   procedure TCR_Write
      (Value : in TCR_Type)
      is
      procedure SPR_Write is new PowerPC.MTSPR (TCR, TCR_Type);
   begin
      SPR_Write (Value);
   end TCR_Write;

   function DEC_Read
      return Unsigned_32
      is
      function SPR_Read is new PowerPC.MFSPR (PowerPC.DEC, Unsigned_32);
   begin
      return SPR_Read;
   end DEC_Read;

   procedure DEC_Write
      (Value : in Unsigned_32)
      is
      procedure SPR_Write is new PowerPC.MTSPR (PowerPC.DEC, Unsigned_32);
   begin
      SPR_Write (Value);
   end DEC_Write;

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
   -- Irq_Enable
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
           Template => ""                  & CRLF &
                       "        wrteei  0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

end PPC440;
