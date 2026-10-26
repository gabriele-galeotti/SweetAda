
with Interfaces;
with CPU;
with HiFive1;
with BSP;
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
   procedure Run
      is
      use GPIO;
   begin
      -------------------------------------------------------------------------
      declare
         procedure SetPin
            (Pin : in Integer);
         procedure SetPin
            (Pin : in Integer)
            is
         begin
            -- GPIO #19/21/22 = IOF0, output, enabled
            iof_sel (Pin) := False;
            output_val (Pin) := True;
            output_en (Pin) := True;
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
            output_val (22) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            output_val (22) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on GREEN (GPIO #19)
            output_val (19) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            output_val (19) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            -- turn on BLUE (GPIO #21)
            output_val (21) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            output_val (21) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            Console.Print (Prefix => "Ticks: ", Value => BSP.Tick_Count, NL => True);
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
