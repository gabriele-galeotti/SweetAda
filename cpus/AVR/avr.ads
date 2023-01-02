-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ avr.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;

package AVR is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;
   procedure RET with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;

end AVR;
