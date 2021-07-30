-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits.adb                                                                                                  --
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

package body Bits is

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
   -- Map_Bitsize
   ----------------------------------------------------------------------------
   function Map_Bitsize (Size : Positive) return Bitsize is
   begin
      case Size is
         when 8      => return BIT8;
         when 16     => return BIT16;
         when 32     => return BIT32;
         when 64     => return BIT64;
         when others => return BITNONE;
      end case;
   end Map_Bitsize;

   ----------------------------------------------------------------------------
   -- Bits_1 <=> Boolean conversions
   ----------------------------------------------------------------------------

   function To_Boolean (Value : Bits_1) return Boolean is
   begin
      return Value /= 0;
   end To_Boolean;

   function To_Bits_1 (Value : Boolean) return Bits_1 is
   begin
      if Value then
         return 1;
      else
         return 0;
      end if;
   end To_Bits_1;

   ----------------------------------------------------------------------------
   -- Bits_XX <=> Bitmap_XX conversions
   ----------------------------------------------------------------------------

   function To_B8 (Value : Bitmap_8) return Bits_8 is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_8, Bits_8);
   begin
      return Convert (Value);
   end To_B8;

   function To_BM8 (Value : Bits_8) return Bitmap_8 is
      function Convert is new Ada.Unchecked_Conversion (Bits_8, Bitmap_8);
   begin
      return Convert (Value);
   end To_BM8;

   function To_B16 (Value : Bitmap_16) return Bits_16 is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_16, Bits_16);
   begin
      return Convert (Value);
   end To_B16;

   function To_BM16 (Value : Bits_16) return Bitmap_16 is
      function Convert is new Ada.Unchecked_Conversion (Bits_16, Bitmap_16);
   begin
      return Convert (Value);
   end To_BM16;

   function To_B32 (Value : Bitmap_32) return Bits_32 is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_32, Bits_32);
   begin
      return Convert (Value);
   end To_B32;

   function To_BM32 (Value : Bits_32) return Bitmap_32 is
      function Convert is new Ada.Unchecked_Conversion (Bits_32, Bitmap_32);
   begin
      return Convert (Value);
   end To_BM32;

   function To_B64 (Value : Bitmap_64) return Bits_64 is
      function Convert is new Ada.Unchecked_Conversion (Bitmap_64, Bits_64);
   begin
      return Convert (Value);
   end To_B64;

   function To_BM64 (Value : Bits_64) return Bitmap_64 is
      function Convert is new Ada.Unchecked_Conversion (Bits_64, Bitmap_64);
   begin
      return Convert (Value);
   end To_BM64;

   ----------------------------------------------------------------------------
   -- Unsigned_8 <=> Storage_Element conversions
   ----------------------------------------------------------------------------

   function To_U8 (Value : SSE.Storage_Element) return Interfaces.Unsigned_8 is
      function Convert is new Ada.Unchecked_Conversion (SSE.Storage_Element, Interfaces.Unsigned_8);
   begin
      return Convert (Value);
   end To_U8;

   function To_SE (Value : Interfaces.Unsigned_8) return SSE.Storage_Element is
      function Convert is new Ada.Unchecked_Conversion (Interfaces.Unsigned_8, SSE.Storage_Element);
   begin
      return Convert (Value);
   end To_SE;

   ----------------------------------------------------------------------------
   -- Unsigned_8 <=> Character conversions
   ----------------------------------------------------------------------------

   function To_U8 (C : Character) return Interfaces.Unsigned_8 is
   begin
      return Character'Pos (C);
   end To_U8;

   function To_Ch (Value : Interfaces.Unsigned_8) return Character is
   begin
      return Character'Val (Value);
   end To_Ch;

   ----------------------------------------------------------------------------
   -- Integer/Mod_Integer conversions and functions
   ----------------------------------------------------------------------------

   function To_Mod (Value : Integer) return Mod_Integer is
      function Convert is new Ada.Unchecked_Conversion (Integer, Mod_Integer);
   begin
      return Convert (Value);
   end To_Mod;

   function To_Integer (Value : Mod_Integer) return Integer is
      function Convert is new Ada.Unchecked_Conversion (Mod_Integer, Integer);
   begin
      return Convert (Value);
   end To_Integer;

   function Suppress_LSB (Value : Integer; Order : Integer_Bit_Number) return Integer is
   begin
      return To_Integer (To_Mod (Value) and not (2**(Order + 1) - 1));
   end Suppress_LSB;

   ----------------------------------------------------------------------------
   -- Byte_Reverse
   ----------------------------------------------------------------------------
   -- Reverse the bit pattern of a byte.
   ----------------------------------------------------------------------------
   function Byte_Reverse (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 is
   separate;

   ----------------------------------------------------------------------------
   -- FirstMSBit
   ----------------------------------------------------------------------------
   -- Find the first MS bit set.
   ----------------------------------------------------------------------------
   function FirstMSBit (Value : Interfaces.Unsigned_8) return Integer is
      -- table of floor(Log2(x))
      MSBitArray : constant array (Interfaces.Unsigned_8 range <>) of Integer :=
         (
          -1, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3,
           4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
           5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
           5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
           6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
           6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
           6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
           6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
           7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7
         );
   begin
      return MSBitArray (Value);
   end FirstMSBit;

   ----------------------------------------------------------------------------
   -- g_LSBitOn
   ----------------------------------------------------------------------------
   generic
      type Modular_Type is mod <>;
   function g_LSBitOn (V : Modular_Type) return Boolean;
   pragma Inline (g_LSBitOn);
   function g_LSBitOn (V : Modular_Type) return Boolean is
   begin
      return (V and 1) /= 0;
   end g_LSBitOn;

   ----------------------------------------------------------------------------
   -- g_MSBitOn
   ----------------------------------------------------------------------------
   generic
      type Modular_Type is mod <>;
   function g_MSBitOn (V : Modular_Type) return Boolean;
   pragma Inline (g_MSBitOn);
   function g_MSBitOn (V : Modular_Type) return Boolean is
   begin
      return (V and 2**(Modular_Type'Size - 1)) /= 0;
   end g_MSBitOn;

   ----------------------------------------------------------------------------
   -- L/MSBitOn
   ----------------------------------------------------------------------------

   function LSBitOn (Value : Interfaces.Unsigned_8) return Boolean is
      function U8_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_8);
   begin
      return U8_LSBitOn (Value);
   end LSBitOn;

   function LSBitOn (Value : Interfaces.Unsigned_16) return Boolean is
      function U16_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_16);
   begin
      return U16_LSBitOn (Value);
   end LSBitOn;

   function LSBitOn (Value : Interfaces.Unsigned_32) return Boolean is
      function U32_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_32);
   begin
      return U32_LSBitOn (Value);
   end LSBitOn;

   function LSBitOn (Value : Interfaces.Unsigned_64) return Boolean is
      function U64_LSBitOn is new g_LSBitOn (Interfaces.Unsigned_64);
   begin
      return U64_LSBitOn (Value);
   end LSBitOn;

   function MSBitOn (Value : Interfaces.Unsigned_8) return Boolean is
      function U8_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_8);
   begin
      return U8_MSBitOn (Value);
   end MSBitOn;

   function MSBitOn (Value : Interfaces.Unsigned_16) return Boolean is
      function U16_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_16);
   begin
      return U16_MSBitOn (Value);
   end MSBitOn;

   function MSBitOn (Value : Interfaces.Unsigned_32) return Boolean is
      function U32_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_32);
   begin
      return U32_MSBitOn (Value);
   end MSBitOn;

   function MSBitOn (Value : Interfaces.Unsigned_64) return Boolean is
      function U64_MSBitOn is new g_MSBitOn (Interfaces.Unsigned_64);
   begin
      return U64_MSBitOn (Value);
   end MSBitOn;

   ----------------------------------------------------------------------------
   -- BitXX
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 is
   begin
      return Value and 16#01#;
   end Bit0;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 is
   begin
      return Value and 16#80#;
   end Bit7;
   function BitN (Value : Interfaces.Unsigned_8; NBit : Natural) return Boolean is
   begin
      return (Value and 2**NBit) /= 0;
   end BitN;
   function BitN (
                  Value : Interfaces.Unsigned_8;
                  NBit  : Natural;
                  Bit   : Boolean
                 ) return Interfaces.Unsigned_8 is
   begin
      if Bit then
         return Value or 2**NBit;
      else
         return Value and (not Interfaces.Unsigned_8'(2**NBit));
      end if;
   end BitN;
   function EDBitN (Value : Interfaces.Unsigned_8; NBit : Natural) return Boolean is
   begin
      if BigEndian then
         return (Value and 2**(7 - NBit)) /= 0;
      else
         return (Value and 2**NBit) /= 0;
      end if;
   end EDBitN;
   function EDBitN (
                    Value : Interfaces.Unsigned_8;
                    NBit  : Natural;
                    Bit   : Boolean
                   ) return Interfaces.Unsigned_8 is
   begin
      if BigEndian then
         if Bit then
            return Value or 2**(7 - NBit);
         else
            return Value and (not Interfaces.Unsigned_8'(2**(7 - NBit)));
         end if;
      else
         if Bit then
            return Value or 2**NBit;
         else
            return Value and (not Interfaces.Unsigned_8'(2**NBit));
         end if;
      end if;
   end EDBitN;

   -- Unsigned_16
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_16 is
   begin
      return Interfaces.Unsigned_16 (Value and 16#01#);
   end Bit0;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_16 is
   begin
      return Interfaces.Unsigned_16 (Value and 16#80#);
   end Bit7;
   function BitN (Value : Interfaces.Unsigned_16; NBit : Natural) return Boolean is
   begin
      if BigEndian then
         return (Value and 2**(15 - (NBit mod 16))) /= 0;
      else
         return (Value and 2**(NBit mod 16)) /= 0;
      end if;
   end BitN;

   -- Unsigned_32
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_32 is
   begin
      return Interfaces.Unsigned_32 (Value and 16#01#);
   end Bit0;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_32 is
   begin
      return Interfaces.Unsigned_32 (Value and 16#80#);
   end Bit7;
   function BitN (Value : Interfaces.Unsigned_32; NBit : Natural) return Boolean is
   begin
      if BigEndian then
         return (Value and 2**(31 - (NBit mod 32))) /= 0;
      else
         return (Value and 2**(NBit mod 32)) /= 0;
      end if;
   end BitN;

   -- Unsigned_64
   function Bit0 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_64 is
   begin
      return Interfaces.Unsigned_64 (Value and 16#01#);
   end Bit0;
   function Bit7 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_64 is
   begin
      return Interfaces.Unsigned_64 (Value and 16#80#);
   end Bit7;
   function BitN (Value : Interfaces.Unsigned_64; NBit : Natural) return Boolean is
   begin
      if BigEndian then
         return (Value and 2**(63 - (NBit mod 64))) /= 0;
      else
         return (Value and 2**(NBit mod 64)) /= 0;
      end if;
   end BitN;

   ----------------------------------------------------------------------------
   -- L/M/N/O/P/Q/R/HByte
   ----------------------------------------------------------------------------
   -- Extract an Unsigned_8-component from a word.
   ----------------------------------------------------------------------------

   -- Unsigned_16
   function LByte (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LByte;
   function HByte (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end HByte;

   -- Unsigned_32
   function LByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LByte;
   function MByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end MByte;
   function NByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 16) and Unsigned_8_Mask);
   end NByte;
   function HByte (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 24) and Unsigned_8_Mask);
   end HByte;

   -- Unsigned_64
   function LByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LByte;
   function MByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end MByte;
   function NByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 16) and Unsigned_8_Mask);
   end NByte;
   function OByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 24) and Unsigned_8_Mask);
   end OByte;
   function PByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 32) and Unsigned_8_Mask);
   end PByte;
   function QByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 40) and Unsigned_8_Mask);
   end QByte;
   function RByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 48) and Unsigned_8_Mask);
   end RByte;
   function HByte (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 56) and Unsigned_8_Mask);
   end HByte;

   ----------------------------------------------------------------------------
   -- L/HWord
   ----------------------------------------------------------------------------

   -- Unsigned_16
   function LWord (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (Value and Unsigned_8_Mask);
   end LWord;
   function HWord (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (ShR (Value, 8) and Unsigned_8_Mask);
   end HWord;

   -- Unsigned_32
   function LWord (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_16 is
   begin
      return Interfaces.Unsigned_16 (Value and Unsigned_16_Mask);
   end LWord;
   function HWord (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_16 is
   begin
      return Interfaces.Unsigned_16 (ShR (Value, 16) and Unsigned_16_Mask);
   end HWord;

   -- Unsigned_64
   function LWord (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_32 is
   begin
      return Interfaces.Unsigned_32 (Value and Unsigned_32_Mask);
   end LWord;
   function HWord (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_32 is
   begin
      return Interfaces.Unsigned_32 (ShR (Value, 32) and Unsigned_32_Mask);
   end HWord;

   ----------------------------------------------------------------------------
   -- Make_Word
   ----------------------------------------------------------------------------
   -- Assemble a 16/32/64-bit word using low-order halves.
   ----------------------------------------------------------------------------

   function Make_Word (
                       Value_H : Interfaces.Unsigned_8;
                       Value_L : Interfaces.Unsigned_8
                      ) return Interfaces.Unsigned_16 is
   begin
      return ShL (Interfaces.Unsigned_16 (Value_H), 8) or Interfaces.Unsigned_16 (Value_L);
   end Make_Word;

   function Make_Word (
                       Value_H : Interfaces.Unsigned_16;
                       Value_L : Interfaces.Unsigned_16
                      ) return Interfaces.Unsigned_32 is
   begin
      return ShL (Interfaces.Unsigned_32 (Value_H), 16) or Interfaces.Unsigned_32 (Value_L);
   end Make_Word;

   function Make_Word (
                       Value_H : Interfaces.Unsigned_32;
                       Value_L : Interfaces.Unsigned_32
                      ) return Interfaces.Unsigned_64 is
   begin
      return ShL (Interfaces.Unsigned_64 (Value_H), 32) or Interfaces.Unsigned_64 (Value_L);
   end Make_Word;

   ----------------------------------------------------------------------------
   -- Byte_Swap
   ----------------------------------------------------------------------------

   function Byte_Swap_8 (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 is
   separate;

   function Byte_Swap_16 (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   separate;

   function Byte_Swap_32 (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   separate;

   function Byte_Swap_64 (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 is
   separate;

   ----------------------------------------------------------------------------
   -- Word_Swap
   ----------------------------------------------------------------------------
   -- Swap two halves of a 16/32/64-bit word.
   ----------------------------------------------------------------------------

   function Word_Swap (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 is
   begin
      return Value;
   end Word_Swap;

   function Word_Swap (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      return Byte_Swap (Value);
   end Word_Swap;

   function Word_Swap (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      return ShR (Value and 16#FFFF_0000#, 16) or
             ShL (Value and 16#0000_FFFF#, 16);
   end Word_Swap;

   function Word_Swap (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 is
   begin
      return ShR (Value and 16#FFFF_FFFF_0000_0000#, 32) or
             ShL (Value and 16#0000_0000_FFFF_FFFF#, 32);
   end Word_Swap;

   ----------------------------------------------------------------------------
   -- CPUE to/from BE/LE
   ----------------------------------------------------------------------------

   -- Unsigned_16
   function CPUE_To_BE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end CPUE_To_BE;
   function BE_To_CPUE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end BE_To_CPUE;
   function CPUE_To_LE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      if LittleEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end CPUE_To_LE;
   function LE_To_CPUE (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      if LittleEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end LE_To_CPUE;

   -- Unsigned_32
   function CPUE_To_BE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end CPUE_To_BE;
   function BE_To_CPUE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end BE_To_CPUE;
   function CPUE_To_LE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      if LittleEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end CPUE_To_LE;
   function LE_To_CPUE (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      if LittleEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end LE_To_CPUE;

   -- Unsigned_64
   function CPUE_To_BE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end CPUE_To_BE;
   function BE_To_CPUE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end BE_To_CPUE;
   function CPUE_To_LE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 is
   begin
      if LittleEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end CPUE_To_LE;
   function LE_To_CPUE (Value : Interfaces.Unsigned_64) return Interfaces.Unsigned_64 is
   begin
      if LittleEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end LE_To_CPUE;

   ----------------------------------------------------------------------------
   -- Host to/from Network
   ----------------------------------------------------------------------------

   -- Unsigned_16
   function HostToNetwork (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end HostToNetwork;
   function NetworkToHost (Value : Interfaces.Unsigned_16) return Interfaces.Unsigned_16 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end NetworkToHost;

   -- Unsigned_32
   function HostToNetwork (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end HostToNetwork;
   function NetworkToHost (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   begin
      if BigEndian then
         return Value;
      else
         return Byte_Swap (Value);
      end if;
   end NetworkToHost;

   ----------------------------------------------------------------------------
   -- Bit_Extend
   ----------------------------------------------------------------------------

   -- Unsigned_8
   function Bit_Extend (Value : Interfaces.Unsigned_8; Bit : Natural) return Interfaces.Unsigned_8 is
      Sign   : Interfaces.Unsigned_8;
      Mask   : Interfaces.Unsigned_8;
      Result : Interfaces.Unsigned_8 := 0;
   begin
      if Bit <= 7 then
         if BigEndian then
            Sign := 2**(7 - Bit);
         else
            Sign := 2**Bit;
         end if;
         Mask := Sign - 1;       -- create value bitmask (does not cover sign bit)
         Sign := Value and Sign; -- Sign is now conditionally asserted
         Result := Value and Mask;
         if Sign /= 0 then
            Result := Result or (not Mask);
         end if;
      end if;
      return Result;
   end Bit_Extend;

   -- Unsigned_16
   function Bit_Extend (Value : Interfaces.Unsigned_16; Bit : Natural) return Interfaces.Unsigned_16 is
      Sign   : Interfaces.Unsigned_16;
      Mask   : Interfaces.Unsigned_16;
      Result : Interfaces.Unsigned_16 := 0;
   begin
      if Bit <= 15 then
         if BigEndian then
            Sign := 2**(15 - Bit);
         else
            Sign := 2**Bit;
         end if;
         Mask := Sign - 1;       -- create value bitmask (does not cover sign bit)
         Sign := Value and Sign; -- Sign is now conditionally asserted
         Result := Value and Mask;
         if Sign /= 0 then
            Result := Result or (not Mask);
         end if;
      end if;
      return Result;
   end Bit_Extend;

   -- Unsigned_32
   function Bit_Extend (Value : Interfaces.Unsigned_32; Bit : Natural) return Interfaces.Unsigned_32 is
      Sign   : Interfaces.Unsigned_32;
      Mask   : Interfaces.Unsigned_32;
      Result : Interfaces.Unsigned_32 := 0;
   begin
      if Bit <= 31 then
         if BigEndian then
            Sign := 2**(31 - Bit);
         else
            Sign := 2**Bit;
         end if;
         Mask := Sign - 1;       -- create value bitmask (does not cover sign bit)
         Sign := Value and Sign; -- Sign is now conditionally asserted
         Result := Value and Mask;
         if Sign /= 0 then
            Result := Result or (not Mask);
         end if;
      end if;
      return Result;
   end Bit_Extend;

   -- Unsigned_64
   function Bit_Extend (Value : Interfaces.Unsigned_64; Bit : Natural) return Interfaces.Unsigned_64 is
      Sign   : Interfaces.Unsigned_64;
      Mask   : Interfaces.Unsigned_64;
      Result : Interfaces.Unsigned_64 := 0;
   begin
      if Bit <= 63 then
         if BigEndian then
            Sign := 2**(63 - Bit);
         else
            Sign := 2**Bit;
         end if;
         Mask := Sign - 1;       -- create value bitmask (does not cover sign bit)
         Sign := Value and Sign; -- Sign is now conditionally asserted
         Result := Value and Mask;
         if Sign /= 0 then
            Result := Result or (not Mask);
         end if;
      end if;
      return Result;
   end Bit_Extend;

end Bits;
