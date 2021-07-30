-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with M68k;

package CPU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   ----------------------------------------------------------------------------
   -- Standard subprograms
   ----------------------------------------------------------------------------

   procedure Asm_Call (Target_Address : in System.Address) renames M68k.Asm_Call;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is M68k.Irq_State_Type;

   procedure Irq_Enable                                    renames M68k.Irq_Enable;
   procedure Irq_Disable                                   renames M68k.Irq_Disable;
   function Irq_State_Get return Irq_State_Type            renames M68k.Irq_State_Get;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) renames M68k.Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   subtype Lock_Type is M68k.Lock_Type;

   procedure Lock_Try (Lock_Object : in out M68k.Lock_Type; Success : out Boolean) renames M68k.Lock_Try;
   procedure Lock (Lock_Object : in out M68k.Lock_Type)                            renames M68k.Lock;
   procedure Unlock (Lock_Object : out M68k.Lock_Type)                             renames M68k.Unlock;

end CPU;
