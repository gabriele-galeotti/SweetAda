-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc.adb                                                                                                --
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

package body LibGCC
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type GCC.Types.DI_Type;
   use type GCC.Types.UDI_Type;

   function UDivModDI4
      (N : in     GCC.Types.UDI_Type;
       D : in     GCC.Types.UDI_Type;
       R : in out GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- UDivModDI4
   ----------------------------------------------------------------------------
   function UDivModDI4
      (N : in     GCC.Types.UDI_Type;
       D : in     GCC.Types.UDI_Type;
       R : in out GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- DivDI3
   ----------------------------------------------------------------------------
   function DivDI3
      (N : GCC.Types.DI_Type;
       D : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- ModDI3
   ----------------------------------------------------------------------------
   function ModDI3
      (N : GCC.Types.DI_Type;
       D : GCC.Types.DI_Type)
      return GCC.Types.DI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UDivDI3
   ----------------------------------------------------------------------------
   function UDivDI3
      (N : GCC.Types.UDI_Type;
       D : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

   ----------------------------------------------------------------------------
   -- UModDI3
   ----------------------------------------------------------------------------
   function UModDI3
      (N : GCC.Types.UDI_Type;
       D : GCC.Types.UDI_Type)
      return GCC.Types.UDI_Type
      is
   separate;

end LibGCC;
