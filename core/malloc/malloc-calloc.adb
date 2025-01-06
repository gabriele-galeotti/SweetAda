-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc-calloc.adb                                                                                         --
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

separate (Malloc)
function Calloc
   (Nmemb : size_t;
    Size  : size_t)
   return Address
   is
   Nbytes         : size_t;
   Memory_Address : Address;
begin
   Nbytes := Nmemb * Size;
   Memory_Address := Malloc (Nbytes);
   if Memory_Address /= Null_Address then
      Memory_Address := Memory_Functions.Memset (@, 0, Nbytes);
   end if;
   return Memory_Address;
end Calloc;
