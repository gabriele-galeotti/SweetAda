-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ am7990.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

-- with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with MMIO;
with LLutils;
with Memory_Functions;
with Console;

package body Am7990 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

--   use System.Storage_Elements;

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

--   function CSRX_Read (Register_Number : Unsigned_16) return Unsigned_16;
--   procedure CSRX_Write (Register_Number : in Unsigned_16; Value : in Unsigned_16);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Am7990 register read/write
   ----------------------------------------------------------------------------

   function CSRX_Read (Register_Number : Unsigned_16) return Unsigned_16 is
      Result : Unsigned_16;
   begin
      -- __FIX__ lock
      MMIO.WriteA (To_Address (RAP), Register_Number);
      Result := MMIO.ReadA (To_Address (RDP));
      -- __FIX__ unlock
      return Result;
   end CSRX_Read;

   procedure CSRX_Write (Register_Number : in Unsigned_16; Value : in Unsigned_16) is
   begin
      -- __FIX__ lock
      MMIO.WriteA (To_Address (RAP), Register_Number);
      MMIO.WriteA (To_Address (RDP), Value);
      -- __FIX__ unlock
   end CSRX_Write;

   generic
      Register_Number : Unsigned_16;
      type Output_Register_Type is private;
   function CSR_Read return Output_Register_Type;
   pragma Inline (CSR_Read);
   function CSR_Read return Output_Register_Type is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_16, Output_Register_Type);
   begin
      return Convert (CSRX_Read (Register_Number));
   end CSR_Read;

   generic
      Register_Number : in Unsigned_16;
      type Input_Register_Type is private;
   procedure CSR_Write (Value : in Input_Register_Type);
   pragma Inline (CSR_Write);
   procedure CSR_Write (Value : in Input_Register_Type) is
      function Convert is new Ada.Unchecked_Conversion (Input_Register_Type, Unsigned_16);
   begin
      CSRX_Write (Register_Number, Convert (Value));
   end CSR_Write;

   function CSR0_Read is new CSR_Read (CSR0, CSR0_Type);
   pragma Inline (CSR0_Read);
   procedure CSR0_Write is new CSR_Write (CSR0, CSR0_Type);
   pragma Inline (CSR0_Write);

   function CSR1_Read is new CSR_Read (CSR1, Unsigned_16);
   pragma Inline (CSR1_Read);
   procedure CSR1_Write is new CSR_Write (CSR1, Unsigned_16);
   pragma Inline (CSR1_Write);

   function CSR2_Read is new CSR_Read (CSR2, Unsigned_16);
   pragma Inline (CSR2_Read);
   procedure CSR2_Write is new CSR_Write (CSR2, Unsigned_16);
   pragma Inline (CSR2_Write);

   function CSR3_Read is new CSR_Read (CSR3, CSR3_Type);
   pragma Inline (CSR3_Read);
   procedure CSR3_Write is new CSR_Write (CSR3, CSR3_Type);
   pragma Inline (CSR3_Write);

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      RDRA                : Ring_Descriptor_Pointer_Type;
      TDRA                : Ring_Descriptor_Pointer_Type;
      Ethernet_Descriptor : Ethernet_Descriptor_Type := Ethernet_DESCRIPTOR_INVALID;
      function To_RDP is new Ada.Unchecked_Conversion (Unsigned_32, Ring_Descriptor_Pointer_Type);
      function To_U32 is new Ada.Unchecked_Conversion (Ring_Descriptor_Pointer_Type, Unsigned_32);
   begin
      -- begin initialization sequence by setting STOP bit --------------------
      CSR0_Write ((STOP => True, others => False));
   end Init;

end Am7990;
