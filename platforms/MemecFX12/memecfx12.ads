-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memecfx12.ads                                                                                             --
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
with Interfaces;

package MemecFX12
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   -- xparameters.h
   XPAR_XPS_GPIO_0_BASEADDR_IO     : constant := 16#8100_0000#;
   XPAR_XPS_GPIO_0_BASEADDR_3STATE : constant := 16#8100_0004#;
   XPAR_LCD_CONTROLLER_0_BASEADDR  : constant := 16#8500_0000#;

   -- LED
   LED_IO : aliased Unsigned_32
      with Address    => System'To_Address (XPAR_XPS_GPIO_0_BASEADDR_IO),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   LED_3STATE : aliased Unsigned_32
      with Address    => System'To_Address (XPAR_XPS_GPIO_0_BASEADDR_3STATE),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   LCD : aliased Unsigned_32
      with Address    => System'To_Address (XPAR_LCD_CONTROLLER_0_BASEADDR),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   procedure Wait
      (Loops : in Positive);
   procedure LCD_Display_Update
      (Base_Address : in System.Address;
       Data         : in Unsigned_8;
       Mode         : in Unsigned_32);
   procedure LCD_Write
      (Base_Address : in System.Address;
       S            : in String);
   procedure LCD_Clear
      (Base_Address : in System.Address);
   procedure LCD_Line
      (Base_Address : in System.Address;
       Line         : in Integer);
   procedure LCD_Init;

end MemecFX12;
