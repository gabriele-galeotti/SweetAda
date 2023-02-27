-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_byte_array.adb                                                                              --
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

separate (Console)
procedure Print_Byte_Array (
                            ByteArray : in Bits.Byte_Array;
                            Limit     : in Natural := 0;
                            NL        : in Boolean := False;
                            Prefix    : in String := "";
                            Separator : in Character := ' '
                           ) is
   Index_Upper : Natural range ByteArray'First .. ByteArray'Last;
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   if Limit = 0 then
      Index_Upper := ByteArray'Last;
   else
      Index_Upper := Limit;
   end if;
   for Index in ByteArray'First .. Index_Upper loop
      Print_UnsignedHex8 (ByteArray (Index));
      if Index /= Index_Upper then
         Print (Separator);
      end if;
   end loop;
   if NL then
      Print_NewLine;
   end if;
end Print_Byte_Array;
