-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with System.Machine_Code;
with Interfaces;
with Definitions;
with Bits;
with Core;
with RISCV;
with HiFive1;
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
   use Bits;
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
      if (RISCV.MCAUSE_Read and 16#8000_0000#) = 0 then
         Console.Print (RISCV.MCAUSE_Read, NL => True);
         loop null; end loop;
      else
         Tick_Count := @ + 1;
         HiFive1.UART0.txdata.txdata := To_U8 ('T');
         RISCV.MTimeCmp := RISCV.MTime + 16#3200#;
      end if;
   end Timer_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      null;
   end Init;

end Exceptions;
