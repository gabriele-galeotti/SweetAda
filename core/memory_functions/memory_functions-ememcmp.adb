-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions-ememcmp.adb                                                                              --
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
function EMemcmp
   (S1 : System.Address;
    S2 : System.Address;
    N  : Bits.C.size_t)
   return Bits.C.int
   is
   pragma Suppress (Access_Check);
   use type Bits.Bytesize;
   use type Bits.C.int;
   function To_MAP is new Ada.Unchecked_Conversion (System.Address, Memory_Area_Ptr);
   P_S1   : constant Memory_Area_Ptr := To_MAP (S1);
   P_S2   : constant Memory_Area_Ptr := To_MAP (S2);
   Result : Bits.C.int := 0;
begin
   -- avoid underflow since size_t is a modular type
   if N > 0 then
      for Index in 0 .. N - 1 loop
         if    Bits.C.char'Pos (P_S1.all (Index)) < Bits.C.char'Pos (P_S2.all (Index)) then
            Result := -1;
            exit;
         elsif Bits.C.char'Pos (P_S1.all (Index)) > Bits.C.char'Pos (P_S2.all (Index)) then
            Result := 1;
            exit;
         end if;
      end loop;
   end if;
   return Result;
end EMemcmp;
