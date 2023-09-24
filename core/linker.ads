-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ linker.ads                                                                                                --
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

with Bits;

package Linker is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   ----------------------------------------------------------------------------
   -- Memory areas imported from linker.
   ----------------------------------------------------------------------------

   SText : constant Bits.Asm_Entry_Point
      with Import        => True,
           External_Name => "_stext";

   EText : constant Bits.Asm_Entry_Point
      with Import        => True,
           External_Name => "_etext";

   SData : constant Bits.Asm_Entry_Point
      with Import        => True,
           External_Name => "_sdata";

   EData : constant Bits.Asm_Entry_Point
      with Import        => True,
           External_Name => "_edata";

   SBss  : constant Bits.Asm_Entry_Point
      with Import        => True,
           External_Name => "_sbss";

   EBss  : constant Bits.Asm_Entry_Point
      with Import        => True,
           External_Name => "_ebss";

end Linker;
