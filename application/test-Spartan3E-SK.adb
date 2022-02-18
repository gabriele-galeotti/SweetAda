
with CPU;
with Spartan3E;

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
      if True then
         declare
            Delay_Count : constant := 5_000_000;
         begin
            Spartan3E.LEDs_TS := 16#00#;
            loop
               Spartan3E.LEDs_IO := 16#FF#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Spartan3E.LEDs_IO := 16#0#;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
