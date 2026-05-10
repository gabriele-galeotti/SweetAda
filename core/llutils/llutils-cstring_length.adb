-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-cstring_length.adb                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

separate (LLutils)
function CString_Length
   (String_Address : System.Address)
   return Interfaces.C.size_t
   is
   use Interfaces.C;
   CArray : char_array (size_t)
      with Address    => String_Address,
           Import     => True,
           Convention => Ada;
   Nchars : size_t;
begin
   Nchars := 0;
   loop
      exit when CArray (Nchars) = nul;
      Nchars := @ + 1;
   end loop;
   return Nchars;
end CString_Length;
