
with System.Storage_Elements;
with Interfaces;
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
            Delay_Count : constant := 100_000_000;
            Value       : Unsigned_8;
         begin
            Value := 0;
            loop
               if Configure.USE_QEMU_IOEMU then
                  IOEMU.IO1 := Value;
               end if;
               Value := @ + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               Console.Print (Character'('.'));
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
