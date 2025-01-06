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

with GCC_Types;

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

   function DivDI3
      (N : GCC_Types.DI_Type;
       D : GCC_Types.DI_Type)
      return GCC_Types.DI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__divdi3";

   function ModDI3
      (N : GCC_Types.DI_Type;
       D : GCC_Types.DI_Type)
      return GCC_Types.DI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__moddi3";

   function UDivDI3
      (N : GCC_Types.UDI_Type;
       D : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__udivdi3";

   function UModDI3
      (N : GCC_Types.UDI_Type;
       D : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__umoddi3";

end LibGCC;
