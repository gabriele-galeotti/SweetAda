-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68k-lock_try.adb                                                                                         --
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

separate (M68k)
procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
   Lock_Flag : CPU_Unsigned;
begin
   Asm (
        Template => ""                   & CRLF &
                    "        clrl    %0" & CRLF &
                    "        tas     %1" & CRLF &
                    "        sne     %0" & CRLF &
                    "",
        Outputs  => [
                     CPU_Unsigned'Asm_Output ("=d", Lock_Flag),
                     Lock_Type'Asm_Output ("+m", Lock_Object)
                    ],
        Inputs   => No_Input_Operands,
        Clobber  => "memory,cc",
        Volatile => True
       );
   Success := Lock_Flag = 0;
end Lock_Try;
