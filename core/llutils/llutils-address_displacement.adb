-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-address_displacement.adb                                                                          --
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
function Address_Displacement
   (Base_Address   : System.Address;
    Object_Address : System.Address;
    Scale_Factor   : Bits.Address_Shift)
   return SSE.Storage_Offset
   is
   use type SSE.Integer_Address;
begin
   return SSE.Storage_Offset (
      (SSE.To_Integer (Object_Address) - SSE.To_Integer (Base_Address)) /
      2**Scale_Factor
      );
end Address_Displacement;
