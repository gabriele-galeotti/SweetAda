-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ linker.ads                                                                                                --
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
   -- Memory areas imported from linker
   ----------------------------------------------------------------------------
   SText : aliased constant Bits.Asm_Entry_Point;
   EText : aliased constant Bits.Asm_Entry_Point;
   SData : aliased constant Bits.Asm_Entry_Point;
   EData : aliased constant Bits.Asm_Entry_Point;
   SBss  : aliased constant Bits.Asm_Entry_Point;
   EBss  : aliased constant Bits.Asm_Entry_Point;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Import (Asm, SText, "_stext");
   pragma Import (Asm, EText, "_etext");
   pragma Import (Asm, SData, "_sdata");
   pragma Import (Asm, EData, "_edata");
   pragma Import (Asm, SBss, "_sbss");
   pragma Import (Asm, EBss, "_ebss");

end Linker;
