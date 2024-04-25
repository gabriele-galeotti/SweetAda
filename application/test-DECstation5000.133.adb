
with System.Storage_Elements;
with Interfaces;
with Configure;
with MMIO;
with MIPS;
with R3000;
with CPU;
with KN02BA;
with MC146818A;
with BSP;
with Console;
with Time;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use MIPS;
   use R3000;
   use KN02BA;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run
      is
   begin
      -- rear LEDs test -------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
            TM          : Time.TM_Time;
         begin
            Delay_Count := (if Configure.BOOT_FROM_NETWORK then 5_000_000 else 33_333);
            -- 01/01/2024 00:00:00
            TM := (
               Sec    => 0,
               Min    => 0,
               Hour   => 0,
               MDay   => 1,
               Mon    => 1 - 1,
               Year   => 24,
               others => 0
               );
            MC146818A.Set_Clock (BSP.RTC_Descriptor, TM);
            loop
               IOASIC_SSR.LED0 := False;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               IOASIC_SSR.LED0 := True;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               if True then
                  Console.Print ("Current date: ", NL => False);
                  MC146818A.Read_Clock (BSP.RTC_Descriptor, TM);
                  Console.Print (TM.Year + 1_900, NL => False);
                  Console.Print ("-", NL => False);
                  Console.Print (TM.Mon + 1, NL => False);
                  Console.Print ("-", NL => False);
                  Console.Print (TM.MDay, NL => False);
                  Console.Print (" ", NL => False);
                  Console.Print (TM.Hour, NL => False);
                  Console.Print (":", NL => False);
                  Console.Print (TM.Min, NL => False);
                  Console.Print (":", NL => False);
                  Console.Print (TM.Sec, NL => False);
                  Console.Print_NewLine;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
