-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions-ememcpy.adb                                                                              --
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
function EMemcpy
   (S1 : Interfaces.C.Extensions.void_ptr;
    S2 : Interfaces.C.Extensions.void_ptr;
    N  : Interfaces.C.size_t)
   return Interfaces.C.Extensions.void_ptr
   is
   use Interfaces.C;
   P_S1 : constant MAP.Object_Pointer := MAP.To_Pointer (S1);
   P_S2 : constant MAP.Object_Pointer := MAP.To_Pointer (S2);
begin
   -- avoid underflow since size_t is a modular type
   if N > 0 then
      for Index in 0 .. N - 1 loop
         P_S1.all (Index) := P_S2.all (Index);
      end loop;
   end if;
   return S1;
end EMemcpy;
