-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mtime-mtime_read.adb                                                                                      --
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

with Bits;
with RISCV;

separate (MTIME)
function mtime_Read
   return Unsigned_64
   is
   mtime_mmap : aliased RISCV.mtime_Type
      with Import        => True,
           Convention    => Ada,
           External_Name => "_riscv_mtime_mmap";
   L          : Unsigned_32;
   H          : Unsigned_32;
begin
   loop
      H := mtime_mmap.H;
      L := mtime_mmap.L;
      exit when H = mtime_mmap.H;
   end loop;
   return Bits.Make_Word (H, L);
end mtime_Read;
