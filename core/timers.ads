-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ timers.ads                                                                                                --
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

with System;
with Interfaces;

package Timers
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;

   type Timer_Type;
   type Timer_Ptr is access all Timer_Type;

   type Timer_Proc is access procedure (A : in Address);

   type Timer_Type is record
      Expire : Unsigned_32;
      Next   : aliased Timer_Ptr;
      Proc   : Timer_Proc;
      Data   : Address;
   end record;

   procedure Add
      (T : in Timer_Ptr);
   function Delete
      (T : Timer_Ptr)
      return Boolean;
   procedure Process;

end Timers;
