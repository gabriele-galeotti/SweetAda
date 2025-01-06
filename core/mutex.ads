-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mutex.ads                                                                                                 --
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

pragma Restrictions (No_Elaboration_Code);

with LLutils;

package Mutex
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Semaphore_Binary is record
      Lock : aliased LLutils.Atomic_Type with Volatile => True;
   end record;

   SEMAPHORE_UNLOCKED : constant Semaphore_Binary := (Lock => 0);

   ----------------------------------------------------------------------------
   -- Acquire
   ----------------------------------------------------------------------------
   procedure Acquire
      (S : in out Semaphore_Binary)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Release
   ----------------------------------------------------------------------------
   procedure Release
      (S : in out Semaphore_Binary)
      with Inline => True;

end Mutex;
