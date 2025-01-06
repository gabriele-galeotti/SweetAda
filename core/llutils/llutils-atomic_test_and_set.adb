-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils-atomic_test_and_set                                                                               --
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

separate (LLutils)
function Atomic_Test_And_Set
   (Object_Address : System.Address;
    Memory_Order   : Integer)
   return Boolean
   is
   function ATAS
      (OA : System.Address;
       MO : Integer)
      return Boolean
      with Import        => True,
           Convention    => Intrinsic,
           External_Name => "__atomic_test_and_set";
begin
   return ATAS (Object_Address, Memory_Order);
end Atomic_Test_And_Set;
