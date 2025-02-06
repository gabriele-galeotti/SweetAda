-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-cstring_length.adb                                                                                --
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
function CString_Length
   (String_Address : System.Address)
   return Bits.C.size_t
   is
   use type Bits.C.char;
   use type Bits.C.size_t;
   nul        : constant Bits.C.char := Bits.C.char'First;
   Char_Array : Bits.C.char_array (Bits.C.size_t)
      with Address => String_Address;
   Nchars     : Bits.C.size_t;
begin
   Nchars := 0;
   loop
      exit when Char_Array (Nchars) = nul;
      Nchars := @ + 1;
   end loop;
   return Nchars;
end CString_Length;
