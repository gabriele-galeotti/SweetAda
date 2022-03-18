
with System.Storage_Elements;
with Interfaces;
with BSP;
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
   use BSP;

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
         begin
            IOEMU.IOEMU_IO0 := 0;
            IOEMU.IOEMU_IO1 := 0;
            loop
               Console.Print ("hello, SweetAda", NL => True);
               -- IOEMU GPIO test
               IOEMU.IOEMU_IO0 := 1;
               IOEMU.IOEMU_IO0 := 0;
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
