-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.adb                                                                                                --
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

package body LibGCC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type GCC_Types.SI_Type;
   use type GCC_Types.USI_Type;

   function UDivModSI4 (
                        N : GCC_Types.USI_Type;
                        D : GCC_Types.USI_Type;
                        M : Boolean
                       ) return GCC_Types.USI_Type;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- UDivModSI4
   ----------------------------------------------------------------------------
   function UDivModSI4 (
                        N : GCC_Types.USI_Type;
                        D : GCC_Types.USI_Type;
                        M : Boolean
                       ) return GCC_Types.USI_Type is
   separate;

   ----------------------------------------------------------------------------
   -- DivSI3
   ----------------------------------------------------------------------------
   function DivSI3 (
                    N : GCC_Types.SI_Type;
                    D : GCC_Types.SI_Type
                   ) return GCC_Types.SI_Type is
   separate;

   ----------------------------------------------------------------------------
   -- ModSI3
   ----------------------------------------------------------------------------
   function ModSI3 (
                    N : GCC_Types.SI_Type;
                    D : GCC_Types.SI_Type
                   ) return GCC_Types.SI_Type is
   separate;

   ----------------------------------------------------------------------------
   -- UDivSI3
   ----------------------------------------------------------------------------
   function UDivSI3 (
                     N : GCC_Types.USI_Type;
                     D : GCC_Types.USI_Type
                    ) return GCC_Types.USI_Type is
   separate;

   ----------------------------------------------------------------------------
   -- UModSI3
   ----------------------------------------------------------------------------
   function UModSI3 (
                     N : GCC_Types.USI_Type;
                     D : GCC_Types.USI_Type
                    ) return GCC_Types.USI_Type is
   separate;

end LibGCC;
