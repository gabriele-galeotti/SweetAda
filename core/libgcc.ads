-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.ads                                                                                                --
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

with GCC_Types;

package LibGCC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   function AddDI3 (
                    A1 : GCC_Types.UDI_Type;
                    A2 : GCC_Types.UDI_Type
                   ) return GCC_Types.UDI_Type;

   function SubDI3 (
                    A1 : GCC_Types.UDI_Type;
                    A2 : GCC_Types.UDI_Type
                   ) return GCC_Types.UDI_Type;

   function NegDI2 (
                    Value : GCC_Types.UDI_Type
                   ) return GCC_Types.UDI_Type;

   function MulSI3 (
                    M1 : GCC_Types.USI_Type;
                    M2 : GCC_Types.USI_Type
                   ) return GCC_Types.USI_Type;

   function MulDI3 (
                    M1 : GCC_Types.UDI_Type;
                    M2 : GCC_Types.UDI_Type
                   ) return GCC_Types.UDI_Type;

   function DivSI3 (
                    N : GCC_Types.SI_Type;
                    D : GCC_Types.SI_Type
                   ) return GCC_Types.SI_Type;

   function ModSI3 (
                    N : GCC_Types.SI_Type;
                    D : GCC_Types.SI_Type
                   ) return GCC_Types.SI_Type;

   function UDivSI3 (
                     N : GCC_Types.USI_Type;
                     D : GCC_Types.USI_Type
                    ) return GCC_Types.USI_Type;

   function UModSI3 (
                     N : GCC_Types.USI_Type;
                     D : GCC_Types.USI_Type
                    ) return GCC_Types.USI_Type;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Export (C, AddDI3, "__adddi3");
   pragma Export (C, SubDI3, "__subdi3");
   pragma Export (C, NegDI2, "__negdi2");
   pragma Export (C, MulSI3, "__mulsi3");
   pragma Export (C, MulDI3, "__muldi3");
   pragma Export (C, DivSI3, "__divsi3");
   pragma Export (C, ModSI3, "__modsi3");
   pragma Export (C, UDivSI3, "__udivsi3");
   pragma Export (C, UModSI3, "__umodsi3");

end LibGCC;
