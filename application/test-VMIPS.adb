
with CPU;
with VMIPS;
with BSP;
with Console;

package body Application
   is

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
            Delay_Count : constant := 1_000_000;
            C           : Character;
         begin
            loop
               -- BSP.Console_Getchar (C);
               -- BSP.Console_Putchar (C);
               Console.Print (VMIPS.CLOCK.SECONDS_RT, Prefix => "clock: ", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
