-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmio-reada_u16.adb                                                                                        --
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

separate (MMIO)
function ReadA_U16
   (Memory_Address : System.Address)
   return Interfaces.Unsigned_16
   is
   ATOMIC_SEQ_CST : constant Integer := 5;
   function Atomic_Load
      (Ptr      : System.Address;
       Memorder : Integer)
      return Interfaces.Unsigned_16
      with Import        => True,
           Convention    => Intrinsic,
           External_Name => "__atomic_load_2";
begin
   return Atomic_Load (Memory_Address, ATOMIC_SEQ_CST);
end ReadA_U16;
