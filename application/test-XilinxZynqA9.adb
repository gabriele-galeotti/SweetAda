
with Interfaces;
with CPU;
with IOEMU;
with Console;

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
      if True then
         declare
            Delay_Count : constant := 100_000_000;
            Value       : Unsigned_8;
         begin
            Value := 0;
            IOEMU.IOEMU_IO1 := 0;
            loop
               if (Value mod 10) = 0 then
                  Console.Print ("hello, SweetAda", NL => True);
               end if;
               Value := @ + 1;
               IOEMU.IOEMU_IO1 := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
