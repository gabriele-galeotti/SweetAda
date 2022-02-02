
with System.Storage_Elements;
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
         -- IOEMU GPIO test
         declare
            Delay_Count : constant := 300_000_000;
         begin
            IOEMU.IOEMU_IO1 := 0;
            IOEMU.IOEMU_IO2 := 0;
            loop
               IOEMU.IOEMU_IO1 := @ + 1;
               IOEMU.IOEMU_IO2 := @ + 1;
               Console.Print ("hello, SweetAda", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
