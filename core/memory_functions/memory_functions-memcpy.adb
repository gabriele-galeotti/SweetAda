-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions-memcpy.adb                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

separate (Memory_Functions)
function Memcpy (
                 S1 : System.Address;
                 S2 : System.Address;
                 N  : Interfaces.C.size_t
                ) return System.Address is
   pragma Suppress (Access_Check);
   function To_MAP is new Ada.Unchecked_Conversion (System.Address, Memory_Area_Ptr);
   P_S1 : constant Memory_Area_Ptr := To_MAP (S1);
   P_S2 : constant Memory_Area_Ptr := To_MAP (S2);
begin
   -- avoid underflow since size_t is a modular type
   if N > 0 then
      for Index in 0 .. N - 1 loop
         P_S1.all (Index) := P_S2.all (Index);
      end loop;
   end if;
   return S1;
end Memcpy;
