
with System.Storage_Elements;
with Interfaces;
with Configure;
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
            if Configure.USE_QEMU_IOEMU then
               IOEMU.IO0 := 0;
               IOEMU.IO1 := 0;
            end if;
            loop
               Console.Print ("hello, SweetAda", NL => True);
               if Configure.USE_QEMU_IOEMU then
                  -- IOEMU GPIO test
                  IOEMU.IO0 := 1;
                  IOEMU.IO0 := 0;
                  IOEMU.IO1 := @ + 1;
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
