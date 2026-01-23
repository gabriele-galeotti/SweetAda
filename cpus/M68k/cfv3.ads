-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cfv3.ads                                                                                                  --
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
with CFv2;

package CFv3
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

   -- MOVEC register codes
   VBR    renames CFv2.VBR;
   RAMBAR renames CFv2.RAMBAR;
   MBAR   renames CFv2.MBAR;

   subtype SR_Type is CFv2.SR_Type;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   function SR_Read
      return SR_Type
      renames CFv2.SR_Read;

   procedure SR_Write
      (Value : in SR_Type)
      renames CFv2.SR_Write;

   procedure NOP
      renames CFv2.NOP;

   procedure STOP
      renames CFv2.STOP;

   procedure BREAKPOINT
      renames CFv2.BREAKPOINT;

   procedure VBR_Set
      (VBR_Address : in Address)
      renames CFv2.VBR_Set;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Vector_Type is CFv2.Vector_Type;

   subtype Vector_Number_Type is CFv2.Vector_Number_Type;

   IVT : aliased array (Vector_Number_Type) of Vector_Type
      with Import     => True,
           Convention => Ada;

   procedure Irq_Enable
      renames CFv2.Irq_Enable;
   procedure Irq_Disable
      renames CFv2.Irq_Disable;

end CFv3;
