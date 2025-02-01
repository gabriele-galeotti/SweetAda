
with Interfaces;
with CPU;
with PL031;
with PL110;
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
      if True then
         PL110.Print (0, 0, "hello SweetAda ...");
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 300_000_000;
         begin
            loop
               Console.Print ("Hello, SweetAda", NL => True);
               declare
                  TM : Time.TM_Time;
               begin
                  Console.Print ("Current date: ", NL => False);
                  PL031.Read_Clock (BSP.PL031_Descriptor, TM);
                  Console.Print (Prefix => "",  Value => TM.Year + 1_900);
                  Console.Print (Prefix => "-", Value => TM.Mon + 1);
                  Console.Print (Prefix => "-", Value => TM.MDay);
                  Console.Print (Prefix => " ", Value => TM.Hour);
                  Console.Print (Prefix => ":", Value => TM.Min);
                  Console.Print (Prefix => ":", Value => TM.Sec);
                  Console.Print_NewLine;
               end;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
