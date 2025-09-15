-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7032.adb                                                                                                --
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

with Ada.Unchecked_Conversion;
with MMIO;

package body SH7032
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Read the TCNT register
   ----------------------------------------------------------------------------
   function TCNT_Read
      return Unsigned_8
      is
   begin
      return MMIO.ReadA (System'To_Address (TCNT_READ_ADDRESS));
   end TCNT_Read;

   ----------------------------------------------------------------------------
   -- Write the TCNT register
   ----------------------------------------------------------------------------
   procedure TCNT_Write
      (Value : in Unsigned_8)
      is
   begin
      MMIO.WriteA (
         System'To_Address (TCNT_WRITE_ADDRESS),
         Make_Word (16#5A#, Value)
         );
   end TCNT_Write;

   ----------------------------------------------------------------------------
   -- Read the TCSR register
   ----------------------------------------------------------------------------
   function TCSR_Read
      return TCSR_Type
      is
      function To_TCSR is new Ada.Unchecked_Conversion (Unsigned_8, TCSR_Type);
   begin
      return To_TCSR (MMIO.ReadA (System'To_Address (TCSR_READ_ADDRESS)));
   end TCSR_Read;

   ----------------------------------------------------------------------------
   -- Write the TCSR register
   ----------------------------------------------------------------------------
   procedure TCSR_Write
      (Value : in TCSR_Type)
      is
      function To_U8 is new Ada.Unchecked_Conversion (TCSR_Type, Unsigned_8);
   begin
      MMIO.WriteA (
         System'To_Address (TCSR_WRITE_ADDRESS),
         Make_Word (16#A5#, To_U8 (Value))
         );
   end TCSR_Write;

   ----------------------------------------------------------------------------
   -- Read the RSTCSR register
   ----------------------------------------------------------------------------
   function RSTCSR_Read
      return RSTCSR_Type
      is
      function To_RSTCSR is new Ada.Unchecked_Conversion (Unsigned_8, RSTCSR_Type);
   begin
      return To_RSTCSR (MMIO.ReadA (System'To_Address (RSTCSR_READ_ADDRESS)));
   end RSTCSR_Read;

   ----------------------------------------------------------------------------
   -- Clear the WOVF flag in RSTCSR register
   ----------------------------------------------------------------------------
   procedure RSTCSR_WOVF_Clear
      is
   begin
      MMIO.WriteA (
         System'To_Address (RSTCSR_WRITE_ADDRESS),
         Unsigned_16'(16#A500#)
         );
   end RSTCSR_WOVF_Clear;

   ----------------------------------------------------------------------------
   -- Write RSTS and RSTE flags in RSTCSR register
   ----------------------------------------------------------------------------
   procedure RSTCSR_Write
      (RSTS : in Bits_1;
       RSTE : in Boolean)
      is
      RSTCSR : constant RSTCSR_Type := (
         RSTS   => RSTS,
         RSTE   => RSTE,
         others => <>
         );
      function To_U8 is new Ada.Unchecked_Conversion (RSTCSR_Type, Unsigned_8);
   begin
      MMIO.WriteA (
         System'To_Address (RSTCSR_WRITE_ADDRESS),
         Make_Word (16#5A#, To_U8 (RSTCSR))
         );
   end RSTCSR_Write;

end SH7032;
