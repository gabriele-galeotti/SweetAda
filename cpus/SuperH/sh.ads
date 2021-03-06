-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh.ads                                                                                                    --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Bits;

package SH is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   type Irq_State_Type is new Integer;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   LOCK_UNLOCK : constant Bits.CPU_Unsigned := 0;
   LOCK_LOCK   : constant Bits.CPU_Unsigned := 1;

   type Lock_Type is
   record
      Lock : aliased Bits.CPU_Unsigned := LOCK_UNLOCK with Atomic => True;
   end record with
      Size => Bits.CPU_Unsigned'Size;

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean);
   procedure Lock (Lock_Object : in out Lock_Type);
   procedure Unlock (Lock_Object : out Lock_Type);

end SH;
