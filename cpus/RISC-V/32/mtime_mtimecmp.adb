-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mtime.adb                                                                                                 --
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

package body MTime_MTimeCmp is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function MTIME_Read return Unsigned_64 is
      L : Unsigned_32;
      H : Unsigned_32;
   begin
      loop
         H := MTime.H;
         L := MTime.L;
         exit when H = MTime.H;
      end loop;
      return Make_Word (H, L);
   end MTIME_Read;

   procedure MTIMECMP_Write (Value : in Unsigned_64) is
   begin
      MTimeCmp.H := 16#FFFF_FFFF#;
      MTimeCmp.L := LWord (Value);
      MTimeCmp.H := HWord (Value);
   end MTIMECMP_Write;

end MTime_MTimeCmp;
