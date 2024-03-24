
with System.Storage_Elements;
with Interfaces;
with Bits;
with CPU;
with Virt;
with Console;
with BSP;
with Goldfish;
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
            Delay_Count : constant := 300_000_000;
            TM          : Time.TM_Time;
         begin
            loop
               Goldfish.Read_Clock (BSP.RTC_Descriptor, TM);
               Console.Print (Time.Day_Of_Week (Time.NDay_Of_Week (TM.MDay, TM.Mon + 1, TM.Year + 1_900)));
               Console.Print (" ");
               Console.Print (Time.Month_Name (TM.Mon + 1));
               Console.Print (" ");
               Console.Print (TM.MDay);
               Console.Print (" ");
               Console.Print (TM.Year + 1_900);
               Console.Print (" ");
               Console.Print (TM.Hour);
               Console.Print (":");
               Console.Print (TM.Min);
               Console.Print (":");
               Console.Print (TM.Sec);
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
