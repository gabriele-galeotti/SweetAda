-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-be_to_cpue_16.adb                                                                                 --
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
function BE_To_CPUE_16
   (Object_Address : System.Address)
   return Interfaces.Unsigned_16
   is
   Value  : aliased Interfaces.Unsigned_16
      with Address => Object_Address;
   Result : Interfaces.Unsigned_16;
begin
   if Bits.LittleEndian then
      Result := Bits.Word_Swap (Value);
   else
      Result := Value;
   end if;
   return Result;
end BE_To_CPUE_16;
