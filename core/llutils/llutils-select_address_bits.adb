-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-select_address_bits.adb                                                                           --
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

separate (LLutils)
function Select_Address_Bits
   (Address_Pattern : System.Address;
    LSBit           : Bits.Address_Bit_Number;
    MSBit           : Bits.Address_Bit_Number;
    BE_Layout       : Boolean := False)
   return SSE.Integer_Address
   is
   Bit_Mask : SSE.Integer_Address;
begin
   if Bits.LittleEndian or else (Bits.BigEndian and then not BE_Layout) then
      if MSBit < LSBit then
         return 0;
      end if;
      Bit_Mask := 2**(MSBit - LSBit + 1) - 1;
      return (SSE.To_Integer (Address_Pattern) / 2**LSBit) and Bit_Mask;
   else
      if MSBit > LSBit then
         return 0;
      end if;
      Bit_Mask := 2**(LSBit - MSBit + 1) - 1;
      return (SSE.To_Integer (Address_Pattern) / 2**(System.Address'Size - 1 - LSBit)) and Bit_Mask;
   end if;
end Select_Address_Bits;
