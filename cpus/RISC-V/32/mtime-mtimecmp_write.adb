-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mtime-mtimecmp_write.adb                                                                                  --
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

with Bits;
with RISCV;

separate (MTIME)
procedure mtimecmp_Write
   (Value : in Unsigned_64)
   is
   mtimecmp_mmap : aliased RISCV.mtime_Type
      with Import        => True,
           Convention    => Ada,
           External_Name => "_riscv_mtimecmp_mmap";
begin
   mtimecmp_mmap.H := 16#FFFF_FFFF#;
   mtimecmp_mmap.L := Bits.LWord (Value);
   mtimecmp_mmap.H := Bits.HWord (Value);
end mtimecmp_Write;
