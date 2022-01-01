-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl011.adb                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;

package body PL011 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type PL011_Register_Type is (UARTDR, UARTRSR, UARTFR);

   PL011_Register_Offset : constant array (PL011_Register_Type) of Storage_Offset :=
      (
       UARTDR  => 0,
       UARTRSR => 16#04#,
       UARTFR  => 16#18#
      );

   type UARTDR_RX_Register_Type is
   record
      DATA   : Unsigned_8;
      FE     : Boolean;
      PE     : Boolean;
      BE     : Boolean;
      OE     : Boolean;
      Unused : Bits_4_Zeroes := Bits_4_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for UARTDR_RX_Register_Type use
   record
      DATA   at 0 range 0 .. 7;
      FE     at 1 range 0 .. 0;
      PE     at 1 range 1 .. 1;
      BE     at 1 range 2 .. 2;
      OE     at 1 range 3 .. 3;
      Unused at 1 range 4 .. 7;
   end record;

   type UARTFR_Register_Type is
   record
      CTS    : Boolean;
      DSR    : Boolean;
      DCD    : Boolean;
      BUSY   : Boolean;
      RXFE   : Boolean;
      TXFF   : Boolean;
      RXFF   : Boolean;
      TXFE   : Boolean;
      RI     : Boolean;
      Unused : Bits_7_Zeroes := Bits_7_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for UARTFR_Register_Type use
   record
      CTS    at 0 range 0 .. 0;
      DSR    at 0 range 1 .. 1;
      DCD    at 0 range 2 .. 2;
      BUSY   at 0 range 3 .. 3;
      RXFE   at 0 range 4 .. 4;
      TXFF   at 0 range 5 .. 5;
      RXFF   at 0 range 6 .. 6;
      TXFE   at 0 range 7 .. 7;
      RI     at 1 range 0 .. 0;
      Unused at 1 range 1 .. 7;
   end record;

   function Register_Read_8 (
                             Descriptor : PL011_Descriptor_Type;
                             Register   : PL011_Register_Type
                            ) return Unsigned_8;
   -- pragma Inline (Register_Read_8);
   procedure Register_Write_8 (
                               Descriptor : in PL011_Descriptor_Type;
                               Register   : in PL011_Register_Type;
                               Value      : in Unsigned_8
                              );
   -- pragma Inline (Register_Write_8);
   function Register_Read_16 (
                              Descriptor : PL011_Descriptor_Type;
                              Register   : PL011_Register_Type
                             ) return Unsigned_16;
   -- pragma Inline (Register_Read_16);
   procedure Register_Write_16 (
                                Descriptor : in PL011_Descriptor_Type;
                                Register   : in PL011_Register_Type;
                                Value      : in Unsigned_16
                               );
   -- pragma Inline (Register_Write_16);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Register_Read_8 (
                             Descriptor : PL011_Descriptor_Type;
                             Register   : PL011_Register_Type
                            ) return Unsigned_8 is
   begin
      return Descriptor.Read_8 (Descriptor.Base_Address + PL011_Register_Offset (Register));
   end Register_Read_8;

   procedure Register_Write_8 (
                               Descriptor : in PL011_Descriptor_Type;
                               Register   : in PL011_Register_Type;
                               Value      : in Unsigned_8
                              ) is
   begin
      Descriptor.Write_8 (Descriptor.Base_Address + PL011_Register_Offset (Register), Value);
   end Register_Write_8;

   function Register_Read_16 (
                              Descriptor : PL011_Descriptor_Type;
                              Register   : PL011_Register_Type
                             ) return Unsigned_16 is
   begin
      return Descriptor.Read_16 (Descriptor.Base_Address + PL011_Register_Offset (Register));
   end Register_Read_16;

   procedure Register_Write_16 (
                                Descriptor : in PL011_Descriptor_Type;
                                Register   : in PL011_Register_Type;
                                Value      : in Unsigned_16
                               ) is
   begin
      Descriptor.Write_16 (Descriptor.Base_Address + PL011_Register_Offset (Register), Value);
   end Register_Write_16;

   ----------------------------------------------------------------------------
   -- Local Subprograms (generic)
   ----------------------------------------------------------------------------

   generic
      Register_Type : in PL011_Register_Type;
      type Output_Register_Type is private;
      type Unsigned_Size_Type is private;
      with function Register_Read (
                                   P1 : PL011_Descriptor_Type;
                                   P2 : PL011_Register_Type
                                  ) return Unsigned_Size_Type;
   function Typed_Register_Read (
                                 Descriptor : PL011_Descriptor_Type
                                ) return Output_Register_Type;
   pragma Inline (Typed_Register_Read);
   function Typed_Register_Read (
                                 Descriptor : PL011_Descriptor_Type
                                ) return Output_Register_Type is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_Size_Type, Output_Register_Type);
   begin
      return Convert (Register_Read (Descriptor, Register_Type));
   end Typed_Register_Read;

   generic
      Register_Type : in PL011_Register_Type;
      type Input_Register_Type is private;
      type Unsigned_Size_Type is private;
      with procedure Register_Write (
                                     P1 : in PL011_Descriptor_Type;
                                     P2 : in PL011_Register_Type;
                                     P3 : in Unsigned_Size_Type
                                    );
   procedure Typed_Register_Write (
                                   Descriptor : in PL011_Descriptor_Type;
                                   Value      : in Input_Register_Type
                                  );
   pragma Inline (Typed_Register_Write);
   procedure Typed_Register_Write (
                                   Descriptor : in PL011_Descriptor_Type;
                                   Value      : in Input_Register_Type
                                  ) is
      function Convert is new Ada.Unchecked_Conversion (Input_Register_Type, Unsigned_Size_Type);
   begin
      Register_Write (Descriptor, Register_Type, Convert (Value));
   end Typed_Register_Write;

   ----------------------------------------------------------------------------
   -- Instantiation of generics
   ----------------------------------------------------------------------------

   procedure UARTDR_Write is new Typed_Register_Write (UARTDR, Unsigned_8, Unsigned_8, Register_Write_8);
   pragma Inline (UARTDR_Write);
   function UARTFR_Read is new Typed_Register_Read (UARTFR, UARTFR_Register_Type, Unsigned_16, Register_Read_16);
   pragma Inline (UARTFR_Read);

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (Descriptor : in PL011_Descriptor_Type) is
   begin
      null;
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX (Descriptor : in PL011_Descriptor_Type; Value : in Unsigned_8) is
   begin
      loop
         exit when not UARTFR_Read (Descriptor).TXFF;
      end loop;
      UARTDR_Write (Descriptor, Value);
   end TX;

end PL011;
