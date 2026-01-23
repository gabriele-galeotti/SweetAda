-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl031.ads                                                                                                 --
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

with System;
with Time;

package PL031
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- ARM PrimeCellTM
   -- Real Time Clock (PL031)
   -- Technical Reference Manual
   -- ARM DDI 0224B
   ----------------------------------------------------------------------------

   type Descriptor_Type is record
      Base_Address : Address;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Base_Address => Null_Address
      );

   procedure Read_Clock
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time);

   procedure Init
      (D : in Descriptor_Type);

pragma Style_Checks (On);

end PL031;
