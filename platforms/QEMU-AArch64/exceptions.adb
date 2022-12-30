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
with Ada.Unchecked_Conversion;
with Interfaces;
with Core;
with Bits;
with ARMv8A;
with Virt;
with IOEMU;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Exception_Process
   ----------------------------------------------------------------------------
   procedure Exception_Process is
   begin
      Core.Tick_Count := @ + 1;
      if Core.Tick_Count mod 1_000 = 0 then
         -- IOEMU "TIMER" LED blinking
         IOEMU.IOEMU_IO0 := 1;
         IOEMU.IOEMU_IO0 := 0;
      end if;
      Virt.GICD_ICPENDR (30) := True;
      Virt.Timer_Reload;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      EL1_Table : aliased Asm_Entry_Point with
         Import        => True,
         Convention    => Asm,
         External_Name => "el1_table";
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      ARMv8A.VBAR_EL1_Write (To_U64 (EL1_Table'Address));
   end Init;

end Exceptions;
