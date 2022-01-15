-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68k-lock_try.adb                                                                                         --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

   separate (M68k)
   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
      Locked_Item : Lock_Type := (Lock => LOCK_UNLOCK);
   begin
      Asm (
           Template => "        casl    %0,%2,%1",
           Outputs  => (
                        CPU_Unsigned'Asm_Output ("+r", Locked_Item.Lock),
                        CPU_Unsigned'Asm_Output ("+m", Lock_Object.Lock)
                       ),
           Inputs   => CPU_Unsigned'Asm_Input ("r", LOCK_LOCK),
           Clobber  => "",
           Volatile => True
          );
      Success := Locked_Item.Lock = LOCK_UNLOCK;
   end Lock_Try;
