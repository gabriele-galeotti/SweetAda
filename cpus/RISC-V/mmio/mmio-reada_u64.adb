-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmio-reada_u64.adb                                                                                        --
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

with GCC.Defines;

separate (MMIO)
function ReadA_U64
   (Memory_Address : System.Address)
   return Interfaces.Unsigned_64
   is
   function Atomic_Load
      (Object_Address : System.Address;
       Memory_Order   : Integer)
      return Interfaces.Unsigned_64
      with Import        => True,
           Convention    => Intrinsic,
           External_Name => "__atomic_load_8";
begin
   return Atomic_Load (Memory_Address, GCC.Defines.ATOMIC_SEQ_CST);
end ReadA_U64;
