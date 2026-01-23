-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with GCC.Types;

package LibGCC
   with Pure       => True,
        SPARK_Mode => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function BswapSI2
      (V : GCC.Types.SI_Type)
      return GCC.Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__bswapsi2";

   function BswapDI2
      (V : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__bswapdi2";

   function AddDI3
      (A1 : GCC.Types.UDI_Type;
       A2 : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__adddi3";

   function SubDI3
      (A1 : GCC.Types.UDI_Type;
       A2 : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__subdi3";

   function NegDI2
      (Value : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__negdi2";

   function MulSI3
      (M1 : GCC.Types.USI_Type;
       M2 : GCC.Types.USI_Type)
      return GCC.Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__mulsi3";

   function MulDI3
      (M1 : GCC.Types.UDI_Type;
       M2 : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__muldi3";

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
