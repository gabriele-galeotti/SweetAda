-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits.adb                                                                                                  --
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

package body Bits
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type Interfaces.Unsigned_8;
   use type Interfaces.Unsigned_16;
   use type Interfaces.Unsigned_32;
   use type Interfaces.Unsigned_64;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- P/NBooleans
   ----------------------------------------------------------------------------

   function Inactive
      (Value : in PBoolean)
      return Boolean
      is
   begin
      return Value = PFalse;
   end Inactive;

   function Active
      (Value : in PBoolean)
      return Boolean
      is
   begin
      return Value = PTrue;
   end Active;

   function Inactive
      (Value : in NBoolean)
      return Boolean
      is
   begin
      return Value = NFalse;
   end Inactive;

   function Active
      (Value : in NBoolean)
      return Boolean
      is
   begin
      return Value = NTrue;
   end Active;

   ----------------------------------------------------------------------------
   -- Map_Bitsize
   ----------------------------------------------------------------------------
   function Map_Bitsize
      (Size : in Positive)
      return Bitsize
      is
      Result : Bitsize;
   begin
      case Size is
         when 8      => Result := BIT8;
         when 16     => Result := BIT16;
         when 32     => Result := BIT32;
         when 64     => Result := BIT64;
         when others => Result := BITNONE;
      end case;
      return Result;
   end Map_Bitsize;

   ----------------------------------------------------------------------------
   -- Bits_1 <=> Boolean conversions
   ----------------------------------------------------------------------------

   function To_Boolean
      (Value : in Bits_1)
      return Boolean
      is
   begin
      return Value /= 0;
   end To_Boolean;

   function To_Bits_1
      (Value : in Boolean)
      return Bits_1
      is
      Result : Bits_1;
   begin
      if Value then
         Result := 1;
      else
         Result := 0;
      end if;
      return Result;
   end To_Bits_1;

   ----------------------------------------------------------------------------
   -- Bits_XX <=> Bitmap_XX conversions
   ----------------------------------------------------------------------------

   function To_B8
      (Value : in Bitmap_8)
      return Bits_8
      is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_8, Bits_8);
   begin
      return Convert (Value);
   end To_B8;

   function To_BM8
      (Value : in Bits_8)
      return Bitmap_8
      is
      function Convert is new Ada.Unchecked_Conversion (Bits_8, Bitmap_8);
   begin
      return Convert (Value);
   end To_BM8;

   function To_B16
      (Value : in Bitmap_16)
      return Bits_16
      is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_16, Bits_16);
   begin
      return Convert (Value);
   end To_B16;

   function To_BM16
      (Value : in Bits_16)
      return Bitmap_16
      is
      function Convert is new Ada.Unchecked_Conversion (Bits_16, Bitmap_16);
   begin
      return Convert (Value);
   end To_BM16;

   function To_B32
      (Value : in Bitmap_32)
      return Bits_32
      is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_32, Bits_32);
   begin
      return Convert (Value);
   end To_B32;

   function To_BM32
      (Value : in Bits_32)
      return Bitmap_32
      is
      function Convert is new Ada.Unchecked_Conversion (Bits_32, Bitmap_32);
   begin
      return Convert (Value);
   end To_BM32;

   function To_B64
      (Value : in Bitmap_64)
      return Bits_64
      is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_64, Bits_64);
   begin
      return Convert (Value);
   end To_B64;

   function To_BM64
      (Value : in Bits_64)
      return Bitmap_64
      is
      function Convert is new Ada.Unchecked_Conversion (Bits_64, Bitmap_64);
   begin
      return Convert (Value);
   end To_BM64;

   ----------------------------------------------------------------------------
   -- Unsigned_8 <=> Storage_Element conversions
   ----------------------------------------------------------------------------

   function To_U8
      (Value : in SSE.Storage_Element)
      return Interfaces.Unsigned_8
      is
      function Convert is new Ada.Unchecked_Conversion (SSE.Storage_Element, Interfaces.Unsigned_8);
   begin
      return Convert (Value);
   end To_U8;

   function To_SE
      (Value : in Interfaces.Unsigned_8)
      return SSE.Storage_Element
      is
      function Convert is new Ada.Unchecked_Conversion (Interfaces.Unsigned_8, SSE.Storage_Element);
   begin
      return Convert (Value);
   end To_SE;

   ----------------------------------------------------------------------------
   -- Unsigned_8 <=> Character conversions
   ----------------------------------------------------------------------------

   function To_U8
      (C : in Character)
      return Interfaces.Unsigned_8
      is
   begin
      return Character'Pos (C);
   end To_U8;

   function To_Ch
      (Value : in Interfaces.Unsigned_8)
      return Character
      is
   begin
      return Character'Val (Value);
   end To_Ch;

   ----------------------------------------------------------------------------
   -- Integer/Mod_Integer conversions and functions
   ----------------------------------------------------------------------------

   function To_Mod
      (Value : in Integer)
      return Mod_Integer
      is
      function Convert is new Ada.Unchecked_Conversion (Integer, Mod_Integer);
   begin
      return Convert (Value);
   end To_Mod;

   function To_Integer
      (Value : in Mod_Integer)
      return Integer
      is
      function Convert is new Ada.Unchecked_Conversion (Mod_Integer, Integer);
   begin
      return Convert (Value);
   end To_Integer;

   ----------------------------------------------------------------------------
   -- g_LSBitOn
   ----------------------------------------------------------------------------
   generic
      type Modular_Type is mod <>;
   function g_LSBitOn
      (V : in Modular_Type)
      return Boolean
      with Inline => True;
   function g_LSBitOn
      (V : in Modular_Type)
      return Boolean
      is
   begin
      return (V and 1) /= 0;
   end g_LSBitOn;

   ----------------------------------------------------------------------------
   -- g_MSBitOn
   ----------------------------------------------------------------------------
   generic
      type Modular_Type is mod <>;
   function g_MSBitOn
      (V : in Modular_Type)
      return Boolean
      with Inline => True;
   function g_MSBitOn
      (V : in Modular_Type)
      return Boolean
      is
   begin
      return (V and 2**(Modular_Type'Size - 1)) /= 0;
   end g_MSBitOn;

   ----------------------------------------------------------------------------
   -- L/MSBitOn
   ----------------------------------------------------------------------------

   function LSBitOn
      (Value : in Interfaces.Unsigned_8)
      return Boolean
      is
      function U8_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_8);
   begin
      return U8_LSBitOn (Value);
   end LSBitOn;

   function LSBitOn
      (Value : in Interfaces.Unsigned_16)
      return Boolean
      is
      function U16_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_16);
   begin
      return U16_LSBitOn (Value);
   end LSBitOn;

   function LSBitOn
      (Value : in Interfaces.Unsigned_32)
      return Boolean
      is
      function U32_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_32);
   begin
      return U32_LSBitOn (Value);
   end LSBitOn;

   function LSBitOn
      (Value : in Interfaces.Unsigned_64)
      return Boolean
      is
      function U64_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_64);
   begin
      return U64_LSBitOn (Value);
   end LSBitOn;

   function MSBitOn
      (Value : in Interfaces.Unsigned_8)
      return Boolean
      is
      function U8_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_8);
   begin
      return U8_MSBitOn (Value);
   end MSBitOn;

   function MSBitOn
      (Value : in Interfaces.Unsigned_16)
      return Boolean
      is
      function U16_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_16);
   begin
      return U16_MSBitOn (Value);
   end MSBitOn;

   function MSBitOn
      (Value : in Interfaces.Unsigned_32)
      return Boolean
      is
      function U32_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_32);
   begin
      return U32_MSBitOn (Value);
   end MSBitOn;

   function MSBitOn
      (Value : in Interfaces.Unsigned_64)
      return Boolean
      is
      function U64_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_64);
   begin
      return U64_MSBitOn (Value);
   end MSBitOn;

   ----------------------------------------------------------------------------
   -- BitXX
   ----------------------------------------------------------------------------

   -- Unsigned_8

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
   begin
      return Value and 16#01#;
   end Bit0;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
   begin
      return Value and 16#80#;
   end Bit7;

   function BitN
      (Value : Interfaces.Unsigned_8; NBit : Natural)
      return Boolean
      is
   begin
      return (Value and 2**NBit) /= 0;
   end BitN;

   function BitN
      (Value : Interfaces.Unsigned_8;
       NBit  : Natural;
       Bit   : Boolean)
      return Interfaces.Unsigned_8
      is
      Result : Interfaces.Unsigned_8;
   begin
      if Bit then
         Result := Value or 2**NBit;
      else
         Result := Value and (not Interfaces.Unsigned_8'(2**NBit));
      end if;
      return Result;
   end BitN;

   -- Unsigned_16

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      is
   begin
      return Interfaces.Unsigned_16 (Value and 16#01#);
   end Bit0;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      is
   begin
      return Interfaces.Unsigned_16 (Value and 16#80#);
   end Bit7;

   function BitN
      (Value : Interfaces.Unsigned_16; NBit : Natural)
      return Boolean
      is
      Result : Boolean;
   begin
      if BigEndian then
         Result := (Value and 2**(15 - (NBit mod 16))) /= 0;
      else
         Result := (Value and 2**(NBit mod 16)) /= 0;
      end if;
      return Result;
   end BitN;

   -- Unsigned_32

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_32
      is
   begin
      return Interfaces.Unsigned_32 (Value and 16#01#);
   end Bit0;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_32
      is
   begin
      return Interfaces.Unsigned_32 (Value and 16#80#);
   end Bit7;

   function BitN
      (Value : Interfaces.Unsigned_32; NBit : Natural)
      return Boolean
      is
      Result : Boolean;
   begin
      if BigEndian then
         Result := (Value and 2**(31 - (NBit mod 32))) /= 0;
      else
         Result := (Value and 2**(NBit mod 32)) /= 0;
      end if;
      return Result;
   end BitN;

   -- Unsigned_64

   function Bit0
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_64
      is
   begin
      return Interfaces.Unsigned_64 (Value and 16#01#);
   end Bit0;

   function Bit7
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_64
      is
   begin
      return Interfaces.Unsigned_64 (Value and 16#80#);
   end Bit7;

   function BitN
      (Value : Interfaces.Unsigned_64; NBit : Natural)
      return Boolean
      is
      Result : Boolean;
   begin
      if BigEndian then
         Result := (Value and 2**(63 - (NBit mod 64))) /= 0;
      else
         Result := (Value and 2**(NBit mod 64)) /= 0;
      end if;
      return Result;
   end BitN;

   ----------------------------------------------------------------------------
   -- L/M/N/O/P/Q/R/HByte
   ----------------------------------------------------------------------------

   -- Unsigned_16

   function LByte
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LByte;

   function HByte
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end HByte;

   -- Unsigned_32

   function LByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LByte;

   function MByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end MByte;

   function NByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 16) and Unsigned_8_Mask);
   end NByte;

   function HByte
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 24) and Unsigned_8_Mask);
   end HByte;

   -- Unsigned_64

   function LByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LByte;

   function MByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end MByte;

   function NByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 16) and Unsigned_8_Mask);
   end NByte;

   function OByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 24) and Unsigned_8_Mask);
   end OByte;

   function PByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 32) and Unsigned_8_Mask);
   end PByte;

   function QByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 40) and Unsigned_8_Mask);
   end QByte;

   function RByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 48) and Unsigned_8_Mask);
   end RByte;

   function HByte
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 56) and Unsigned_8_Mask);
   end HByte;

   ----------------------------------------------------------------------------
   -- L/HWord
   ----------------------------------------------------------------------------

   -- Unsigned_16

   function LWord
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LWord;

   function HWord
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end HWord;

   -- Unsigned_32

   function LWord
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_16
      is
   begin
      return Interfaces.Unsigned_16 (Value and Unsigned_16_Mask);
   end LWord;

   function HWord
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_16
      is
   begin
      return Interfaces.Unsigned_16 (ShR (Value, 16) and Unsigned_16_Mask);
   end HWord;

   -- Unsigned_64

   function LWord
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_32
      is
   begin
      return Interfaces.Unsigned_32 (Value and Unsigned_32_Mask);
   end LWord;

   function HWord
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_32
      is
   begin
      return Interfaces.Unsigned_32 (ShR (Value, 32) and Unsigned_32_Mask);
   end HWord;

   ----------------------------------------------------------------------------
   -- Make_Word
   ----------------------------------------------------------------------------

   function Make_Word
      (Value_H : Interfaces.Unsigned_8;
       Value_L : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_16
      is
   begin
      return ShL (Interfaces.Unsigned_16 (Value_H), 8) or Interfaces.Unsigned_16 (Value_L);
   end Make_Word;

   function Make_Word
      (Value_H : Interfaces.Unsigned_8;
       Value_N : Interfaces.Unsigned_8;
       Value_M : Interfaces.Unsigned_8;
       Value_L : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_32
      is
   begin
      return ShL (Interfaces.Unsigned_32 (Value_H), 24) or
             ShL (Interfaces.Unsigned_32 (Value_N), 16) or
             ShL (Interfaces.Unsigned_32 (Value_M),  8) or
                  Interfaces.Unsigned_32 (Value_L);
   end Make_Word;

   function Make_Word
      (Value_H : Interfaces.Unsigned_16;
       Value_L : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_32
      is
   begin
      return ShL (Interfaces.Unsigned_32 (Value_H), 16) or Interfaces.Unsigned_32 (Value_L);
   end Make_Word;

   function Make_Word
      (Value_H : Interfaces.Unsigned_32;
       Value_L : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_64
      is
   begin
      return ShL (Interfaces.Unsigned_64 (Value_H), 32) or Interfaces.Unsigned_64 (Value_L);
   end Make_Word;

   ----------------------------------------------------------------------------
   -- BitMask_XX
   ----------------------------------------------------------------------------

   function BitMask_8
      (MSb    : Bits_3;
       LSb    : Bits_3;
       Negate : Boolean := False)
      return Interfaces.Unsigned_8
      is
      Value : Interfaces.Unsigned_8;
      M     : Natural := Natural (MSb);
      L     : Natural := Natural (LSb);
   begin
      if BigEndian then
         M := 7 - @;
         L := 7 - @;
      end if;
      Value := (2**M - 2**L) or 2**M;
      return (if Negate then not Value else Value);
   end BitMask_8;

   function BitMask_16
      (MSb    : Bits_4;
       LSb    : Bits_4;
       Negate : Boolean := False)
      return Interfaces.Unsigned_16
      is
      Value : Interfaces.Unsigned_16;
      M     : Natural := Natural (MSb);
      L     : Natural := Natural (LSb);
   begin
      if BigEndian then
         M := 15 - @;
         L := 15 - @;
      end if;
      Value := (2**M - 2**L) or 2**M;
      return (if Negate then not Value else Value);
   end BitMask_16;

   function BitMask_32
      (MSb    : Bits_5;
       LSb    : Bits_5;
       Negate : Boolean := False)
      return Interfaces.Unsigned_32
      is
      Value : Interfaces.Unsigned_32;
      M     : Natural := Natural (MSb);
      L     : Natural := Natural (LSb);
   begin
      if BigEndian then
         M := 31 - @;
         L := 31 - @;
      end if;
      Value := (2**M - 2**L) or 2**M;
      return (if Negate then not Value else Value);
   end BitMask_32;

   function BitMask_64
      (MSb    : Bits_6;
       LSb    : Bits_6;
       Negate : Boolean := False)
      return Interfaces.Unsigned_64
      is
      Value : Interfaces.Unsigned_64;
      M     : Natural := Natural (MSb);
      L     : Natural := Natural (LSb);
   begin
      if BigEndian then
         M := 63 - @;
         L := 63 - @;
      end if;
      Value := (2**M - 2**L) or 2**M;
      return (if Negate then not Value else Value);
   end BitMask_64;

   ----------------------------------------------------------------------------
   -- Byte_Swap
   ----------------------------------------------------------------------------

   function Byte_Swap_8
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
   separate;

   function Byte_Swap_16
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      is
   separate;

   function Byte_Swap_32
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32 is
   separate;

   function Byte_Swap_64
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      is
   separate;

   ----------------------------------------------------------------------------
   -- Word_Swap
   ----------------------------------------------------------------------------

   function Word_Swap
      (Value : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
   begin
      return Value;
   end Word_Swap;

   function Word_Swap
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      is
   begin
      return Byte_Swap (Value);
   end Word_Swap;

   function Word_Swap
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      is
   begin
      return ShR (Value and 16#FFFF_0000#, 16) or
             ShL (Value and 16#0000_FFFF#, 16);
   end Word_Swap;

   function Word_Swap
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      is
   begin
      return ShR (Value and 16#FFFF_FFFF_0000_0000#, 32) or
             ShL (Value and 16#0000_0000_FFFF_FFFF#, 32);
   end Word_Swap;

   ----------------------------------------------------------------------------
   -- CPUE to/from BE/LE
   ----------------------------------------------------------------------------

   -- Unsigned_16

   function CPUE_To_BE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      is
      Result : Interfaces.Unsigned_16;
   begin
      if BigEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end CPUE_To_BE;

   function BE_To_CPUE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      is
      Result : Interfaces.Unsigned_16;
   begin
      if BigEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end BE_To_CPUE;

   function CPUE_To_LE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      is
      Result : Interfaces.Unsigned_16;
   begin
      if LittleEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end CPUE_To_LE;

   function LE_To_CPUE
      (Value : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      is
      Result : Interfaces.Unsigned_16;
   begin
      if LittleEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end LE_To_CPUE;

   -- Unsigned_32

   function CPUE_To_BE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      is
      Result : Interfaces.Unsigned_32;
   begin
      if BigEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end CPUE_To_BE;

   function BE_To_CPUE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      is
      Result : Interfaces.Unsigned_32;
   begin
      if BigEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end BE_To_CPUE;

   function CPUE_To_LE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      is
      Result : Interfaces.Unsigned_32;
   begin
      if LittleEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end CPUE_To_LE;

   function LE_To_CPUE
      (Value : Interfaces.Unsigned_32)
      return Interfaces.Unsigned_32
      is
      Result : Interfaces.Unsigned_32;
   begin
      if LittleEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end LE_To_CPUE;

   -- Unsigned_64

   function CPUE_To_BE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      is
      Result : Interfaces.Unsigned_64;
   begin
      if BigEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end CPUE_To_BE;

   function BE_To_CPUE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      is
      Result : Interfaces.Unsigned_64;
   begin
      if BigEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end BE_To_CPUE;

   function CPUE_To_LE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      is
      Result : Interfaces.Unsigned_64;
   begin
      if LittleEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end CPUE_To_LE;

   function LE_To_CPUE
      (Value : Interfaces.Unsigned_64)
      return Interfaces.Unsigned_64
      is
      Result : Interfaces.Unsigned_64;
   begin
      if LittleEndian then
         Result := Value;
      else
         Result := Byte_Swap (Value);
      end if;
      return Result;
   end LE_To_CPUE;

   ----------------------------------------------------------------------------
   -- Byte_Reverse
   ----------------------------------------------------------------------------
   function Byte_Reverse
      (Value : in Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
   separate;

end Bits;
