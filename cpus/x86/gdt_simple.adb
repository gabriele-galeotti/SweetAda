-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdt_simple.adb                                                                                            --
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

with System.Storage_Elements;

package body GDT_Simple
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;

   GDT_Descriptor : aliased GDT_Descriptor_Type;
   GDT            : aliased GDT_Type (0 .. 2);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- index0: invalid descriptor
      GDT (0) := SEGMENT_DESCRIPTOR_INVALID;
      -- index1: DPL0 CODE
      GDT_Set_Entry (
         GDT_Entry => GDT (1),
         Base      => To_Address (0),
         Limit     => 16#000F_FFFF#,
         SegType   => CODE_ER,
         S         => DESCRIPTOR_CODEDATA,
         DPL       => PL0,
         P         => True,
         D_B       => DEFAULT_OPSIZE32,
         G         => GRANULARITY_4k
         );
      -- index2: DPL0 DATA
      GDT_Set_Entry (
         GDT_Entry => GDT (2),
         Base      => To_Address (0),
         Limit     => 16#000F_FFFF#,
         SegType   => DATA_RW,
         S         => DESCRIPTOR_CODEDATA,
         DPL       => PL0,
         P         => True,
         D_B       => DEFAULT_OPSIZE32,
         G         => GRANULARITY_4k
         );
      GDT_Set (GDT_Descriptor, GDT'Address, GDT'Length, 1);
   end Setup;

end GDT_Simple;
