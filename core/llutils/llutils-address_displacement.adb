-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-address_displacement.adb                                                                          --
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

separate (LLutils)
function Address_Displacement
   (Base_Address : System.Address;
    Offset       : System.Address;
    Scale_Factor : Bits.Address_Shift)
   return SSE.Storage_Offset
   is
   type Address_Word_Type is mod 2**Standard'Address_Size;
   for Address_Word_Type'Size use Standard'Address_Size;
   function Shift_Left
      (Value  : Address_Word_Type;
       Amount : Natural)
      return Address_Word_Type
      with Import     => True,
           Convention => Intrinsic;
begin
   return (Offset - Base_Address) /
      SSE.Storage_Offset (Shift_Left (Address_Word_Type'(1), Scale_Factor));
end Address_Displacement;
