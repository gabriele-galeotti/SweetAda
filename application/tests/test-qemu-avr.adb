
with CPU;
with ATmega328P;
with Console;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use ATmega328P;

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
      Delay_Count : constant Long_Integer := 5_000_000;
   begin
      -------------------------------------------------------------------------
      if True then
         loop
            Console.Print ("hello, SweetAda", NL => True);
            PORTB (5) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORTB (5) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
