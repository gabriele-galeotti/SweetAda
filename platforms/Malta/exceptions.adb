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

with Interfaces;
with Core;
with MIPS32;
with Malta;
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
      declare
         Count : Unsigned_32;
      begin
         Malta.Count_Expire := Malta.Count_Expire + Malta.CP0_TIMER_COUNT;
         MIPS32.CP0_Compare_Write (Malta.Count_Expire);
         Count := MIPS32.CP0_Count_Read;
         -- check for missed any timer interrupts
         if Count - Malta.Count_Expire < 16#7FFF_FFFF# then
            -- increment a "missed timer count"
            Malta.Count_Expire := Count + Malta.CP0_TIMER_COUNT;
            MIPS32.CP0_Compare_Write (Malta.Count_Expire);
         end if;
      end;
      Core.Tick_Count := Core.Tick_Count + 1;
      if Core.Tick_Count mod 100 = 0 then
         -- IOEMU "TIMER" LED blinking
         IOEMU.IOEMU_IO0 := 1;
         IOEMU.IOEMU_IO0 := 0;
      end if;
   end Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is null;

end Exceptions;
