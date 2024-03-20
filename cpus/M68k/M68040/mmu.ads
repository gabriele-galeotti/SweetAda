-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu.ads                                                                                                   --
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

with System;
with M68040;

package MMU
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use M68040;

   -- PGI: A17 .. A12/13

   type Page4k_Type is array (0 .. 63) of P4DSC_Type
      with Alignment => 2**8,
           Pack      => True;

   type Page4k_Ptr is access all Page4k_Type;

   -- RI: A31 .. A25, 128 * 32 MByte blocks

   type Root_Table_Type is array (Natural range <>) of RTDSC_Type
      with Alignment => 2**8,
           Pack      => True;

   Root_Table : aliased Root_Table_Type (0 .. 127)
      with Volatile                => True,
           Suppress_Initialization => True;

   -- PI: A24 .. A18, 128 * 256 kByte blocks

pragma Warnings (Off, "pragma Pack affects convention ""C"" components");
   type Pointer_Table_4k_Type is array (Natural range <>) of PTDSC_Type (PAGESIZE => PAGESIZE4k)
      with Alignment => 2**9,
           Pack      => True;
pragma Warnings (On, "pragma Pack affects convention ""C"" components");

   Pointer_Table : aliased Pointer_Table_4k_Type (0 .. 127)
      with Volatile                => True,
           Suppress_Initialization => True;

   procedure Page_Setup
      (P  : in Page4k_Ptr;
       BA : in Address);
   procedure Enable;
   procedure Init;

end MMU;
