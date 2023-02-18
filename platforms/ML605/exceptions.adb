-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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
with Interfaces;
with Configure;
with Core;
with Linker;
with Memory_Functions;
with ML605;
with IOEMU;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use ML605;

   package SSE renames System.Storage_Elements;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Process
   ----------------------------------------------------------------------------
   procedure Process is
   begin
      Timer.TCSR0.T0INT := False; -- clear Timer flag
      Core.Tick_Count := @ + 1;
      if Configure.USE_QEMU_IOEMU then
         if Core.Tick_Count mod 1_000 = 0 then
            -- IOEMU "TIMER" LED blinking
            IOEMU.IO0 := 1;
            IOEMU.IO0 := 0;
         end if;
      end if;
      INTC.IAR (TIMER_IRQ) := True; -- clear INTC flag
   end Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      Memory_Functions.Cpymem (
                               Linker.EText'Address, -- .vectors section
                               SSE.To_Address (0),   -- LMB RAM @ 0
                               256
                              );
   end Init;

end Exceptions;
