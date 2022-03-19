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

with MIPS32;
with Malta;
with IOEMU;
with Console;

package body Exceptions is

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
   procedure Process (Exception_Number : in Unsigned_32) is
      pragma Unreferenced (Exception_Number);
   begin
      -- Console.Print (MIPS32.CP0_Count_Read, NL => True);
      if True then
         -- IOEMU "TIMER" LED blinking
         IOEMU.IOEMU_IO0 := 1;
         IOEMU.IOEMU_IO0 := 0;
      end if;
   end Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      null;
   end Init;

end Exceptions;
