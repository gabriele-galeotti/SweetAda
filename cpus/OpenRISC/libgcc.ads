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

   function MulDI3
      (M1 : GCC.Types.UDI_Type;
       M2 : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__muldi3";

   function DivDI3
      (N : GCC.Types.DI_Type;
       D : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__divdi3";

   function ModDI3
      (N : GCC.Types.DI_Type;
       D : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__moddi3";

   function UDivDI3
      (N : GCC.Types.UDI_Type;
       D : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__udivdi3";

   function UModDI3
      (N : GCC.Types.UDI_Type;
       D : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__umoddi3";

   function CmpDI2
      (A : GCC.Types.DI_Type;
       B : GCC.Types.DI_Type)
      return GCC.Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__cmpdi2";

   function UCmpDI2
      (A : GCC.Types.UDI_Type;
       B : GCC.Types.UDI_Type)
      return GCC.Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__ucmpdi2";

end LibGCC;
