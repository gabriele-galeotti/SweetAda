-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console.adb                                                                                               --
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

with Ada.Characters.Latin_1;
with Ada.Unchecked_Conversion;
with LLutils;

package body Console is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type System.Address;
   use type System.Storage_Elements.Storage_Offset;
   use type SSE.Integer_Address;
   use type Interfaces.Unsigned_8;
   use type Interfaces.C.char;
   use type Interfaces.C.size_t;

   package ISO88591 renames Ada.Characters.Latin_1;

   NewLine : constant String := ISO88591.CR & ISO88591.LF;

   subtype Decimal_Digit_Type is Natural range 0 .. 9;

   function To_Ch (Digit : Decimal_Digit_Type) return Character with
      Inline => True;
   procedure Print_UnsignedHex8 (Value : in Interfaces.Unsigned_8);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- To_Ch
   ----------------------------------------------------------------------------
   function To_Ch (Digit : Decimal_Digit_Type) return Character is
   begin
      return Character'Val (Character'Pos ('0') + Digit);
   end To_Ch;

   ----------------------------------------------------------------------------
   -- Console "null" functions
   ----------------------------------------------------------------------------

   procedure Console_Null_Write (C : in Character) is
      pragma Unreferenced (C);
   begin
      null;
   end Console_Null_Write;

   procedure Console_Null_Read (C : out Character) is
   begin
      C := Ada.Characters.Latin_1.NUL;
   end Console_Null_Read;

   ----------------------------------------------------------------------------
   -- Print (Character)
   ----------------------------------------------------------------------------
   procedure Print (C : in Character) is
   begin
      Console_Descriptor.Write (C);
   end Print;

   ----------------------------------------------------------------------------
   -- Print (Interfaces.C.char)
   ----------------------------------------------------------------------------
   procedure Print (c : in Interfaces.C.char) is
      -- borrowed from i-c.adb, avoid using a non-ZFP unit
      function To_Ada (Item : Interfaces.C.char) return Character;
      function To_Ada (Item : Interfaces.C.char) return Character is
      begin
         return Character'Val (Interfaces.C.char'Pos (Item));
      end To_Ada;
   begin
      Print (To_Ada (c));
   end Print;

   ----------------------------------------------------------------------------
   -- Print_NewLine
   ----------------------------------------------------------------------------
   procedure Print_NewLine is
   begin
      for Index in NewLine'Range loop
         Print (NewLine (Index));
      end loop;
   end Print_NewLine;

   ----------------------------------------------------------------------------
   -- Print (String)
   ----------------------------------------------------------------------------
   procedure Print (
                    S     : in String;
                    Limit : in Natural := Maximum_String_Length;
                    NL    : in Boolean := False
                   ) is
      String_Index_Limit : Integer;
   begin
      if S'Length > Limit then
         String_Index_Limit := S'First + Limit;
      else
         String_Index_Limit := S'Last;
      end if;
      for Index in S'First .. String_Index_Limit loop
         Print (S (Index));
      end loop;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print (Boolean)
   ----------------------------------------------------------------------------
   procedure Print (
                    Value  : in Boolean;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print (Character'(if Value then 'T' else 'F'));
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print_UnsignedHex8 (helper subprogram)
   ----------------------------------------------------------------------------
   procedure Print_UnsignedHex8 (Value : in Interfaces.Unsigned_8) is
      C : Character;
   begin
      LLutils.U8_To_HexDigit (Value => Value, MSD => True, LCase => False, C => C);
      Print (C);
      LLutils.U8_To_HexDigit (Value => Value, MSD => False, LCase => False, C => C);
      Print (C);
   end Print_UnsignedHex8;

   ----------------------------------------------------------------------------
   -- Print (Unsigned_XX)
   ----------------------------------------------------------------------------

   -- Unsigned_8
   procedure Print (
                    Value  : in Interfaces.Unsigned_8;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print_UnsignedHex8 (Value);
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   -- Unsigned_16
   procedure Print (
                    Value  : in Interfaces.Unsigned_16;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print (Bits.HWord (Value));
      Print (Bits.LWord (Value));
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   -- Unsigned_32
   procedure Print (
                    Value  : in Interfaces.Unsigned_32;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print (Bits.HWord (Value));
      Print (Bits.LWord (Value));
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   -- Unsigned_64
   procedure Print (
                    Value  : in Interfaces.Unsigned_64;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print (Bits.HWord (Value));
      Print (Bits.LWord (Value));
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print (Integer_Address)
   ----------------------------------------------------------------------------
   procedure Print (
                    Value  : in SSE.Integer_Address;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
      IAddress        : SSE.Integer_Address := Value;
      MDigits         : constant Natural := (SSE.Integer_Address'Size + 3) / 4;
      Address_Digit   : Interfaces.Unsigned_8;
      Address_Literal : String (1 .. MDigits);
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      for Index in reverse 1 .. MDigits loop
         Address_Digit := Interfaces.Unsigned_8 (IAddress mod 2**4);
         LLutils.U8_To_HexDigit (
                                 Value => Address_Digit,
                                 MSD   => False,
                                 LCase => False,
                                 C     => Address_Literal (Index)
                                );
         IAddress := IAddress / 2**4;
      end loop;
      Print (Address_Literal);
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print (Address)
   ----------------------------------------------------------------------------
   procedure Print (
                    Value  : in System.Address;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      Print (SSE.To_Integer (Value), NL, Prefix, Suffix);
   end Print;

   ----------------------------------------------------------------------------
   -- Print (Integer)
   ----------------------------------------------------------------------------
   procedure Print (
                    Value  : in Integer;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
      subtype Negative_Integer is Integer range Integer'First .. -1;
      subtype Positive_Integer is Integer range 0 .. Integer'Last;
      Negative_Sign  : Boolean := False;
      Number         : Positive_Integer;
      Number_Literal : String (1 .. 16) := (others => ' ');
      Literal_Index  : Natural;
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Literal_Index := Number_Literal'Last;
      if Value < 0 then
         Negative_Sign := True;
         declare
            NNumber : Negative_Integer := Value;
         begin
            -- handle 2's complement off-range asymmetric negative numbers
            -- by prescaling their values
            while NNumber < -Integer'Last loop
               Number_Literal (Literal_Index) := To_Ch (-(NNumber rem 10));
               Literal_Index := Literal_Index - 1;
               NNumber := NNumber / 10;
            end loop;
            -- now conversion to positive value is safe
            Number := -NNumber;
         end;
      else
         Number := Value;
      end if;
      -- build literal string
      for Index in reverse 2 .. Literal_Index loop
         Number_Literal (Index) := To_Ch (Number rem 10);
         Number := Number / 10;
         if Number = 0 then
            Literal_Index := Index;
            exit;
         end if;
      end loop;
      -- add negative sign
      if Negative_Sign then
         Literal_Index := Literal_Index - 1;
         Number_Literal (Literal_Index) := '-';
      end if;
      Print (Number_Literal (Literal_Index .. Number_Literal'Last));
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print (size_t)
   ----------------------------------------------------------------------------
   procedure Print (
                    s      : in Interfaces.C.size_t;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
      Number         : Interfaces.C.size_t := s;
      Number_Literal : String (1 .. 16);
      Literal_Index  : Natural := 0;
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      for Index in reverse Number_Literal'Range loop
         Number_Literal (Index) := To_Ch (Decimal_Digit_Type (Number mod 10));
         Number := Number / 10;
         if Number = 0 then
            Literal_Index := Index;
            exit;
         end if;
      end loop;
      Print (Number_Literal (Literal_Index .. Number_Literal'Last));
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print_BitImage
   ----------------------------------------------------------------------------
   procedure Print_BitImage (
                             Value  : in Interfaces.Unsigned_8;
                             NL     : in Boolean := False;
                             Prefix : in String := "";
                             Suffix : in String := ""
                            ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      for Index in reverse 0 .. Interfaces.Unsigned_8'Size - 1 loop
         if (Value and Interfaces.Shift_Left (1, Index)) /= 0 then
            Print (Character'('1'));
         else
            Print (Character'('0'));
         end if;
      end loop;
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print_BitImage;

   ----------------------------------------------------------------------------
   -- Print (ByteArray)
   ----------------------------------------------------------------------------
   -- Limit = 0 --> print whole array
   ----------------------------------------------------------------------------
   procedure Print (
                    ByteArray : in Bits.Byte_Array;
                    Limit     : in Natural := 0;
                    NL        : in Boolean := False;
                    Prefix    : in String := "";
                    Separator : in Character := ' '
                   ) is
      Index_Upper : Natural range ByteArray'First .. ByteArray'Last;
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      if Limit = 0 then
         Index_Upper := ByteArray'Last;
      else
         Index_Upper := Limit;
      end if;
      for Index in ByteArray'First .. Index_Upper loop
         Print_UnsignedHex8 (ByteArray (Index));
         if Index /= Index_Upper then
            Print (Separator);
         end if;
      end loop;
      if NL then
         Print_NewLine;
      end if;
   end Print;

   ----------------------------------------------------------------------------
   -- Print_ASCIIZ_String
   ----------------------------------------------------------------------------
   -- __REF__ http://www.adapower.com/index.php?Command=Class&ClassID=Advanced&CID=213
   ----------------------------------------------------------------------------
   procedure Print_ASCIIZ_String (
                                  String_Ptr : in System.Address;
                                  NL         : in Boolean := False;
                                  Prefix     : in String := "";
                                  Suffix     : in String := ""
                                 ) is
      String_Address : System.Address := String_Ptr;
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      if String_Address /= System.Null_Address then
         for Index in Interfaces.C.size_t range 0 .. Maximum_String_Length - 1 loop
            declare
               c : aliased Interfaces.C.char with
                  Address    => String_Address,
                  Import     => True,
                  Convention => Ada;
            begin
               exit when c = Interfaces.C.nul;
               Print (c);
            end;
            String_Address := String_Address + 1;
         end loop;
      end if;
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print_ASCIIZ_String;

   ----------------------------------------------------------------------------
   -- Print_Memory
   ----------------------------------------------------------------------------
   procedure Print_Memory (
                           Start_Address : in System.Address;
                           Data_Size     : in Bits.Bytesize;
                           Row_Size      : in Row_Size_Type := 16
                          ) is
      IAddress   : SSE.Integer_Address;
      IAddress_H : SSE.Integer_Address; -- row starting address
      IAddress_L : SSE.Integer_Address; -- byte offset in a row
      NBytes     : Bits.Bytesize;
      Item_Count : Natural;
      NBytes_Row : Bits.Bytesize;
      ASCII_Syms : String (1 .. Integer (Row_Size_Type'Last));
   begin
      IAddress   := SSE.To_Integer (Start_Address);
      IAddress_L := IAddress mod SSE.Integer_Address (Row_Size);
      IAddress_H := IAddress - IAddress_L;
      NBytes     := Data_Size;
      loop
         Print (IAddress_H, Suffix => ":");
         Item_Count := 0;
         -- compute maximum # of bytes to print in this row
         NBytes_Row := Bits.Bytesize (Row_Size) - Bits.Bytesize (IAddress_L);
         -- clamp to (possibly 0) upper limit
         if NBytes_Row > NBytes then
            NBytes_Row := NBytes;
         end if;
         -- pad with spaces until start of data
         while Item_Count < Natural (IAddress_L) loop
            Item_Count := Item_Count + 1;
            Print ("   ");
            ASCII_Syms (Item_Count) := ' ';
         end loop;
         -- print a sequence of bytes
         for Byte_Offset in IAddress_L .. IAddress_L + SSE.Integer_Address (NBytes_Row) - 1 loop
            declare
               Byte : Interfaces.Unsigned_8 with
                  Address  => SSE.To_Address (IAddress_H + Byte_Offset),
                  Volatile => True;
            begin
               Item_Count := Item_Count + 1;
               Print (Byte, Prefix => " ");
               if Byte in 16#20# .. 16#7F# then
                  ASCII_Syms (Item_Count) := Bits.To_Ch (Byte);
               else
                  ASCII_Syms (Item_Count) := '.';
               end if;
            end;
         end loop;
         -- pad with spaces until end of row
         while Item_Count < Natural (Row_Size) loop
            Item_Count := Item_Count + 1;
            Print ("   ");
            ASCII_Syms (Item_Count) := ' ';
         end loop;
         -- print ASCII encoding
         Print ("    ");
         Print (ASCII_Syms (1 .. Item_Count));
         -- close row
         Print_NewLine;
         -- compute address of next block of bytes
         IAddress_H := IAddress_H + SSE.Integer_Address (Row_Size);
         exit when IAddress_H >= IAddress + SSE.Integer_Address (Data_Size);
         -- update # of bytes remaining
         NBytes := NBytes - NBytes_Row;
         -- re-start at offset 0
         IAddress_L := 0;
      end loop;
   end Print_Memory;

   ----------------------------------------------------------------------------
   -- TTY_Setup
   ----------------------------------------------------------------------------
   -- __REF__ http://www.termsys.demon.co.uk/vtansi.htm
   -- __REF__ https://www.csie.ntu.edu.tw/~r92094/c++/VT100.html
   ----------------------------------------------------------------------------
   procedure TTY_Setup is
   begin
      -- Print (ISO88591.CSI & "7h");   -- enable line wrap
      -- Print (ISO88591.CSI & "2J");   -- clear terminal screen
      -- Print (ISO88591.CSI & "1;1H"); -- reset cursor position at (1,1)
      Print (ISO88591.ESC & "[7h");   -- enable line wrap
      Print (ISO88591.ESC & "[2J");   -- clear terminal screen
      Print (ISO88591.ESC & "[1;1H"); -- reset cursor position at (1,1)
   end TTY_Setup;

end Console;
