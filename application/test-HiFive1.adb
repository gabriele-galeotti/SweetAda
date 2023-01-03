
with Interfaces;
with CPU;
with HiFive1;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use HiFive1;

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
      use GPIO;
   begin
      -------------------------------------------------------------------------
      declare
         procedure SetPin (Pin : in Integer);
         procedure SetPin (Pin : in Integer) is
         begin
            -- GPIO #19/21/22 = IOF0, output, enabled
            IOFSEL (Pin) := False;
            PORT (Pin) := True;
            OEN (Pin) := True;
         end SetPin;
      begin
         SetPin (19);
         SetPin (21);
         SetPin (22);
      end;
      declare
         Delay_Count : constant := 10_000_000;
      begin
         while True loop
            -- turn on RED (GPIO #22)
            PORT (22) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORT (22) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on GREEN (GPIO #19)
            PORT (19) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORT (19) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on BLUE (GPIO #21)
            PORT (21) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORT (21) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
