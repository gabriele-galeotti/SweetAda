
with CPU;
with MTIME;
with NEORV32;
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

   use NEORV32;

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
            Delay_Count : constant := 5_000_000;
            LED_n       : Natural := 0;
         begin
            loop
               Console.Print (Value => MTIME.mtime_Read, NL => True);
               GPIO.PORT_OUT (LED_n) := True;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               GPIO.PORT_OUT (LED_n) := False;
               LED_n := @ + 1;
               if LED_n > 7 then
                  LED_n := 0;
               end if;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
