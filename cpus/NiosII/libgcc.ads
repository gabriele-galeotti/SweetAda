-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.ads                                                                                                --
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

with GCC.Types;

package LibGCC
   with Pure => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function DivSI3
      (N : GCC.Types.SI_Type;
       D : GCC.Types.SI_Type)
      return GCC.Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__divsi3";

   function ModSI3
      (N : GCC.Types.SI_Type;
       D : GCC.Types.SI_Type)
      return GCC.Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__modsi3";

   function UDivSI3
      (N : GCC.Types.USI_Type;
       D : GCC.Types.USI_Type)
      return GCC.Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__udivsi3";

   function UModSI3
      (N : GCC.Types.USI_Type;
       D : GCC.Types.USI_Type)
      return GCC.Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__umodsi3";

end LibGCC;
