-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console.adb                                                                                               --
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
   use type SSE.Storage_Offset;
   use type SSE.Integer_Address;
   use type Interfaces.Unsigned_8;
   use type Interfaces.C.char;
   use type Interfaces.C.size_t;
   use type Bits.Bits_1;

   package ISO88591 renames Ada.Characters.Latin_1;

   NewLine : constant String := ISO88591.CR & ISO88591.LF;

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
      C := ISO88591.NUL;
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
   -- Print_String
   ----------------------------------------------------------------------------
   procedure Print_String (
                           S     : in String;
                           Limit : in Natural := Maximum_String_Length;
                           NL    : in Boolean := False
                          ) is
   separate;

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
   -- Print (Bits_1)
   ----------------------------------------------------------------------------
   procedure Print (
                    Value  : in Bits.Bits_1;
                    NL     : in Boolean := False;
                    Prefix : in String := "";
                    Suffix : in String := ""
                   ) is
   begin
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print (Character'(if Value = 1 then '1' else '0'));
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
   -- Print_Integer_Address
   ----------------------------------------------------------------------------
   procedure Print_Integer_Address (
                                    Value  : in SSE.Integer_Address;
                                    NL     : in Boolean := False;
                                    Prefix : in String := "";
                                    Suffix : in String := ""
                                   ) is
   separate;

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
   -- Print_Integer
   ----------------------------------------------------------------------------
   procedure Print_Integer (
                            Value  : in Integer;
                            NL     : in Boolean := False;
                            Prefix : in String := "";
                            Suffix : in String := ""
                           ) is
   separate;

   ----------------------------------------------------------------------------
   -- Print_sizet
   ----------------------------------------------------------------------------
   procedure Print_sizet (
                          s      : in Interfaces.C.size_t;
                          NL     : in Boolean := False;
                          Prefix : in String := "";
                          Suffix : in String := ""
                         ) is
   separate;

   ----------------------------------------------------------------------------
   -- Print_BitImage
   ----------------------------------------------------------------------------
   procedure Print_BitImage (
                             Value  : in Interfaces.Unsigned_8;
                             NL     : in Boolean := False;
                             Prefix : in String := "";
                             Suffix : in String := ""
                            ) is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Byte_Array
   ----------------------------------------------------------------------------
   -- Limit = 0 --> print whole array
   ----------------------------------------------------------------------------
   procedure Print_Byte_Array (
                               ByteArray : in Bits.Byte_Array;
                               Limit     : in Natural := 0;
                               NL        : in Boolean := False;
                               Prefix    : in String := "";
                               Separator : in Character := ' '
                              ) is
   separate;

   ----------------------------------------------------------------------------
   -- Print_ASCIIZ_String
   ----------------------------------------------------------------------------
   procedure Print_ASCIIZ_String (
                                  String_Ptr : in System.Address;
                                  NL         : in Boolean := False;
                                  Prefix     : in String := "";
                                  Suffix     : in String := ""
                                 ) is
   separate;

   ----------------------------------------------------------------------------
   -- Print_Memory
   ----------------------------------------------------------------------------
   procedure Print_Memory (
                           Start_Address : in System.Address;
                           Data_Size     : in Bits.Bytesize;
                           Row_Size      : in Row_Size_Type := 16
                          ) is
   separate;

   ----------------------------------------------------------------------------
   -- TTY_Setup
   ----------------------------------------------------------------------------
   -- __INF__ xterm does not seem to correctly recognize a CSI sequence
   ----------------------------------------------------------------------------
   procedure TTY_Setup is
      -- ESC_CSI : constant String := ISO88591.CSI;
      ESC_CSI : constant String := ISO88591.ESC & "[";
   begin
      Print (ESC_CSI & "7h");   -- enable line wrap
      Print (ESC_CSI & "2J");   -- clear terminal screen
      Print (ESC_CSI & "1;1H"); -- reset cursor position at (1,1)
   end TTY_Setup;

end Console;
