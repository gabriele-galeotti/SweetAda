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

with System;
with System.Storage_Elements;
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
   procedure Process (Exception_Number : in Interfaces.Unsigned_32) is
      pragma Unreferenced (Exception_Number);
   begin
      Timer.TCSR0.T0INT := 0;    -- clear Timer flag
      INTC.IAR := 16#FFFF_FFFF#; -- clear INTC flag
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
      Memory_Functions.Cpymem (
                               Linker.EText'Address, -- .vectors section
                               SSE.To_Address (0),   -- LMB RAM @ 0
                               256
                              );
   end Init;

end Exceptions;
