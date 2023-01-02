
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
         procedure SetPin (Pin : in Integer);
         procedure SetPin (Pin : in Integer) is
         begin
            -- GPIO #19/21/22 = IOF0, output, enabled
            HiFive1.GPIO_IOFSEL (Pin) := False;
            HiFive1.GPIO_PORT (Pin) := True;
            HiFive1.GPIO_OEN (Pin) := True;
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
            HiFive1.GPIO_PORT (22) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.GPIO_PORT (22) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on GREEN (GPIO #19)
            HiFive1.GPIO_PORT (19) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.GPIO_PORT (19) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on BLUE (GPIO #21)
            HiFive1.GPIO_PORT (21) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            HiFive1.GPIO_PORT (21) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
