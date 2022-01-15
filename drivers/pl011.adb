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

   type PL011_Register_Type is (DR, RSR, FR);

   PL011_Register_Offset : constant array (PL011_Register_Type) of Storage_Offset :=
      (
       DR  => 0,
       RSR => 16#04#,
       FR  => 16#18#
      );

   type DR_RX_Type is
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
   for DR_RX_Type use
   record
      DATA   at 0 range 0 .. 7;
      FE     at 1 range 0 .. 0;
      PE     at 1 range 1 .. 1;
      BE     at 1 range 2 .. 2;
      OE     at 1 range 3 .. 3;
      Unused at 1 range 4 .. 7;
   end record;

   function To_U16 is new Ada.Unchecked_Conversion (DR_RX_Type, Unsigned_16);
   function To_DR_RX is new Ada.Unchecked_Conversion (Unsigned_16, DR_RX_Type);

   type FR_Type is
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
   for FR_Type use
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

   function To_U16 is new Ada.Unchecked_Conversion (FR_Type, Unsigned_16);
   function To_FR is new Ada.Unchecked_Conversion (Unsigned_16, FR_Type);

   -- Local subprograms

   function Register_Read (
                           Descriptor : PL011_Descriptor_Type;
                           Register   : PL011_Register_Type
                          ) return Unsigned_8 with
      Inline => True;
   procedure Register_Write (
                             Descriptor : in PL011_Descriptor_Type;
                             Register   : in PL011_Register_Type;
                             Value      : in Unsigned_8
                            ) with
      Inline => True;
   function Register_Read (
                           Descriptor : PL011_Descriptor_Type;
                           Register   : PL011_Register_Type
                          ) return Unsigned_16 with
      Inline => True;
   procedure Register_Write (
                             Descriptor : in PL011_Descriptor_Type;
                             Register   : in PL011_Register_Type;
                             Value      : in Unsigned_16
                            ) with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read (8-bit)
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : PL011_Descriptor_Type;
                           Register   : PL011_Register_Type
                          ) return Unsigned_8 is
   begin
      return Descriptor.Read_8 (Descriptor.Base_Address + PL011_Register_Offset (Register));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write (8-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in PL011_Descriptor_Type;
                             Register   : in PL011_Register_Type;
                             Value      : in Unsigned_8
                            ) is
   begin
      Descriptor.Write_8 (Descriptor.Base_Address + PL011_Register_Offset (Register), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Register_Read (16-bit)
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : PL011_Descriptor_Type;
                           Register   : PL011_Register_Type
                          ) return Unsigned_16 is
   begin
      return Descriptor.Read_16 (Descriptor.Base_Address + PL011_Register_Offset (Register));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write (16-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in PL011_Descriptor_Type;
                             Register   : in PL011_Register_Type;
                             Value      : in Unsigned_16
                            ) is
   begin
      Descriptor.Write_16 (Descriptor.Base_Address + PL011_Register_Offset (Register), Value);
   end Register_Write;

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
         exit when not To_FR (Register_Read (Descriptor, FR)).TXFF;
      end loop;
      Register_Write (Descriptor, DR, Value);
   end TX;

end PL011;
