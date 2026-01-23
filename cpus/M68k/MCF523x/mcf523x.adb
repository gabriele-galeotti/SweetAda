-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf523x.adb                                                                                               --
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

with Ada.Unchecked_Conversion;

package body MCF523x
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   generic function UC renames Ada.Unchecked_Conversion;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- Core register conversion functions

pragma Style_Checks (Off);
   function To_U32 (Value : SYNCR_Type) return Unsigned_32 is function Convert is new UC (SYNCR_Type, Unsigned_32); begin return Convert (Value); end To_U32;
   function To_SYNCR (Value : Unsigned_32) return SYNCR_Type is function Convert is new UC (Unsigned_32, SYNCR_Type); begin return Convert (Value); end To_SYNCR;
   function To_U32 (Value : SYNSR_Type) return Unsigned_32 is function Convert is new UC (SYNSR_Type, Unsigned_32); begin return Convert (Value); end To_U32;
   function To_SYNSR (Value : Unsigned_32) return SYNSR_Type is function Convert is new UC (Unsigned_32, SYNSR_Type); begin return Convert (Value); end To_SYNSR;
   function To_U32 (Value : IPSBAR_Type) return Unsigned_32 is function Convert is new UC (IPSBAR_Type, Unsigned_32); begin return Convert (Value); end To_U32;
   function To_IPSBAR (Value : Unsigned_32) return IPSBAR_Type is function Convert is new UC (Unsigned_32, IPSBAR_Type); begin return Convert (Value); end To_IPSBAR;
pragma Style_Checks (On);

   -- IRQ indexing

   function IRQ_Index
      (IRQ       : INTC0_Source_Type;
       VTHandler : Boolean)
      return Natural
      is
      Index : Natural;
   begin
      Index := 63 - IRQ'Enum_Rep;
      if VTHandler then
         Index := @ + 64;
      end if;
      return Index;
   end IRQ_Index;

   function IRQ_Index
      (IRQ       : INTC1_Source_Type;
       VTHandler : Boolean)
      return Natural
      is
      Index : Natural;
   begin
      Index := 63 - IRQ'Enum_Rep;
      if VTHandler then
         Index := @ + 128;
      end if;
      return Index;
   end IRQ_Index;

end MCF523x;
