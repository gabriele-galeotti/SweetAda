-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions-ememset.adb                                                                              --
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

separate (Memory_Functions)
function EMemset
   (S : System.Address;
    C : Interfaces.C.int;
    N : Interfaces.C.size_t)
   return System.Address
   is
   pragma Suppress (Access_Check);
   type int_mod is mod 2**Interfaces.C.int'Size;
   function To_im is new Ada.Unchecked_Conversion (Interfaces.C.int, int_mod);
   function To_MAP is new Ada.Unchecked_Conversion (System.Address, Memory_Area_Ptr);
   P  : constant Memory_Area_Ptr := To_MAP (S);
   Ic : Interfaces.C.char;
begin
   -- avoid underflow since size_t is a modular type
   if N > 0 then
      -- int has negative values, so it is necessary to convert first to a
      -- modular type in order to avoid warnings on implicit conditionals
      -- when applying the mod operation which restricts output range to
      -- char type values
      Ic := Interfaces.C.char'Val (To_im (C) mod 2**Interfaces.C.char'Size);
      for Index in 0 .. N - 1 loop
         P.all (Index) := Ic;
      end loop;
   end if;
   return S;
end EMemset;
