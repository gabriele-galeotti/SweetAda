-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with ATmega128A;
with CPU;

package body BSP
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use ATmega128A;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
   is
   begin
      -------------------------------------------------------------------------
      Tick_Count := 0;
      -------------------------------------------------------------------------
      DDRA (0) := True;
      DDRA (1) := True;
      loop
         PORTA (0) := True;
         PORTA (1) := True;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         PORTA (0) := False;
         PORTA (1) := False;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
         for Delay_Loop_Count in 1 .. 30_000 loop CPU.NOP; end loop;
      end loop;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
