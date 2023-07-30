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
with Definitions;
with Bits;
with RISCV;
with HiFive1;
with Console;
with BSP;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

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
   procedure Exception_Process is
      Cause : Unsigned_32;
   begin
      Cause := RISCV.mcause_Read;
      if (Cause and 16#8000_0000#) = 0 then
         Console.Print (Cause, NL => True);
         loop null; end loop;
      else
         BSP.Tick_Count := @ + 1;
         RISCV.mtimecmp_Write (RISCV.mtime_Read + BSP.mtime_Offset);
         if BSP.Tick_Count mod 1_000 = 0 then
            Console.Print ("T", NL => False);
         end if;
      end if;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      Vectors      : aliased Asm_Entry_Point with
         Import        => True,
         Convention    => Asm,
         External_Name => "vectors";
      Base_Address : Bits_30;
   begin
      Base_Address := Bits_30 (Shift_Right (Unsigned_32 (To_Integer (Vectors'Address)), 2));
      RISCV.mtvec_Write ((MODE => RISCV.MODE_Direct, BASE => Base_Address));
   end Init;

end Exceptions;
