
with CPU;
with K61;
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

   use K61;

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
            Delay_Count : constant := 20_000_000;
         begin
            -- LED3 RED -------------------------------------------------------
            PORTF_MUXCTRL.PCR (12).MUX := MUX_GPIO;
            GPIOF.PDDR (12) := True;
            loop
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               GPIOF.PSOR (12) := True;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               GPIOF.PCOR (12) := True;
               Console.Print ("hello, SweetAda", NL => True);
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
