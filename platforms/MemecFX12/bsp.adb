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

with System;
with System.Storage_Elements;
with MemecFX12;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use MemecFX12;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   -- procedure Console_Putchar (C : in Character) is null;
   -- procedure Console_Getchar (C : out Character) is null;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      LED_3STATE := 16#FFFF_FFFD#;
      LCD_Init;
      LCD_Write (To_Address (XPAR_LCD_CONTROLLER_0_BASEADDR), "SweetAda");
      LCD_Line (To_Address (XPAR_LCD_CONTROLLER_0_BASEADDR), 2);
      LCD_Write (To_Address (XPAR_LCD_CONTROLLER_0_BASEADDR), "Memec FX12");
      LCD_Line (To_Address (XPAR_LCD_CONTROLLER_0_BASEADDR), 1);
      loop
         LED_IO := LED_IO or 16#0000_0002#;
         Wait (500_000);
         LED_IO := LED_IO and 16#FFFF_FFFD#;
         Wait (500_000);
      end loop;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
