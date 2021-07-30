-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp-board_init.adb                                                                                        --
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

   separate (BSP)
   procedure Board_Init is
      -------------------------------------------------------------------------
      -- ALi M5213 configuration
      -------------------------------------------------------------------------
      procedure ALiM5123_Init;
      procedure ALiM5123_Init is
         CONFIG_PORT : constant Unsigned_16 := 16#03F0#; -- 16#0370#
         INDEX_PORT  : constant Unsigned_16 := 16#03F0#; -- 16#0370#
         DATA_PORT   : constant Unsigned_16 := 16#03F1#; -- 16#0371#
      begin
         -- enter configuration mode
         IO.PortOut (CONFIG_PORT, Unsigned_8'(16#51#));
         IO.PortOut (CONFIG_PORT, Unsigned_8'(16#23#));
         -- select PPI = logical device #3
         IO.PortOut (INDEX_PORT, Unsigned_8'(16#07#));
         IO.PortOut (DATA_PORT, Unsigned_8'(16#03#));
         IO.PortOut (INDEX_PORT, Unsigned_8'(16#30#));
         IO.PortOut (DATA_PORT, Unsigned_8'(16#01#));
         -- select UART1 = logical device #4
         IO.PortOut (INDEX_PORT, Unsigned_8'(16#07#));
         IO.PortOut (DATA_PORT, Unsigned_8'(16#04#));
         IO.PortOut (INDEX_PORT, Unsigned_8'(16#30#));
         IO.PortOut (DATA_PORT, Unsigned_8'(16#01#));
         -- select UART2 = logical device #5
         IO.PortOut (INDEX_PORT, Unsigned_8'(16#07#));
         IO.PortOut (DATA_PORT, Unsigned_8'(16#05#));
         IO.PortOut (INDEX_PORT, Unsigned_8'(16#30#));
         IO.PortOut (DATA_PORT, Unsigned_8'(16#01#));
         -- RTC is enabled by default
         -- select RTC = logical device #6
         -- IO.PortOut (INDEX_PORT, Unsigned_8'(16#07#));
         -- IO.PortOut (DATA_PORT, Unsigned_8'(16#06#));
         -- IO.PortOut (INDEX_PORT, Unsigned_8'(16#30#));
         -- IO.PortOut (DATA_PORT, Unsigned_8'(16#01#));
         -- exit configuration mode
         IO.PortOut (CONFIG_PORT, Unsigned_8'(16#BB#));
      end ALiM5123_Init;
      -------------------------------------------------------------------------
   begin
      ALiM5123_Init;
   end Board_Init;
