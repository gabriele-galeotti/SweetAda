-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils.adb                                                                                               --
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

package body LLutils is

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

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Byte_Swap_16
   ----------------------------------------------------------------------------
   procedure Byte_Swap_16 (Object_Address : in System.Address) is
      Object : aliased Bits.Byte_Array (0 .. 1) with
         Address    => Object_Address,
         Volatile   => True,
         Import     => True,
         Convention => Ada;
      Value  : Interfaces.Unsigned_8;
   begin
      Value := Object (0); Object (0) := Object (1); Object (1) := Value;
   end Byte_Swap_16;

   ----------------------------------------------------------------------------
   -- Byte_Swap_32
   ----------------------------------------------------------------------------
   procedure Byte_Swap_32 (Object_Address : in System.Address) is
      Object : aliased Bits.Byte_Array (0 .. 3) with
         Address    => Object_Address,
         Volatile   => True,
         Import     => True,
         Convention => Ada;
      Value  : Interfaces.Unsigned_8;
   begin
      Value := Object (0); Object (0) := Object (3); Object (3) := Value;
      Value := Object (1); Object (1) := Object (2); Object (2) := Value;
   end Byte_Swap_32;

   ----------------------------------------------------------------------------
   -- Byte_Swap_64
   ----------------------------------------------------------------------------
   procedure Byte_Swap_64 (Object_Address : in System.Address) is
      Object : aliased Bits.Byte_Array (0 .. 7) with
         Address    => Object_Address,
         Volatile   => True,
         Import     => True,
         Convention => Ada;
      Value  : Interfaces.Unsigned_8;
   begin
      Value := Object (0); Object (0) := Object (7); Object (7) := Value;
      Value := Object (1); Object (1) := Object (6); Object (6) := Value;
      Value := Object (2); Object (2) := Object (5); Object (5) := Value;
      Value := Object (3); Object (3) := Object (4); Object (4) := Value;
   end Byte_Swap_64;

   ----------------------------------------------------------------------------
   -- Byte_Swap
   ----------------------------------------------------------------------------
   procedure Byte_Swap (
                        Object_Address : in System.Address;
                        Size           : in Bits.Bitsize
                       ) is
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
   -- Address update version.
   ----------------------------------------------------------------------------
   procedure Byte_Swap_Next (
                             Object_Address : in out System.Address;
                             Size           : in     Bits.Bitsize
                            ) is
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
   -- Extract a bit pattern from an address.
   ----------------------------------------------------------------------------
   function Select_Address_Bits (
                                 Address_Pattern : System.Address;
                                 Lsb_Bit         : Bits.Address_Bit_Number;
                                 Msb_Bit         : Bits.Address_Bit_Number
                                ) return SSE.Integer_Address is
      Bit_Mask : SSE.Integer_Address;
   begin
      if Bits.BigEndian then
         if Msb_Bit > Lsb_Bit then
            return 0;
         end if;
         Bit_Mask := 2**(Lsb_Bit - Msb_Bit + 1) - 1;
         return (SSE.To_Integer (Address_Pattern) / 2**(System.Address'Size - 1 - Lsb_Bit)) and Bit_Mask;
      else
         if Msb_Bit < Lsb_Bit then
            return 0;
         end if;
         Bit_Mask := 2**(Msb_Bit - Lsb_Bit + 1) - 1;
         return (SSE.To_Integer (Address_Pattern) / 2**Lsb_Bit) and Bit_Mask;
      end if;
   end Select_Address_Bits;

   ----------------------------------------------------------------------------
   -- Address_Displacement
   ----------------------------------------------------------------------------
   -- Compute the displacement between two addresses, scaled by a factor.
   -- NOTE: when converting a displacement to an unsigned object, use an
   -- unchecked conversion (Storage_Offset is a signed integer type)
   ----------------------------------------------------------------------------
   function Address_Displacement (
                                  Local_Address  : System.Address;
                                  Target_Address : System.Address;
                                  Scale_Address  : Bits.Address_Shift
                                 ) return SSE.Storage_Offset is
   separate;

   ----------------------------------------------------------------------------
   -- Build_Address
   ----------------------------------------------------------------------------
   -- Build an address from a base address plus on offset, scaled by a factor.
   ----------------------------------------------------------------------------
   function Build_Address (
                           Base_Address  : System.Address;
                           Offset        : System.Storage_Elements.Storage_Offset;
                           Scale_Address : Bits.Address_Shift
                          ) return System.Address is
   separate;

   ----------------------------------------------------------------------------
   -- HexDigit_To_U8
   ----------------------------------------------------------------------------
   -- Take an 8-bit (2 hex digits) input value; then, insert in MSD/LSD the
   -- hexadecimal representation of C (if it is a valid hexadecimal digit):
   -- Value = 0x33, C = 'A', MSD = True => Value = 0xA3
   -- Value = 0x33, C = '4', MSD = False => Value = 0x34
   ----------------------------------------------------------------------------
   procedure HexDigit_To_U8 (
                             C       : in     Character;
                             MSD     : in     Boolean;
                             Value   : in out Interfaces.Unsigned_8;
                             Success : out    Boolean
                            ) is
      Digit : Interfaces.Unsigned_8;
   begin
      case C is
         when '0' .. '9' => Digit := Character'Pos (C) - Character'Pos ('0');
         when 'A' .. 'F' => Digit := Character'Pos (C) - Character'Pos ('A') + 10;
         when 'a' .. 'f' => Digit := Character'Pos (C) - Character'Pos ('a') + 10;
         when others     => Success := False; return;
      end case;
      Value := (if MSD then (@ and 16#0F#) or (Digit * 2**4) else (@ and 16#F0#) or Digit);
      Success := True;
   end HexDigit_To_U8;

   ----------------------------------------------------------------------------
   -- U8_To_HexDigit
   ----------------------------------------------------------------------------
   -- Take an 8-bit (2 hex digits) input value; if MSD, return the MS digit as
   -- a character representing the hexadecimal digit, else the LS digit
   ----------------------------------------------------------------------------
   procedure U8_To_HexDigit (
                             Value : in  Interfaces.Unsigned_8;
                             MSD   : in  Boolean;
                             LCase : in  Boolean;
                             C     : out Character
                            ) is
      Digit : Interfaces.Unsigned_8 := Value;
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
   end U8_To_HexDigit;

end LLutils;
