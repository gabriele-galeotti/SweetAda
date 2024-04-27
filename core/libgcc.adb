-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.adb                                                                                                --
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

package body LibGCC
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type GCC_Types.SI_Type;
   use type GCC_Types.USI_Type;
   use type GCC_Types.DI_Type;
   use type GCC_Types.UDI_Type;

   type UHI_2 is array (0 .. 1) of GCC_Types.UHI_Type
      with Alignment => GCC_Types.USI_Type'Alignment,
           Pack      => True;

   type USI_2 is array (0 .. 1) of GCC_Types.USI_Type
      with Alignment => GCC_Types.UDI_Type'Alignment,
           Pack      => True;

   procedure UMul32x32
      (M1 : in     GCC_Types.USI_Type;
       M2 : in     GCC_Types.USI_Type;
       RH :    out GCC_Types.USI_Type;
       RL :    out GCC_Types.USI_Type);

   function UMulSIDI3
      (M1 : GCC_Types.USI_Type;
       M2 : GCC_Types.USI_Type)
      return GCC_Types.UDI_Type;

   function UDivModSI4
      (N : GCC_Types.USI_Type;
       D : GCC_Types.USI_Type;
       M : Boolean)
      return GCC_Types.USI_Type;

   function UDivModDI4
      (N : in     GCC_Types.UDI_Type;
       D : in     GCC_Types.UDI_Type;
       R : in out GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- BswapSI2
   ----------------------------------------------------------------------------
   function BswapSI2
      (V : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- BswapDI2
   ----------------------------------------------------------------------------
   function BswapDI2
      (V : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- AddDI3
   ----------------------------------------------------------------------------
   function AddDI3
      (A1 : GCC_Types.UDI_Type;
       A2 : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- SubDI3
   ----------------------------------------------------------------------------
   function SubDI3
      (A1 : GCC_Types.UDI_Type;
       A2 : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- NegDI2
   ----------------------------------------------------------------------------
   function NegDI2
      (Value : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UMul32x32
   ----------------------------------------------------------------------------
   procedure UMul32x32
      (M1 : in     GCC_Types.USI_Type;
       M2 : in     GCC_Types.USI_Type;
       RH :    out GCC_Types.USI_Type;
       RL :    out GCC_Types.USI_Type)
      is
   separate;

   ----------------------------------------------------------------------------
   -- UMulSIDI3
   ----------------------------------------------------------------------------
   function UMulSIDI3
      (M1 : GCC_Types.USI_Type;
       M2 : GCC_Types.USI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- MulSI3
   ----------------------------------------------------------------------------
   function MulSI3
      (M1 : GCC_Types.USI_Type;
       M2 : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- MulDI3
   ----------------------------------------------------------------------------
   function MulDI3
      (M1 : GCC_Types.UDI_Type;
       M2 : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivModSI4
   ----------------------------------------------------------------------------
   function UDivModSI4
      (N : GCC_Types.USI_Type;
       D : GCC_Types.USI_Type;
       M : Boolean)
      return GCC_Types.USI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- DivSI3
   ----------------------------------------------------------------------------
   function DivSI3
      (N : GCC_Types.SI_Type;
       D : GCC_Types.SI_Type)
      return GCC_Types.SI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- ModSI3
   ----------------------------------------------------------------------------
   function ModSI3
      (N : GCC_Types.SI_Type;
       D : GCC_Types.SI_Type)
      return GCC_Types.SI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivSI3
   ----------------------------------------------------------------------------
   function UDivSI3
      (N : GCC_Types.USI_Type;
       D : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UModSI3
   ----------------------------------------------------------------------------
   function UModSI3
      (N : GCC_Types.USI_Type;
       D : GCC_Types.USI_Type)
      return GCC_Types.USI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivModDI4
   ----------------------------------------------------------------------------
   function UDivModDI4
      (N : in     GCC_Types.UDI_Type;
       D : in     GCC_Types.UDI_Type;
       R : in out GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- DivDI3
   ----------------------------------------------------------------------------
   function DivDI3
      (N : GCC_Types.DI_Type;
       D : GCC_Types.DI_Type)
      return GCC_Types.DI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- ModDI3
   ----------------------------------------------------------------------------
   function ModDI3
      (N : GCC_Types.DI_Type;
       D : GCC_Types.DI_Type)
      return GCC_Types.DI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivDI3
   ----------------------------------------------------------------------------
   function UDivDI3
      (N : GCC_Types.UDI_Type;
       D : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UModDI3
   ----------------------------------------------------------------------------
   function UModDI3
      (N : GCC_Types.UDI_Type;
       D : GCC_Types.UDI_Type)
      return GCC_Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- CmpDI2
   ----------------------------------------------------------------------------
   function CmpDI2
      (A : GCC_Types.DI_Type;
       B : GCC_Types.DI_Type)
      return GCC_Types.SI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UCmpDI2
   ----------------------------------------------------------------------------
   function UCmpDI2
      (A : GCC_Types.UDI_Type;
       B : GCC_Types.UDI_Type)
      return GCC_Types.SI_Type
      is
   separate;

end LibGCC;
