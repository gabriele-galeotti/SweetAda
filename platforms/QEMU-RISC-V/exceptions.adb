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
with Configure;
with Virt;
with BSP;
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
      BSP.Tick_Count := @ + 1;
      if Configure.USE_QEMU_IOEMU then
         -- IRQ pulsemeter
         IOEMU.IO0 := 1;
      end if;
      RISCV.mtimecmp_Write (RISCV.mtime_Read + Virt.Timer_Constant);
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Vectors      : aliased Asm_Entry_Point
         with Import        => True,
              Convention    => Asm,
              External_Name => "vectors";
      Base_Address : Bits_30;
   begin
      Base_Address := Bits_30 (Shift_Right (Unsigned_32 (To_Integer (Vectors'Address)), 2));
      RISCV.mtvec_Write ((MODE => RISCV.MODE_Direct, BASE => Base_Address));
   end Init;

end Exceptions;
