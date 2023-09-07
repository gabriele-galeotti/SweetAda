-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-byte_swap_16.adb                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

separate (LLutils)
procedure Byte_Swap_16
   (Object_Address : in System.Address)
   is
   Object : aliased Bits.Byte_Array (0 .. 1)
      with Address    => Object_Address,
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   Value  : Interfaces.Unsigned_8;
begin
   Value := Object (0); Object (0) := Object (1); Object (1) := Value;
end Byte_Swap_16;
