
with Interfaces;
with CPU;
with Configure;
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
            Delay_Count : constant := 30_000_000;
            Value       : Unsigned_8;
         begin
            Value := 0;
            if Configure.USE_QEMU_IOEMU then
               IOEMU.IOEMU_IO1 := 0;
            end if;
            loop
               if (Value mod 10) = 0 then
                  Console.Print ("hello, SweetAda", NL => True);
               end if;
               Value := @ + 1;
               if Configure.USE_QEMU_IOEMU then
                  IOEMU.IOEMU_IO1 := @ + 1;
               end if;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
