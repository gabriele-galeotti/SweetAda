
with Interfaces;
with CPU;
with KL46Z;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use KL46Z;

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
      -- blink on-board LED
      declare
         Delay_Count : constant := 3_000_000;
      begin
         SIM_SCGC5.PORTD := True;
         SIM_SCGC5.PORTE := True;
         -- LED1 (GREEN)
         PORTD_PCR (5).MUX := MUX_ALT1_GPIO;
         GPIOD_PDDR (5) := True;
         -- LED2 (RED)
         PORTE_PCR (29).MUX := MUX_ALT1_GPIO;
         GPIOE_PDDR (29) := True;
         while True loop
            GPIOD_PTOR (5) := True;
            GPIOE_PTOR (29) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
