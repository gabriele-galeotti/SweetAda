-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mutex.adb                                                                                                 --
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

with System;
with GCC_Defines;
with CPU;

package body Mutex
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use LLutils;
   use type Atomic_Type'Base;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Acquire
   ----------------------------------------------------------------------------
   procedure Acquire
      (S : in out Semaphore_Binary)
      is
      procedure Wait
         (Object_Address : in System.Address)
         with Inline => True;
      procedure Wait
         (Object_Address : in System.Address)
         is
      begin
         while Atomic_Load (Object_Address, GCC_Defines.ATOMIC_SEQ_CST) /= 0 loop
            CPU.NOP;
         end loop;
      end Wait;
   begin
      loop
         if not Atomic_Test_And_Set (S.Lock'Address, GCC_Defines.ATOMIC_SEQ_CST) then
            return;
         end if;
         Wait (S.Lock'Address);
      end loop;
   end Acquire;

   ----------------------------------------------------------------------------
   -- Release
   ----------------------------------------------------------------------------
   procedure Release
      (S : in out Semaphore_Binary)
      is
   begin
      Atomic_Clear (S.Lock'Address, GCC_Defines.ATOMIC_SEQ_CST);
   end Release;

end Mutex;
