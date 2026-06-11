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
   -- SPRs
   ----------------------------------------------------------------------------

   procedure IVOR10_Write
      (Value : in Unsigned_32)
      is
      procedure SPR_Write is new PowerPC.MTSPR (IVOR10, Unsigned_32);
   begin
      SPR_Write (Value);
   end IVOR10_Write;

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

   procedure DECAR_Write
      (Value : in Unsigned_32)
      is
      procedure SPR_Write is new PowerPC.MTSPR (DECAR, Unsigned_32);
   begin
      SPR_Write (Value);
   end DECAR_Write;

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
