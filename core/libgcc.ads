-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
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

   function BswapSI2
      (V : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__bswapsi2";

   function BswapDI2
      (V : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__bswapdi2";

   function AddDI3
      (A1 : GCC_Types.UDI_Type;
       A2 : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__adddi3";

   function SubDI3
      (A1 : GCC_Types.UDI_Type;
       A2 : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__subdi3";

   function NegDI2
      (Value : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__negdi2";

   function MulSI3
      (M1 : GCC_Types.USI_Type;
       M2 : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__mulsi3";

   function MulDI3
      (M1 : GCC_Types.UDI_Type;
       M2 : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__muldi3";

   function DivSI3
      (N : GCC_Types.SI_Type;
       D : GCC_Types.SI_Type)
      return GCC_Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__divsi3";

   function ModSI3
      (N : GCC_Types.SI_Type;
       D : GCC_Types.SI_Type)
      return GCC_Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__modsi3";

   function UDivSI3
      (N : GCC_Types.USI_Type;
       D : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__udivsi3";

   function UModSI3
      (N : GCC_Types.USI_Type;
       D : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__umodsi3";

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

   function CmpDI2
      (A : GCC_Types.DI_Type;
       B : GCC_Types.DI_Type)
      return GCC_Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__cmpdi2";

   function UCmpDI2
      (A : GCC_Types.UDI_Type;
       B : GCC_Types.UDI_Type)
      return GCC_Types.SI_Type
      with Export        => True,
           Convention    => C,
           External_Name => "__ucmpdi2";

end LibGCC;
