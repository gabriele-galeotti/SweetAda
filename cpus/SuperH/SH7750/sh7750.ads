-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7750.ads                                                                                                --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Core;
with Bits;

package SH7750 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Core;
   use Bits;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   -- TRAPA #C3
   BREAKPOINT_Instruction      : constant Unsigned_16 := 16#C3C3#;
   BREAKPOINT_Instruction_Size : constant             := 2;
   BREAKPOINT_Asm_String       : constant String      := ".word 0xC3C3";

   procedure NOP;
   procedure BREAKPOINT;

   ----------------------------------------------------------------------------
   -- SH4 registers
   ----------------------------------------------------------------------------

   R0       : constant := 0;
   R1       : constant := 1;
   R2       : constant := 2;
   R3       : constant := 3;
   R4       : constant := 4;
   R5       : constant := 5;
   R6       : constant := 6;
   R7       : constant := 7;
   R8       : constant := 8;
   R9       : constant := 9;
   R10      : constant := 10;
   R11      : constant := 11;
   R12      : constant := 12;
   R13      : constant := 13;
   R14      : constant := 14;
   R15      : constant := 15;
   R0_BANK0 : constant := R0;
   R1_BANK0 : constant := R1;
   R2_BANK0 : constant := R2;
   R3_BANK0 : constant := R3;
   R4_BANK0 : constant := R4;
   R5_BANK0 : constant := R5;
   R6_BANK0 : constant := R6;
   R7_BANK0 : constant := R7;
   R0_BANK1 : constant := R0;
   R1_BANK1 : constant := R1;
   R2_BANK1 : constant := R2;
   R3_BANK1 : constant := R3;
   R4_BANK1 : constant := R4;
   R5_BANK1 : constant := R5;
   R6_BANK1 : constant := R6;
   R7_BANK1 : constant := R7;

   subtype Register_Number_Type is Natural range R0 .. R15;

   ----------------------------------------------------------------------------
   -- Status Register
   ----------------------------------------------------------------------------
   -- initial value: 0111 0000 0000 0000 0000 00XX 1111 00XX
   ----------------------------------------------------------------------------

   type Status_Register_Type is
   record
      T       : Boolean;
      S       : Bits_1;
      Unused1 : Bits_2_Zeroes := Bits_2_0;
      IMASK   : Bits_4;
      Q       : Bits_1;
      M       : Bits_1;
      Unused2 : Bits_5_Zeroes := Bits_5_0;
      FD      : Boolean;
      Unused3 : Bits_12_Zeroes := Bits_12_0;
      BL      : Boolean;
      RB      : Bits_1;
      MD      : Bits_1;
      Unused4 : Bits_1_Zeroes := Bits_1_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Status_Register_Type use
   record
      T       at 0 range 0 .. 0;
      S       at 0 range 1 .. 1;
      Unused1 at 0 range 2 .. 3;
      IMASK   at 0 range 4 .. 7;
      Q       at 0 range 8 .. 8;
      M       at 0 range 9 .. 9;
      Unused2 at 0 range 10 .. 14;
      FD      at 0 range 15 .. 15;
      Unused3 at 0 range 16 .. 27;
      BL      at 0 range 28 .. 28;
      RB      at 0 range 29 .. 29;
      MD      at 0 range 30 .. 30;
      Unused4 at 0 range 31 .. 31;
   end record;

   function Status_Register_Read return Status_Register_Type;
   procedure Status_Register_Write (Value : in Status_Register_Type);

   ----------------------------------------------------------------------------
   -- SCIF
   ----------------------------------------------------------------------------

   SCIF_BASEADDRESS : constant := 16#FFE8_0000#; -- P4 area

   type SCIF_Serial_Control_Register_Type is
   record
      Unused1 : Bits_1_Zeroes := Bits_1_0;
      CKE1    : Bits_1;
      Unused2 : Bits_1_Zeroes := Bits_1_0;
      REIE    : Boolean;
      RE      : Boolean;
      TE      : Boolean;
      RIE     : Boolean;
      TIE     : Boolean;
      Unused3 : Bits_8_Zeroes := Bits_8_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCIF_Serial_Control_Register_Type use
   record
      Unused1 at 0 range 0 .. 0;
      CKE1    at 0 range 1 .. 1;
      Unused2 at 0 range 2 .. 2;
      REIE    at 0 range 3 .. 3;
      RE      at 0 range 4 .. 4;
      TE      at 0 range 5 .. 5;
      RIE     at 0 range 6 .. 6;
      TIE     at 0 range 7 .. 7;
      Unused3 at 0 range 8 .. 15;
   end record;

   type SCIF_Serial_Status_Register_Type is
   record
      DR    : Bits_1;
      RDF   : Bits_1;
      PER   : Bits_1;
      FER   : Bits_1;
      BRK   : Bits_1;
      TDFE  : Bits_1;
      TEND  : Boolean;
      ER    : Bits_1;
      FER03 : Bits_4;
      PER03 : Bits_4;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCIF_Serial_Status_Register_Type use
   record
      DR    at 0 range 0 .. 0;
      RDF   at 0 range 1 .. 1;
      PER   at 0 range 2 .. 2;
      FER   at 0 range 3 .. 3;
      BRK   at 0 range 4 .. 4;
      TDFE  at 0 range 5 .. 5;
      TEND  at 0 range 6 .. 6;
      ER    at 0 range 7 .. 7;
      FER03 at 0 range 8 .. 11;
      PER03 at 0 range 12 .. 15;
   end record;

   type SCIF_FIFO_Data_Count_Register_Type is
   record
      R       : Bits_5;
      Unused1 : Bits_3_Zeroes := Bits_3_0;
      T       : Bits_5;
      Unused2 : Bits_3_Zeroes := Bits_3_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCIF_FIFO_Data_Count_Register_Type use
   record
      R       at 0 range 0 .. 4;
      Unused1 at 0 range 5 .. 7;
      T       at 0 range 8 .. 12;
      Unused2 at 0 range 13 .. 15;
   end record;

pragma Warnings (Off, "size is not a multiple of alignment");
pragma Warnings (Off, "* bits of ""SCIF_Type"" unused");
   type SCIF_Type is
   record
      SCSCR2  : SCIF_Serial_Control_Register_Type  with Volatile_Full_Access => True;
      SCFTDR2 : Unsigned_8                         with Volatile_Full_Access => True;
      SCFSR2  : SCIF_Serial_Status_Register_Type   with Volatile_Full_Access => True;
      SCFDR2  : SCIF_FIFO_Data_Count_Register_Type with Volatile_Full_Access => True;
   end record with
      Alignment => 4,
      Size      => 16#26# * 8;
   for SCIF_Type use
   record
      SCSCR2  at 16#08# range 0 .. 15;
      SCFTDR2 at 16#0C# range 0 .. 7;
      SCFSR2  at 16#10# range 0 .. 15;
      SCFDR2  at 16#1C# range 0 .. 15;
   end record;
pragma Warnings (On, "* bits of ""SCIF_Type"" unused");
pragma Warnings (On, "size is not a multiple of alignment");

   SCIF : aliased SCIF_Type with
      Address    => To_Address (SCIF_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (NOP);
   pragma Inline (BREAKPOINT);

   pragma Inline (Status_Register_Read);
   pragma Inline (Status_Register_Write);

end SH7750;
