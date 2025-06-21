
with Interfaces;
with Bits;
with CPU;
with KL46Z;
with LCD;
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
   use Bits;
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
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 10_000_000;
            N           : Natural;
            Colon       : Boolean;
         begin
            -- LED1 (GREEN)
            PORTD_MUXCTRL.PCR (5).MUX := MUX_GPIO;
            GPIOD.PDDR (5) := True;
            N     := 0;
            Colon := False;
            while True loop
               GPIOD.PTOR (5) := True;
               Console.Print ("hello, SweetAda", NL => True);
               LCD.Digit_Set (1, N + 0);
               LCD.Digit_Set (2, N + 1);
               LCD.Digit_Set (3, N + 2);
               LCD.Digit_Set (4, N + 3);
               N := @ + 1;
               if N > 6 then
                  N := 0;
               end if;
               LCD.Colon_Set (Colon);
               Colon := not @;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
