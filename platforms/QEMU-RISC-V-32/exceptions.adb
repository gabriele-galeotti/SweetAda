-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with System.Machine_Code;
with Interfaces;
with Definitions;
with Core;
with RISCV;
with IOEMU;
with Console;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Interfaces;
   use Core;

   CRLF : String renames Definitions.CRLF;

   procedure Timer_Process with
      Export        => True,
      Convention    => Asm,
      External_Name => "timer_process";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Timer_Process
   ----------------------------------------------------------------------------
   procedure Timer_Process is
   begin
      Tick_Count := @ + 1;
      if Tick_Count mod 1000 = 0 then
         -- "TIMER" LED blinking
         IOEMU.IOEMU_IO0 := 16#FF#;
         IOEMU.IOEMU_IO0 := 16#00#;
      end if;
      RISCV.MTimeCmp := RISCV.MTime + 16#3200#;
   end Timer_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      null;
   end Init;

end Exceptions;
