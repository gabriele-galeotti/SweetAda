-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_unsignedhex8.adb                                                                            --
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

with LLutils;

separate (Console)
procedure Print_UnsignedHex8
   (Value : in Interfaces.Unsigned_8)
   is
   MSD : Boolean := True;
   C   : Character;
begin
   loop
      LLutils.To_HexDigit (Value => Value, MSD => MSD, LCase => False, C => C);
      Print (C);
      MSD := not @;
      exit when MSD;
   end loop;
end Print_UnsignedHex8;
