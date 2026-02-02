
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
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : Integer;
            TM          : Time.TM_Time;
         begin
            -- Delay_Count := (if Configure.BOOT_FROM_NETWORK then 5_000_000 else 33_333);
            Delay_Count := 30_000_000; -- GXemul
            loop
               -- dump RTC time -----------------------------------------------
               Console.Print ("Current date: ", NL => False);
               MC146818A.Read_Clock (BSP.RTC_Descriptor, TM);
               Console.Print (Prefix => "",  Value => TM.Year + 1_900);
               Console.Print (Prefix => "-", Value => TM.Mon + 1);
               Console.Print (Prefix => "-", Value => TM.MDay);
               Console.Print (Prefix => " ", Value => TM.Hour);
               Console.Print (Prefix => ":", Value => TM.Min);
               Console.Print (Prefix => ":", Value => TM.Sec);
               Console.Print_NewLine;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
