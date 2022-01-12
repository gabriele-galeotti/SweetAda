-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ blockdevices.adb                                                                                          --
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

package body BlockDevices is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --------------------------------------------------------------------------
   -- To_CHS (Values -> Layout)
   --------------------------------------------------------------------------
   function To_CHS (CHS : CHS_Type) return CHS_Layout_Type is
   begin
      return (CHS.H, CHS.S, CHS.C / 256, CHS.C mod 256);
   end To_CHS;

   --------------------------------------------------------------------------
   -- To_CHS (Layout -> Values)
   --------------------------------------------------------------------------
   function To_CHS (CHS : CHS_Layout_Type) return CHS_Type is
   begin
      return (CHS.CH * 256 + CHS.CL, CHS.H, CHS.S);
   end To_CHS;

   --------------------------------------------------------------------------
   -- CHS_To_LBA
   --------------------------------------------------------------------------
   -- LBA = (C × HPC + H) × SPT + (S - 1)
   --------------------------------------------------------------------------
   function CHS_To_LBA (CHS : CHS_Type; CHS_Geometry : CHS_Type) return LBA_Type is
   begin
      return LBA_Type ((CHS.C * CHS_Geometry.H + CHS.H) * CHS_Geometry.S + (CHS.S - 1));
   end CHS_To_LBA;

   --------------------------------------------------------------------------
   -- LBA_To_CHS
   --------------------------------------------------------------------------
   -- Mapping from an LBA (0-based) to a CHS triplet (with underlying disk
   -- geometry (CYL, HPC, SPT) specified in CHS_Geometry:
   -- C = LBA ÷ (HPC × SPT)
   -- H = (LBA ÷ SPT) mod HPC
   -- S = (LBA mod SPT) + 1
   --------------------------------------------------------------------------
   function LBA_To_CHS (Sector_Number : LBA_Type; CHS_Geometry : CHS_Type) return CHS_Type is
      Result : CHS_Type;
   begin
      Result.C := Natural (Sector_Number) / (CHS_Geometry.H * CHS_Geometry.S);
      Result.H := (Natural (Sector_Number) / CHS_Geometry.S) rem CHS_Geometry.H;
      Result.S := (Natural (Sector_Number) rem CHS_Geometry.S) + 1;
      return Result;
   end LBA_To_CHS;

end BlockDevices;
