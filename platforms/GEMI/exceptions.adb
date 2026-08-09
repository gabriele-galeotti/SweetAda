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

with Interfaces;
with Abort_Library;
with SH7032;
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

   use Interfaces;
   use SH7032;

   procedure Exception_Process
      (Code : in Unsigned_32;
       PC   : in Unsigned_32;
       SR   : in Unsigned_32)
      with Export        => True,
           Convention    => Asm,
           External_Name => "exception_process";

   procedure IRQ_Timer_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "irq_timer_process";

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
      (Code : in Unsigned_32;
       PC   : in Unsigned_32;
       SR   : in Unsigned_32)
      is
   begin
      case Code is
         when 4      => Console.Print ("General illegal instruction", NL => True);
         when 6      => Console.Print ("Illegal slot instruction", NL => True);
         when 9      => Console.Print ("CPU address error", NL => True);
         when 10     => Console.Print ("DMA address error", NL => True);
         when 11     => Console.Print ("NMI", NL => True);
         when 12     => Console.Print ("User break", NL => True);
         when 32     => Console.Print ("Trap instruction", NL => True);
         when others => Console.Print ("UNKNOWN EXCEPTION", NL => True);
      end case;
      Console.Print (Prefix => "PC: ", Value => PC, NL => True);
      Console.Print (Prefix => "SR: ", Value => SR, NL => True);
      Abort_Library.System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- IRQ_Timer_Process
   ----------------------------------------------------------------------------
   procedure IRQ_Timer_Process
      is
   begin
      TSR2.IMFA := False;
      BSP.Tick_Count := @ + 1;
      if BSP.Tick_Count mod 1_000 = 0 then
         SH7032.PBDR.DATA (bi3) := not SH7032.PBDR.DATA (bi3);
      end if;
   end IRQ_Timer_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      IPRD.ITU2 := 2; -- priority level
   end Init;

end Exceptions;
