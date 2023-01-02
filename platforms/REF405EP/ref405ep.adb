-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ref405ep.adb                                                                                              --
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

with Configure;
with PowerPC;
with PPC405;

package body REF405EP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use PowerPC;
   use PPC405;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
      Period    : constant := (Configure.TIMER_SYSCLK + Configure.TICK_FREQUENCY / 2) / Configure.TICK_FREQUENCY;
      TCR_Value : TCR_Register_Type;
   begin
      TCR_Value.PIE := True;
      TCR_Value.ARE := True;
      TCR_Write (TCR_Value);
      PIT_Write (Period);
   end Tclk_Init;

end REF405EP;
