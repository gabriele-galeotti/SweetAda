
with Interfaces;
with Bits;
with CPU;
with KL46Z;
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
            DIGITON     : constant LCD_Waveform_Type := (C => True, others => False);
            DIGITOFF    : constant LCD_Waveform_Type := (others => False);
            Spin        : Bits_2;
            Digit1 renames LCD_WF (9).WF (1);
            Digit2 renames LCD_WF (1).WF (3);
            Digit3 renames LCD_WF (13).WF (1);
            Digit4 renames LCD_WF (2).WF (2);
         begin
            -- LED1 (GREEN)
            PORTD_MUXCTRL.PCR (5).MUX := MUX_GPIO;
            GPIOD.PDDR (5) := True;
            Spin := 0;
            while True loop
               GPIOD.PTOR (5) := True;
               Console.Print ("hello, SweetAda", NL => True);
               case Spin is
                  when 0 => Digit4 := DIGITOFF; Digit1 := DIGITON;
                  when 1 => Digit1 := DIGITOFF; Digit2 := DIGITON;
                  when 2 => Digit2 := DIGITOFF; Digit3 := DIGITON;
                  when 3 => Digit3 := DIGITOFF; Digit4 := DIGITON;
               end case;
               Spin := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
