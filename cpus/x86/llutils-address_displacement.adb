-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-address_displacement.adb                                                                          --
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
with Definitions;

separate (LLutils)
function Address_Displacement (
                               Local_Address  : System.Address;
                               Target_Address : System.Address;
                               Scale_Address  : Bits.Address_Shift
                              ) return SSE.Storage_Offset is
   use System.Machine_Code;
   CRLF   : String renames Definitions.CRLF;
   Result : SSE.Storage_Offset;
begin
   Asm (
        Template => ""                            & CRLF &
                    "        subl    %%ebx,%%eax" & CRLF &
                    "        sarl    %%cl,%%eax " & CRLF &
                    "",
        Outputs  => SSE.Storage_Offset'Asm_Output ("=a", Result),
        Inputs   => [
                     System.Address'Asm_Input ("a", Target_Address),
                     System.Address'Asm_Input ("b", Local_Address),
                     Bits.Address_Shift'Asm_Input ("c", Scale_Address)
                    ],
        Clobber  => "",
        Volatile => True
       );
   return Result;
end Address_Displacement;
