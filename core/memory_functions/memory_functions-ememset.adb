-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions-ememset.adb                                                                              --
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

separate (Memory_Functions)
function EMemset
   (S : Interfaces.C.Extensions.void_ptr;
    C : Interfaces.C.int;
    N : Interfaces.C.size_t)
   return Interfaces.C.Extensions.void_ptr
is
   use Interfaces.C;
   type mod_Cint is mod 2**Interfaces.C.int'Size;
   P  : constant MAP.Object_Pointer := MAP.To_Pointer (S);
   Ci : aliased constant Interfaces.C.int := C;
   Cm : aliased constant mod_Cint
      with Address    => Ci'Address,
           Import     => True,
           Convention => Ada;
   Cc : char;
begin
   -- avoid underflow since size_t is a modular type
   if N > 0 then
      Cc := char'Val (Cm mod 2**char'Size);
      for Idx in 0 .. N - 1 loop
         P.all (Idx) := Cc;
      end loop;
   end if;
   return S;
end EMemset;
