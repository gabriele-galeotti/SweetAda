-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits-byte_reverse.adb                                                                                     --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

   separate (Bits)
   function Byte_Reverse (Value : Interfaces.Unsigned_8) return Interfaces.Unsigned_8 is
      Result : Interfaces.Unsigned_8 := Value;
   begin
      Result := ShR (Result and 16#AA#, 1) or ShL (Result and 16#55#, 1);
      Result := ShR (Result and 16#CC#, 2) or ShL (Result and 16#33#, 2);
      Result := ShR (Result and 16#F0#, 4) or ShL (Result and 16#0F#, 4);
      return Result;
   end Byte_Reverse;
