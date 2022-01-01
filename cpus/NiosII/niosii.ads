-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ niosii.ads                                                                                                --
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

with System;
with Interfaces;

package NiosII is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use Interfaces;

   PIE : constant Unsigned_32 := 2#0000_0000_0000_0000_0000_0000_0000_0001#;
   U   : constant Unsigned_32 := 2#0000_0000_0000_0000_0000_0000_0000_0010#;
   EH  : constant Unsigned_32 := 2#0000_0000_0000_0000_0000_0000_0000_0100#;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   function CPUID return Unsigned_32 with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Irq handling
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Boolean;

   procedure Irq_Enable (Irq_Line : in Natural) with
      Inline => True;
   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

end NiosII;
