-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System.Storage_Elements;
with AVR;
-- with ATmega128A;
with ATmega328P;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   -- use ATmega128A;
   use ATmega328P;

   procedure Delay_Simple (NLoops : in Natural);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Delay_Simple
   ----------------------------------------------------------------------------
   procedure Delay_Simple (NLoops : in Natural) is
   begin
      for L in 1 .. NLoops loop
         -- for Delay_Loop_Count in Integer'First .. Integer'Last loop
         for Delay_Loop_Count in 1 .. 2 loop
            AVR.NOP;
         end loop;
      end loop;
   end Delay_Simple;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      NBlinks : Integer := 6;
   begin
      -- GPIO PIN 13 blink test -----------------------------------------------
      -- on-board LED is an output
      DDRB := (DDB5 => True, others => False);
      for N in 1 .. NBlinks loop
         PORTB.PORTB5 := True;
         Delay_Simple (4);
         PORTB.PORTB5 := False;
         Delay_Simple (8);
      end loop;
      Delay_Simple (32);
      NBlinks := 3;
      -------------------------------------------------------------------------
      if False then
         loop
            for N in 1 .. NBlinks loop
               PORTB.PORTB5 := True;
               Delay_Simple (4);
               PORTB.PORTB5 := False;
               Delay_Simple (8);
            end loop;
            Delay_Simple (32);
         end loop;
      end if;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
