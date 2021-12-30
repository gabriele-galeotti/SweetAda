
with System.Storage_Elements;
with Interfaces;
-- with PowerPC;
-- with PPC405;
with CPU;
with Taihu;
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
   -- use PowerPC;
   -- use PPC405;
   use Taihu;

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
            Delay_Count : constant := 100_000_000;
            Value       : Unsigned_8;
         begin
            Value := 0;
            loop
               IOEMU.IOEMU_IO1 := Value;
               Value := @ + 1;
               Console.Print ("hello, SweetAda", NL => True);
               -- Console.Print (Tick_Count, NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
