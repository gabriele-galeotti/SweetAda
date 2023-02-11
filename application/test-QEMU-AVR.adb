
with CPU;
with ATmega328P;

package body Application is

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
   procedure Run is
      Delay_Count : constant := 3;
      NBlinks     : constant := 6;
   begin
      -------------------------------------------------------------------------
      if True then
         loop
            for N in 1 .. NBlinks loop
               PORTB.PORTB5 := True;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               PORTB.PORTB5 := False;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
