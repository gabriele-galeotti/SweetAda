
with Interfaces;
with Bits;
with CPU;
with RPI3;
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
      declare
         Delay_Count : constant := 1_000_000;
      begin
         -- GPIO16 pin #36 is an output
         RPI3.GPFSEL1 := (@ and 16#FFE3_FFFF#) or 16#0004_0000#;
         while True loop
            RPI3.LEDON := 16#0001_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            RPI3.LEDOFF := 16#0001_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            Console.Print ("hello, SweetAda", NL => True);
         end loop;
      end;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
