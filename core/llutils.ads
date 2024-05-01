-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils.ads                                                                                               --
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

pragma Restrictions (No_Elaboration_Code);

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package LLutils
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   package SSE renames System.Storage_Elements;

   ----------------------------------------------------------------------------
   -- Byte swapping
   ----------------------------------------------------------------------------

   procedure Byte_Swap_16
      (Object_Address : in System.Address)
      with Inline => True;
   procedure Byte_Swap_32
      (Object_Address : in System.Address)
      with Inline => True;
   procedure Byte_Swap_64
      (Object_Address : in System.Address)
      with Inline => True;

   function BE_To_CPUE_16
      (Object_Address : System.Address)
      return Interfaces.Unsigned_16
      with Inline => True;
   function BE_To_CPUE_32
      (Object_Address : System.Address)
      return Interfaces.Unsigned_32
      with Inline => True;
   function BE_To_CPUE_64
      (Object_Address : System.Address)
      return Interfaces.Unsigned_64
      with Inline => True;

   function LE_To_CPUE_16
      (Object_Address : System.Address)
      return Interfaces.Unsigned_16
      with Inline => True;
   function LE_To_CPUE_32
      (Object_Address : System.Address)
      return Interfaces.Unsigned_32
      with Inline => True;
   function LE_To_CPUE_64
      (Object_Address : System.Address)
      return Interfaces.Unsigned_64
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Perform a size-driven byte swapping on an object.
   ----------------------------------------------------------------------------
   procedure Byte_Swap
      (Object_Address : in System.Address;
       Size           : in Bits.Bitsize);

   ----------------------------------------------------------------------------
   -- Perform a size-driven byte swapping on an object and then advance the
   -- address.
   ----------------------------------------------------------------------------
   procedure Byte_Swap_Next
      (Object_Address : in out System.Address;
       Size           : in     Bits.Bitsize);

   ----------------------------------------------------------------------------
   -- Address manipulation
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Extract a bit pattern from an address.
   -- Some CPUs are inherently big-endian machines (in the sense of how they
   -- store multi-byte objects), like PowerPC-class CPUs, but the bit layout
   -- (i.e., the numbering of bits in registers and physical hardware busses)
   -- is anyway little-endian, like M68k-class CPUs. So, use always LE layout
   -- when not explicitly specified.
   ----------------------------------------------------------------------------
   function Select_Address_Bits
      (Address_Pattern : System.Address;
       LSBit           : Bits.Address_Bit_Number;
       MSBit           : Bits.Address_Bit_Number;
       BE_Layout       : Boolean := False)
      return SSE.Integer_Address
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Compute the displacement between two addresses, scaled by a factor.
   -- NOTE: when converting a displacement to an unsigned object, use an
   -- unchecked conversion (Storage_Offset is a signed integer type).
   ----------------------------------------------------------------------------
   function Address_Displacement
      (Local_Address  : System.Address;
       Target_Address : System.Address;
       Scale_Address  : Bits.Address_Shift)
      return SSE.Storage_Offset
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Build an address from a base address plus on offset, scaled by a factor.
   ----------------------------------------------------------------------------
   function Build_Address
      (Base_Address  : System.Address;
       Offset        : SSE.Storage_Offset;
       Scale_Address : Bits.Address_Shift)
      return System.Address
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Transform an Unsigned_8 from BCD form.
   ----------------------------------------------------------------------------
   function BCD2U8
      (V : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8;

   ----------------------------------------------------------------------------
   -- Transform an Unsigned_8 in BCD form.
   ----------------------------------------------------------------------------
   function U82BCD
      (V : Interfaces.Unsigned_8)
      return Interfaces.Unsigned_8;

   ----------------------------------------------------------------------------
   -- Character-oriented utilities
   ----------------------------------------------------------------------------

   subtype Decimal_Digit_Type is Natural range 0 .. 9;

   ----------------------------------------------------------------------------
   -- Convert a digit to a character.
   ----------------------------------------------------------------------------
   function To_Ch
      (Digit : Decimal_Digit_Type)
      return Character
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Take an 8-bit (2 hex digits) input value; then, insert in MSD/LSD the
   -- hexadecimal representation of C (if it is a valid hexadecimal digit):
   -- Value = 0x33, C = 'A', MSD = True => Value = 0xA3
   -- Value = 0x33, C = '4', MSD = False => Value = 0x34
   ----------------------------------------------------------------------------
   procedure To_U8
      (C       : in     Character;
       MSD     : in     Boolean;
       Value   : in out Interfaces.Unsigned_8;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Take an 8-bit (2 hex digits) input value; if MSD, return the MS digit as
   -- a character representing the hexadecimal digit, else the LS digit.
   ----------------------------------------------------------------------------
   procedure To_HexDigit
      (Value : in     Interfaces.Unsigned_8;
       MSD   : in     Boolean;
       LCase : in     Boolean;
       C     :    out Character);

end LLutils;
