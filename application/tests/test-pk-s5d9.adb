
with Interfaces;
with Bits;
with CPU;
with S5D9;
with LCD;
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
   use S5D9;

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
      declare
         Delay_Count : constant := 5_000_000;
      begin
         while True loop
            -- blink LED3 (yellow)
            PORT (6).PODR (2) := False;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            PORT (6).PODR (2) := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            Console.Print ("hello, SweetAda", NL => True);
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
