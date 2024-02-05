-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with Bits;
with ARMv7M;
with MSP432P401R;
with Exceptions;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Bits;

   procedure SysTick_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init
      is
   begin
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (16#800#);
      ARMv7M.SHPR3.PRI_15 := 16#01#;
      ARMv7M.SYST_CVR.CURRENT := 0;
      ARMv7M.SYST_CSR :=
         (ENABLE    => True,
          TICKINT   => True,
          CLKSOURCE => ARMv7M.CLKSOURCE_CPU,
          COUNTFLAG => False,
          others    => <>);
   end SysTick_Init;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      null;
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- stop WDT -------------------------------------------------------------
      MSP432P401R.WDTCTL := 16#5A84#;
      -- Console --------------------------------------------------------------
      -- Console.Console_Descriptor.Write := Console_Putchar'Access;
      -- Console.Console_Descriptor.Read  := Console_Getchar'Access;
      -------------------------------------------------------------------------
      ARMv7M.Irq_Enable;
      ARMv7M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
