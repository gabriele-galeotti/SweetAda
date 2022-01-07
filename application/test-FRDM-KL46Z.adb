
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

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Run is
   begin
      -------------------------------------------------------------------------
      -- blink on-board LED
      declare
         Delay_Count : constant := 3_000_000;
      begin
         KL46Z.SIM_SCGC5.PORTD := True;
         KL46Z.SIM_SCGC5.PORTE := True;
         -- LED1 (GREEN)
         KL46Z.PORTD_PCR05.MUX := KL46Z.MUX_ALT1_GPIO;
         KL46Z.GPIOD_PDDR.PDD05 := True;
         -- LED2 (RED)
         KL46Z.PORTE_PCR29.MUX := KL46Z.MUX_ALT1_GPIO;
         KL46Z.GPIOE_PDDR.PDD29 := True;
         while True loop
            KL46Z.GPIOD_PTOR.PTTO05 := True;
            KL46Z.GPIOE_PTOR.PTTO29 := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
