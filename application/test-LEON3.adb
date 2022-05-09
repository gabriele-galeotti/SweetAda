
with System.Storage_Elements;
with Interfaces;
with CPU;
with LEON3;
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

   use System.Storage_Elements;
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
            Value : Unsigned_8;
         begin
            Value := 0;
            loop
               loop
                  exit when LEON3.GPTIMER.Control_Register_1.IP;
               end loop;
               LEON3.GPTIMER.Control_Register_1.IP := False;
               -- IOEMU "TIMER" LED blinking
               IOEMU.IOEMU_IO0 := 1;
               IOEMU.IOEMU_IO0 := 0;
               -- IOEMU GPIO test
               Value := @ + 1;
               IOEMU.IOEMU_IO1 := Value;
               Console.Print ("hello, SweetAda", NL => True);
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
