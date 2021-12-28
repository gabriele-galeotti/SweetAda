-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ml605.ads                                                                                                 --
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
with System.Storage_Elements;
with Interfaces;
with Bits;
with MicroBlaze;

package ML605 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use MicroBlaze;

   SPI_BASEADDRESS       : constant := 16#40A0_0000#;
   MEMORY_BASEADDRESS    : constant := 16#5000_0000#;
   FLASH_BASEADDRESS     : constant := 16#8600_0000#;
   INTC_BASEADDRESS      : constant := 16#8180_0000#;
   TIMER_BASEADDRESS     : constant := 16#83C0_0000#;
   -- __FIX__ serial_mm_init() in petalogix_ml605_mmu.c:petalogix_ml605_init()
   UART16550_BASEADDRESS : constant := 16#83E0_0000# + 16#0000_1000#;
   AXIENET_BASEADDRESS   : constant := 16#8278_0000#;
   AXIDMA_BASEADDRESS    : constant := 16#8460_0000#;

   Timer : XPS_Timer_Type with
      Address    => To_Address (TIMER_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure Tclk_Init;

   TIMER_IRQ : constant := 16#0000_0004#;

   INTC : XPS_INTC_Type with
      Address    => To_Address (INTC_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure INTC_Init;

end ML605;
