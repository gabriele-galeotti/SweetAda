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

with Abort_Library;
with ARMv7A;
with ZynqA9;
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
      (VectorN : in Unsigned_32;
       LR      : in Unsigned_32)
      is
   begin
      Console.Print ("*** EXCEPTION", NL => True);
      case VectorN is
         when ARMv7A.Reset                 =>
            Console.Print (ARMv7A.MsgPtr_Reset.all, NL => True);
         when ARMv7A.Undefined_Instruction =>
            Console.Print (ARMv7A.MsgPtr_Undefined_Instruction.all, NL => True);
         when ARMv7A.Supervisor_Call       =>
            Console.Print (ARMv7A.MsgPtr_Supervisor_Call.all, NL => True);
         when ARMv7A.Prefetch_Abort        =>
            Console.Print (ARMv7A.MsgPtr_Prefetch_Abort.all, NL => True);
         when ARMv7A.Data_Abort            =>
            Console.Print (ARMv7A.MsgPtr_Data_Abort.all, NL => True);
         when ARMv7A.Notused               =>
            Console.Print (ARMv7A.MsgPtr_Notused.all, NL => True);
         when others                       =>
            Console.Print (ARMv7A.MsgPtr_UNKNOWN.all, NL => True);
      end case;
      Console.Print (LR, NL => True);
      Abort_Library.System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
      is
   begin
      -- ttc
      declare
         Unused : ZynqA9.XTTCPS_ISR_Type;
      begin
         Unused := ZynqA9.TTC0.ISR (0);
      end;
      BSP.Tick_Count := @ + 1;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is null;

end Exceptions;
