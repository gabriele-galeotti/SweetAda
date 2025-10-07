
with CPU;
with LPC2148;

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
         -- blink LED1 & LED2
         LPC2148.IO0DIR := [10 | 11 => True, others => False];
         loop
            LPC2148.IO0SET (10) := True;
            LPC2148.IO0CLR (11) := True;
            for Delay_Loop_Count in 1 .. 5_000_000 loop CPU.NOP; end loop;
            LPC2148.IO0CLR (10) := True;
            LPC2148.IO0SET (11) := True;
            for Delay_Loop_Count in 1 .. 5_000_000 loop CPU.NOP; end loop;
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
