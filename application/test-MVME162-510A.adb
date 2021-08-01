
with Interfaces;
with MVME162FX;
with Console;

package body Application is

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
      if True then
         declare
            Delay_Count : constant := 1_000_000;
         begin
            loop
               Console.Print ("MVME162-510A", NL => True);
               MVME162FX.RESET_SCR := MVME162FX.RESET_SCR xor 16#02#;
               for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
