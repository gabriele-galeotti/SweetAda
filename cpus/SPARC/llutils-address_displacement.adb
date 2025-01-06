-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-address_displacement.adb                                                                          --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with Ada.Characters.Latin_1;

separate (LLutils)
function Address_Displacement
   (Local_Address  : System.Address;
    Target_Address : System.Address;
    Scale_Address  : Bits.Address_Shift)
   return SSE.Storage_Offset
   is
   use System.Machine_Code;
   package ISO88591 renames Ada.Characters.Latin_1;
   CRLF   : constant String := ISO88591.CR & ISO88591.LF;
   Result : SSE.Storage_Offset;
begin
   Asm (
        Template => ""                         & CRLF &
                    "        sub     %1,%2,%0" & CRLF &
                    "        sra     %0,%3,%0" & CRLF &
                    "",
        Outputs  => SSE.Storage_Offset'Asm_Output ("=r", Result),
        Inputs   => [
                     System.Address'Asm_Input ("r", Target_Address),
                     System.Address'Asm_Input ("r", Local_Address),
                     Bits.Address_Shift'Asm_Input ("r", Scale_Address)
                    ],
        Clobber  => "",
        Volatile => True
       );
   return Result;
end Address_Displacement;
