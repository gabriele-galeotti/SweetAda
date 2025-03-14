-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-build_address.adb                                                                                 --
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
function Build_Address
   (Base_Address  : System.Address;
    Offset        : SSE.Storage_Offset;
    Scale_Address : Bits.Address_Shift)
   return System.Address
   is
   use System.Machine_Code;
   package ISO88591 renames Ada.Characters.Latin_1;
   CRLF   : constant String := ISO88591.CR & ISO88591.LF;
   Result : System.Address;
begin
   Asm (
        Template => ""                            & CRLF &
                    "        shlq    %%cl,%%rbx " & CRLF &
                    "        addq    %%rbx,%%rax" & CRLF &
                    "",
        Outputs  => System.Address'Asm_Output ("=a", Result),
        Inputs   => [
                     System.Address'Asm_Input ("a", Base_Address),
                     SSE.Storage_Offset'Asm_Input ("b", Offset),
                     Bits.Address_Shift'Asm_Input ("c", Scale_Address)
                    ],
        Clobber  => "",
        Volatile => True
       );
   return Result;
end Build_Address;
