-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh.ads                                                                                                    --
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
with SH_Definitions;

package SH
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

   subtype SR_Type is SH_Definitions.SR_Type;

   -- IMASK levels
   IMASK0 : constant := 0;
   IMASK1 : constant := 1;
   IMASK2 : constant := 2;
   IMASK3 : constant := 3;
   IMASK4 : constant := 4;
   IMASK5 : constant := 5;
   IMASK6 : constant := 6;
   IMASK7 : constant := 7;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   function SR_Read
      return SR_Type
      with Inline => True;
   procedure SR_Write
      (SR : in SR_Type)
      with Inline => True;

   procedure VBR_Set
      (VBR : in Address)
      with Inline => True;

   procedure NOP
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is SR_Type;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end SH;
