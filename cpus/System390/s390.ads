-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ s390.ads                                                                                                  --
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
with Bits;

package S390
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Bits;

   type PSWT is record
      Reserved1   : Bits_32;
      Reserved2   : Bits_1;
      New_Address : Bits_31;
   end record
      with Alignment => 8,
           Bit_Order => High_Order_First,
           Size      => 64;
   for PSWT use record
      Reserved1   at 0 range  0 .. 31;
      Reserved2   at 0 range 32 .. 32;
      New_Address at 0 range 33 .. 63;
   end record;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Integer;

   procedure Irq_Enable;
   procedure Irq_Disable;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   LOCK_UNLOCK : constant CPU_Unsigned := 0;
   LOCK_LOCK   : constant CPU_Unsigned := 1;

   type Lock_Type is record
      Lock : aliased CPU_Unsigned := LOCK_UNLOCK with Atomic => True;
   end record
      with Size => CPU_Unsigned'Size;

   procedure Lock_Try
      (Lock_Object : in out Lock_Type;
       Success     :    out Boolean);
   procedure Lock
      (Lock_Object : in out Lock_Type);
   procedure Unlock
      (Lock_Object : out Lock_Type);

end S390;
