
with System.Storage_Elements;
with Interfaces;
with Core;
with ML605;
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
   use ML605;

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
      if False then
         Console.Print ("*** SWITCH TEST IN PROGRESS ***", NL => True);
         loop
            IOEMU.IO1 := IOEMU.IO3;
         end loop;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 50_000_000; -- normal
            -- Delay_Count : constant := 10; -- debug
            Value       : Unsigned_8;
         begin
            Value := 0;
            IOEMU.IO1 := 0;
            loop
               if (Value mod 10) = 0 then
                  Console.Print ("hello, SweetAda", NL => True);
                  Console.Print (Core.Tick_Count, NL => True);
               end if;
               Value := @ + 1;
               IOEMU.IO1 := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
