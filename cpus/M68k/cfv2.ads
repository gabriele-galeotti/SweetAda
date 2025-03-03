-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cfv2.ads                                                                                                  --
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
with M68k;

package CFv2
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

   subtype SR_Type is M68k.SR_Type;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   function SR_Read
      return SR_Type
      renames M68k.SR_Read;

   procedure SR_Write
      (Value : in SR_Type)
      renames M68k.SR_Write;

   procedure NOP
      with Inline => True;

   procedure STOP
      with Inline => True;

   procedure BREAKPOINT
      with Inline => True;

   procedure VBR_Set
      (VBR_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Vector_Type is Address;

   subtype Vector_Number_Type is Natural range 0 .. 255;

   IVT : aliased array (Vector_Number_Type) of Vector_Type
      with Import     => True,
           Convention => Ada;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

end CFv2;
