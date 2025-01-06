-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with ARMv8A;
with Virt;
with BSP;
with Console;

package body Exceptions
   is

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

   EL3_Table : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "el3_table";
   EL2_Table : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "el2_table";
   EL1_Table : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "el1_table";

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
   procedure Exception_Process
      is
   begin
      Console.Print ("*** EXCEPTION", NL => True);
      loop null; end loop;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
      is
   begin
      BSP.Tick_Count := @ + 1;
      Virt.GICD.GICD_ICPENDR (0)(30) := True;
      BSP.Timer_Reload;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      EL : Bits_2;
      function To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);
   begin
      EL := ARMv8A.CurrentEL_Read.EL;
      if EL = ARMv8A.EL3 then
         ARMv8A.VBAR_EL3_Write (To_U64 (EL3_Table'Address));
      end if;
      if EL >= ARMv8A.EL2 then
         ARMv8A.VBAR_EL2_Write (To_U64 (EL2_Table'Address));
      end if;
      ARMv8A.VBAR_EL1_Write (To_U64 (EL1_Table'Address));
   end Init;

end Exceptions;
