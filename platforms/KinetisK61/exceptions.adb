-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Configure;
with LLutils;
with Abort_Library;
with ARMv7M;
with CPU;
with K61;
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

   use K61;

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
         when 1  => Console.Print (ARMv7M.MsgPtr_Reset.all, NL => True);
         when 2  => Console.Print (ARMv7M.MsgPtr_NMI.all, NL => True);
         when 3  => Console.Print (ARMv7M.MsgPtr_HardFault.all, NL => True);
         when 4  => Console.Print (ARMv7M.MsgPtr_MemManage.all, NL => True);
         when 5  => Console.Print (ARMv7M.MsgPtr_BusFault.all, NL => True);
         when 6  => Console.Print (ARMv7M.MsgPtr_UsageFault.all, NL => True);
         when 11 => Console.Print (ARMv7M.MsgPtr_SVCall.all, NL => True);
         when 14 => Console.Print (ARMv7M.MsgPtr_PendSV.all, NL => True);
         when 15 => Console.Print (ARMv7M.MsgPtr_SysTick.all, NL => True);
         when 7 .. 10 | 12 .. 13 =>
            Console.Print (ARMv7M.MsgPtr_Reserved.all, NL => True);
         when others             =>
            Console.Print ("UNKNOWN", NL => True);
      end case;
      Console.Print (LR, NL => True);
      Abort_Library.System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- SysTick_Process
   ----------------------------------------------------------------------------
   procedure SysTick_Process
      is
   begin
      BSP.Tick_Count := @ + 1;
      -- blink on-board LED2 YELLOW
      if (BSP.Tick_Count mod Configure.TICK_FREQUENCY) = 0 then
         GPIOF.PTOR (11) := True;
      end if;
   end SysTick_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
      is
   begin
      null;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Vector_Table : constant Asm_Entry_Point
         with Import        => True,
              External_Name => "vectors";
   begin
      ARMv7M.VTOR.TBLOFF := Bits_25 (LLutils.Select_Address_Bits (Vector_Table'Address, 7, 31));
      -- LED2 YELLOW
      PORTF_MUXCTRL.PCR (11).MUX := MUX_GPIO;
      GPIOF.PDDR (11) := True;
   end Init;

end Exceptions;
