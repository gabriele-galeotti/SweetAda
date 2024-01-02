-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Configure;
with Abort_Library;
with LLutils;
with SPARC;
with Sun4m;
with Z8530;
with BSP;
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

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Abort_Library;
   use LLutils;
   use SPARC;

   Trap_Table : array (Natural range 0 .. 255) of aliased TrapTable_Item_Type;

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
      Console.Print ("*** EXCEPTION", NL => True);
      System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process is
   begin
      if Sun4m.SIPR.T then
         BSP.Tick_Count := @ + 1;
         if Configure.USE_QEMU_IOEMU then
            if BSP.Tick_Count mod 1_000 = 0 then
               -- IOEMU "TIMER" LED blinking
               IOEMU.IO0 := 1;
               IOEMU.IO0 := 0;
            end if;
         end if;
         Sun4m.System_Timer_ClearLR;
      elsif Sun4m.SIPR.S then
         declare
            C : Character;
         begin
            BSP.Console_Getchar (C);
            BSP.Console_Putchar (C);
         end;
      end if;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      Trap_Template  : TrapTable_Item_Type;
      Vector_Address : Address;
      Displacement   : Storage_Offset;
      function To_U32 is new Ada.Unchecked_Conversion (Storage_Offset, Unsigned_32);
   begin
      -------------------------------------------------------------------------
      Trap_Template.Code (1) := Opcode_NOP;
      Trap_Template.Code (2) := Opcode_NOP;
      Trap_Template.Code (3) := Opcode_NOP;
      for Index in Trap_Table'Range loop
         Vector_Address := To_Address (Integer_Address (16#100# + Index));
         Displacement := Address_Displacement (Vector_Address, Trap_Table (Index).Code (0)'Address, 2);
         Trap_Template.Code (0) := Opcode_BRANCH_ALWAYS or (To_U32 (Displacement) and 16#003F_FFFF#);
         Trap_Table (Index) := Trap_Template;
      end loop;
      -------------------------------------------------------------------------
   end Init;

end Exceptions;
