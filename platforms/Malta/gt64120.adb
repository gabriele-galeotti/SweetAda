-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gt64120.adb                                                                                               --
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

package body GT64120 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Make_LD
   ----------------------------------------------------------------------------
   function Make_LD (Start_Address : Unsigned_64) return Unsigned_32 is
   begin
      return Unsigned_32 (Shift_Right (Start_Address, 21));
   end Make_LD;

   ----------------------------------------------------------------------------
   -- Make_HD
   ----------------------------------------------------------------------------
   function Make_HD (Start_Address : Unsigned_64; Size : Unsigned_64) return Unsigned_32 is
   begin
      return Unsigned_32 (Shift_Right (Start_Address + Size - 1, 21) and 16#7F#);
   end Make_HD;

end GT64120;
