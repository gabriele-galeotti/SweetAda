-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console.adb                                                                                               --
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

with Definitions;

package body Console
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type System.Address;
   use type SSE.Storage_Offset;
   use type SSE.Integer_Address;
   use type Interfaces.Unsigned_8;
   use type Interfaces.C.char;
   use type Interfaces.C.size_t;
   use Definitions;
   use type Bits.Bits_1;

   -- helper subprogram
   procedure Print_UnsignedHex8
      (Value : in Interfaces.Unsigned_8);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console "null" functions
   ----------------------------------------------------------------------------

   procedure Console_Null_Write
      (C : in Character)
      is
      pragma Unreferenced (C);
   begin
      null;
   end Console_Null_Write;

   procedure Console_Null_Read
      (C : out Character)
      is
   begin
      C := ISO88591.NUL;
   end Console_Null_Read;

   ----------------------------------------------------------------------------
   -- Print (Character)
   ----------------------------------------------------------------------------
   procedure Print
      (C : in Character)
      is
   begin
      Console_Descriptor.Write (C);
   end Print;

   ----------------------------------------------------------------------------
   -- Print (Interfaces.C.char)
   ----------------------------------------------------------------------------
   procedure Print
      (c : in Interfaces.C.char)
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_NewLine
   ----------------------------------------------------------------------------
   procedure Print_NewLine
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_String
   ----------------------------------------------------------------------------
   procedure Print_String
      (S     : in String;
       Limit : in Natural := Maximum_String_Length;
       NL    : in Boolean := False)
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print (Boolean)
   ----------------------------------------------------------------------------
   procedure Print_Boolean
      (Value  : in Boolean;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print (Bits_1)
   ----------------------------------------------------------------------------
   procedure Print_Bits1
      (Value  : in Bits.Bits_1;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_UnsignedHex8 (helper subprogram)
   ----------------------------------------------------------------------------
   procedure Print_UnsignedHex8
      (Value : in Interfaces.Unsigned_8)
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Unsigned8
   ----------------------------------------------------------------------------
   procedure Print_Unsigned8
      (Value  : in Interfaces.Unsigned_8;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Unsigned16
   ----------------------------------------------------------------------------
   procedure Print_Unsigned16
      (Value  : in Interfaces.Unsigned_16;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Unsigned32
   ----------------------------------------------------------------------------
   procedure Print_Unsigned32
      (Value  : in Interfaces.Unsigned_32;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Unsigned64
   ----------------------------------------------------------------------------
   procedure Print_Unsigned64
      (Value  : in Interfaces.Unsigned_64;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Integer_Address
   ----------------------------------------------------------------------------
   procedure Print_Integer_Address
      (Value  : in SSE.Integer_Address;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Address
   ----------------------------------------------------------------------------
   procedure Print_Address
      (Value  : in System.Address;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Integer
   ----------------------------------------------------------------------------
   procedure Print_Integer
      (Value  : in Integer;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_sizet
   ----------------------------------------------------------------------------
   procedure Print_sizet
      (s      : in Interfaces.C.size_t;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_BitImage
   ----------------------------------------------------------------------------
   procedure Print_BitImage
      (Value  : in Interfaces.Unsigned_8;
       NL     : in Boolean := False;
       Prefix : in String := "";
       Suffix : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Byte_Array
   ----------------------------------------------------------------------------
   procedure Print_Byte_Array
      (ByteArray : in Bits.Byte_Array;
       Limit     : in Natural := 0;
       NL        : in Boolean := False;
       Prefix    : in String := "";
       Separator : in Character := ' ')
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_ASCIIZ_String
   ----------------------------------------------------------------------------
   procedure Print_ASCIIZ_String
      (String_Address : in System.Address;
       NL             : in Boolean := False;
       Prefix         : in String := "";
       Suffix         : in String := "")
      is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Memory
   ----------------------------------------------------------------------------
   procedure Print_Memory
      (Start_Address : in System.Address;
       Data_Size     : in Bits.Bytesize;
       Row_Size      : in Row_Size_Type := 16)
      is
   separate;

end Console;
