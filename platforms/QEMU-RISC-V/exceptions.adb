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

with System.Machine_Code;
with System.Storage_Elements;
with Interfaces;
with Bits;
with RISCV;
with MTIME;
with Configure;
with Virt;
with BSP;
with Console;
with IOEMU;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use RISCV;

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
      mcause : mcause_Type;
   begin
      mcause := mcause_Read;
      if mcause.Interrupt then
         BSP.Tick_Count := @ + 1;
         if Configure.USE_QEMU_IOEMU then
            -- IRQ pulsemeter
            IOEMU.IO0 := 1;
         end if;
         Virt.Timer_Value := @ + Virt.Timer_Constant;
         MTIME.mtimecmp_Write (Virt.Timer_Value);
      else
         Console.Print (MXLEN_Type (mcause.Exception_Code), Prefix => "***", NL => True);
         Console.Print (mepc_Read, Prefix => "***", NL => True);
         loop null; end loop;
      end if;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Vectors : aliased Asm_Entry_Point
         with Import        => True,
              Convention    => Asm,
              External_Name => "vectors";
   begin
      mtvec_Write ((
         MODE => MODE_Direct,
         BASE => mtvec_BASE_Type (Shift_Right (MXLEN_Type (To_Integer (Vectors'Address)), 2))
         ));
   end Init;

end Exceptions;
