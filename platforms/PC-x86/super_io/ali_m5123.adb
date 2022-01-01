-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ali_m5123.adb                                                                                             --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Interfaces;
with CPU.IO;

package body ALi_M5123 is

   CONFIG_Port : constant Interfaces.Unsigned_16 := 16#03F0#; -- 16#0370#
   INDEX_Port  : constant Interfaces.Unsigned_16 := 16#03F0#; -- 16#0370#
   DATA_Port   : constant Interfaces.Unsigned_16 := 16#03F1#; -- 16#0371#

   ----------------------------------------------------------------------------
   -- ALi M5213 configuration
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -- enter configuration mode
      CPU.IO.PortOut (CONFIG_Port, Interfaces.Unsigned_8'(16#51#));
      CPU.IO.PortOut (CONFIG_Port, Interfaces.Unsigned_8'(16#23#));
      -- select PPI = logical device #3
      CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#07#));
      CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#03#));
      CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#30#));
      CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#01#));
      -- select UART1 = logical device #4
      CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#07#));
      CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#04#));
      CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#30#));
      CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#01#));
      -- select UART2 = logical device #5
      CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#07#));
      CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#05#));
      CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#30#));
      CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#01#));
      -- RTC is enabled by default
      -- select RTC = logical device #6
      -- CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#07#));
      -- CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#06#));
      -- CPU.IO.PortOut (INDEX_Port, Interfaces.Unsigned_8'(16#30#));
      -- CPU.IO.PortOut (DATA_Port, Interfaces.Unsigned_8'(16#01#));
      -- exit configuration mode
      CPU.IO.PortOut (CONFIG_Port, Interfaces.Unsigned_8'(16#BB#));
   end Setup;
   ----------------------------------------------------------------------------

end ALi_M5123;
