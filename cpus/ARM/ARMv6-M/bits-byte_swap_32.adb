-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits-byte_swap_32.adb                                                                                     --
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

with System.Machine_Code;
with Interfaces;
with Definitions;

separate (Bits)
function Byte_Swap_32 (Value : Interfaces.Unsigned_32) return Interfaces.Unsigned_32 is
   use System.Machine_Code;
   CRLF   : String renames Definitions.CRLF;
   Result : Interfaces.Unsigned_32;
begin
   Asm (
        Template => ""                      & CRLF &
                    "        rev     %0,%1" & CRLF &
                    "",
        Outputs  => Interfaces.Unsigned_32'Asm_Output ("=r", Result),
        Inputs   => Interfaces.Unsigned_32'Asm_Input ("r", Value),
        Clobber  => "",
        Volatile => True
       );
   return Result;
end Byte_Swap_32;
