-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu.ads                                                                                                   --
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
with M68k;

package CPU
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

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      renames M68k.NOP;

   procedure Asm_Call
      (Target_Address : in Address)
      renames M68k.Asm_Call;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is M68k.Intcontext_Type;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      renames M68k.Intcontext_Get;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      renames M68k.Intcontext_Set;

   procedure Irq_Enable
      renames M68k.Irq_Enable;
   procedure Irq_Disable
      renames M68k.Irq_Disable;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   subtype Lock_Type is M68k.Lock_Type;

   procedure Lock_Try
      (Lock_Object : in out M68k.Lock_Type;
       Success     :    out Boolean)
      renames M68k.Lock_Try;
   procedure Lock
      (Lock_Object : in out M68k.Lock_Type)
      renames M68k.Lock;
   procedure Unlock
      (Lock_Object : out M68k.Lock_Type)
      renames M68k.Unlock;

end CPU;
