
with CPU;
with Spartan3A;

package body Application is

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
   begin
      -------------------------------------------------------------------------
      declare
         Delay_Count : constant := 10_000_000;
      begin
         Spartan3A.LEDs_TS := 16#0F#;
         loop
            Spartan3A.LEDs_IO := 16#0F#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            Spartan3A.LEDs_IO := 16#0#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
