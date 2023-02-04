
with Interfaces;
with Core;
with Configure;
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
            Delay_Count : Integer;
         begin
            Delay_Count := (if Core.Debug_Flag then 500_000_000 else 500_000_000);
            if Configure.USE_QEMU_IOEMU then
               IOEMU.IOEMU_IO1 := 0;
               IOEMU.IOEMU_IO2 := 0;
            end if;
            loop
               if Configure.USE_QEMU_IOEMU then
                  IOEMU.IOEMU_IO1 := @ + 1;
                  IOEMU.IOEMU_IO2 := @ + 1;
               end if;
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
