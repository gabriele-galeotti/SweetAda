-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7.ads                                                                                                 --
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

with Interfaces;
with ARMv6;

package ARMv7 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use Interfaces;

   -- Auxiliary Control Register
   -- IMPLEMENTATION DEFINED

   subtype ACTLR_Type is ARMv6.ACTLR_Type;
   ACTLR_ADDRESS renames ARMv6.ACTLR_ADDRESS;

   -- CPUID Base Register

   subtype CPUID_Type is ARMv6.CPUID_Type;
   CPUID : CPUID_Type renames ARMv6.CPUID;
   function To_U32 (S : CPUID_Type) return Unsigned_32 renames ARMv6.To_U32;

   -- Interrupt Control and State Register

   subtype ICSR_Type is ARMv6.ICSR_Type;
   ICSR : ICSR_Type renames ARMv6.ICSR;

   -- Vector Table Offset Register

   subtype VTOR_Type is ARMv6.VTOR_Type;
   VTOR : VTOR_Type renames ARMv6.VTOR;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP renames ARMv6.NOP;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable  renames ARMv6.Irq_Enable;
   procedure Irq_Disable renames ARMv6.Irq_Disable;

end ARMv7;
