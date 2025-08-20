-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils.adb                                                                                               --
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

package body LLutils
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
   use type Interfaces.Unsigned_8;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Byte_Swap_XX
   ----------------------------------------------------------------------------

   procedure Byte_Swap_16
      (Object_Address : in System.Address)
      is
   separate;
   procedure Byte_Swap_32
      (Object_Address : in System.Address)
      is
   separate;
   procedure Byte_Swap_64
      (Object_Address : in System.Address)
      is
   separate;

   ----------------------------------------------------------------------------
   -- BE_To_CPUE_XX
   ----------------------------------------------------------------------------

   function BE_To_CPUE_16
      (Object_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   function BE_To_CPUE_32
      (Object_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   function BE_To_CPUE_64
      (Object_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;

   ----------------------------------------------------------------------------
   -- LE_To_CPUE_XX
   ----------------------------------------------------------------------------

   function LE_To_CPUE_16
      (Object_Address : System.Address)
      return Interfaces.Unsigned_16
      is
   separate;
   function LE_To_CPUE_32
      (Object_Address : System.Address)
      return Interfaces.Unsigned_32
      is
   separate;
   function LE_To_CPUE_64
      (Object_Address : System.Address)
      return Interfaces.Unsigned_64
      is
   separate;

   ----------------------------------------------------------------------------
   -- Byte_Swap
   ----------------------------------------------------------------------------
   procedure Byte_Swap
      (Object_Address : in System.Address;
       Size           : in Bits.Bitsize)
      is
   begin
      case Size is
         when Bits.BIT8    => null;                          -- 8-bit no-swap
         when Bits.BIT16   => Byte_Swap_16 (Object_Address); -- 16-bit swap
         when Bits.BIT32   => Byte_Swap_32 (Object_Address); -- 32-bit swap
         when Bits.BIT64   => Byte_Swap_64 (Object_Address); -- 64-bit swap
         when Bits.BITNONE => null;                          -- undefined swap
      end case;
   end Byte_Swap;

   ----------------------------------------------------------------------------
   -- Byte_Swap_Next
   ----------------------------------------------------------------------------
   procedure Byte_Swap_Next
      (Object_Address : in out System.Address;
       Size           : in     Bits.Bitsize)
      is
   begin
      Byte_Swap (Object_Address, Size);
      case Size is
         when Bits.BIT8    => Object_Address := @ + 1; -- 8-bit no-swap
         when Bits.BIT16   => Object_Address := @ + 2; -- 16-bit swap
         when Bits.BIT32   => Object_Address := @ + 4; -- 32-bit swap
         when Bits.BIT64   => Object_Address := @ + 8; -- 64-bit swap
         when Bits.BITNONE => null;                    -- undefined swap
      end case;
   end Byte_Swap_Next;

   ----------------------------------------------------------------------------
   -- Select_Address_Bits
   ----------------------------------------------------------------------------
   function Select_Address_Bits
      (Address_Pattern : System.Address;
       LSBit           : Bits.Address_Bit_Number;
       MSBit           : Bits.Address_Bit_Number;
       BE_Layout       : Boolean := False)
      return SSE.Integer_Address
      is
   separate;

   ----------------------------------------------------------------------------
   -- Address_Displacement
   ----------------------------------------------------------------------------
   function Address_Displacement
      (Base_Address   : System.Address;
       Object_Address : System.Address;
       Scale_Factor   : Bits.Address_Shift)
      return SSE.Storage_Offset
      is
   separate;

   ----------------------------------------------------------------------------
   -- Build_Address
   ----------------------------------------------------------------------------
   function Build_Address
      (Base_Address : System.Address;
       Offset       : System.Storage_Elements.Storage_Offset;
       Scale_Factor : Bits.Address_Shift)
      return System.Address
      is
   separate;

   ----------------------------------------------------------------------------
   -- BCD_To_U8
   ----------------------------------------------------------------------------
   function BCD_To_U8
      (V : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
   begin
      return (V and 16#0F#) + Bits.ShR (V, 4) * 10;
   end BCD_To_U8;

   ----------------------------------------------------------------------------
   -- U8_To_BCD
   ----------------------------------------------------------------------------
   function U8_To_BCD
      (V : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8
      is
      L : Interfaces.Unsigned_8;
      H : Interfaces.Unsigned_8;
   begin
      L := V mod 10;
      H := V / 10;
      if L > 9 or else H > 9 then
         raise Constraint_Error;
      end if;
      return Bits.ShL (H, 4) or L;
   end U8_To_BCD;

   ----------------------------------------------------------------------------
   -- To_Ch
   ----------------------------------------------------------------------------
   function To_Ch
      (Digit : Decimal_Digit_Type)
      return Character
      is
   begin
      return Character'Val (Character'Pos ('0') + Digit);
   end To_Ch;

   ----------------------------------------------------------------------------
   -- To_HexDigit
   ----------------------------------------------------------------------------
   function To_HexDigit
      (Value : Interfaces.Unsigned_8;
       MSD   : Boolean;
       LCase : Boolean)
      return Character
      is
      Digit : Interfaces.Unsigned_8 := Value;
      C     : Character;
   begin
      if MSD then
         Digit := @ / 2**4;
      end if;
      Digit := @ and 16#0F#;
      if Digit > 9 then
         declare
            A_Pos : Interfaces.Unsigned_8;
         begin
            A_Pos := (if LCase then Character'Pos ('a') else Character'Pos ('A'));
            C := Character'Val (A_Pos + (Digit - 10));
         end;
      else
         C := Character'Val (Character'Pos ('0') + Digit);
      end if;
      return C;
   end To_HexDigit;

   ----------------------------------------------------------------------------
   -- To_U8
   ----------------------------------------------------------------------------
   procedure To_U8
      (C       : in     Character;
       MSD     : in     Boolean;
       Value   : in out Interfaces.Unsigned_8;
       Success :    out Boolean)
      is
      Digit : Interfaces.Unsigned_8;
   begin
      Success := True;
      case C is
         when '0' .. '9' => Digit := Character'Pos (C) - Character'Pos ('0');
         when 'A' .. 'F' => Digit := Character'Pos (C) - Character'Pos ('A') + 10;
         when 'a' .. 'f' => Digit := Character'Pos (C) - Character'Pos ('a') + 10;
         when others     => Success := False;
      end case;
      if Success then
         Value := (if MSD then (@ and 16#0F#) or (Digit * 2**4) else (@ and 16#F0#) or Digit);
      end if;
   end To_U8;

   ----------------------------------------------------------------------------
   -- CString_Length
   ----------------------------------------------------------------------------
   function CString_Length
      (String_Address : System.Address)
      return Bits.C.size_t
      is
   separate;

   ----------------------------------------------------------------------------
   -- Atomic_Clear
   ----------------------------------------------------------------------------
   procedure Atomic_Clear
      (Object_Address : in System.Address;
       Memory_Order   : in Integer)
      is
   separate;

   ----------------------------------------------------------------------------
   -- Atomic_Load
   ----------------------------------------------------------------------------
   function Atomic_Load
      (Object_Address : System.Address;
       Memory_Order   : Integer)
      return Atomic_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- Atomic_Test_And_Set
   ----------------------------------------------------------------------------
   function Atomic_Test_And_Set
      (Object_Address : System.Address;
       Memory_Order   : Integer)
      return Boolean
      is
   separate;

end LLutils;
